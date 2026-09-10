import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focuslock/core/utils/score_calculator.dart';
import 'package:focuslock/features/focus/domain/entities/focus_session.dart';
import 'package:focuslock/features/focus/domain/entities/focus_session_state.dart';
import 'package:focuslock/features/focus/domain/usecases/pomodoro_engine.dart';
import 'package:focuslock/features/settings/data/repositories/settings_repository.dart';
import 'package:focuslock/features/apps/data/repositories/app_repository.dart';
import 'package:focuslock/core/services/native_focus_service.dart';
import 'package:focuslock/core/services/active_run_store.dart';
import 'package:focuslock/features/focus/data/repositories/focus_session_repository.dart';
import 'package:focuslock/l10n/app_localizations.dart';
import 'package:focuslock/l10n/l10n_access.dart';

class FocusSessionController extends StateNotifier<FocusSessionState?> {
  final PomodoroEngine _engine;
  final SettingsRepository _settings;
  final AppRepository _appRepository;
  final NativeFocusService _nativeService;
  final FocusSessionRepository _sessionRepository;
  final ActiveRunStore _runStore;

  StreamSubscription<FocusSessionState>? _stateSubscription;

  FocusSessionController(
    this._engine,
    this._settings,
    this._appRepository,
    this._nativeService,
    this._sessionRepository,
    this._runStore,
  ) : super(null) {
    _stateSubscription = _engine.stateStream.listen((sessionState) {
      if (mounted) {
        final previous = state;
        _detectCycleCompletion(previous, sessionState);
        _detectSessionCompletion(previous, sessionState);
        state = sessionState;
        if (sessionState.session.isActive &&
            previous?.isBreak != sessionState.isBreak) {
          _writeRunSnapshot();
        }
      }
    });
  }

  void _detectCycleCompletion(
      FocusSessionState? previous, FocusSessionState next) {
    if (previous == null) return;

    final sessionJustCompleted =
        previous.session.status != SessionStatus.completed &&
            next.session.status == SessionStatus.completed;
    final focusJustEnded = !previous.isBreak && next.isBreak;

    if (sessionJustCompleted || focusJustEnded) {
      _playAlert();
    }
  }

  bool _sessionSaved = false;
  int? _persistedRowId;

  void _detectSessionCompletion(
      FocusSessionState? previous, FocusSessionState next) {
    if (previous == null || _sessionSaved) return;

    final justCompleted = previous.session.status != SessionStatus.completed &&
        next.session.status == SessionStatus.completed;

    if (justCompleted) {
      _sessionSaved = true;
      completeSession();
    }
  }

  void _playAlert() {
    try {
      _nativeService.playAlert(
        soundEnabled: _settings.soundEnabled,
        vibrationEnabled: _settings.vibrationEnabled,
      );
    } catch (e) {
      // Ignore alert errors
    }
  }

  AppLocalizations? get _l10n => activeAppLocalizations.value;

  bool get _isStrictMode => _settings.enforcementLevel == 'strict';

  String _notificationTitle() {
    return _l10n?.notificationSessionActiveTitle ?? 'Focus Session Active';
  }

  String _notificationBody(String task, int minutes) {
    return _l10n?.notificationSessionActiveBody(task, minutes) ??
        '$task - $minutes minutes';
  }

  String _notificationRecoveringBody(String task, int minutes) {
    return _l10n?.notificationSessionRecoveringBody(task, minutes) ??
        '$task - $minutes minutes remaining';
  }

  void prepareSession(String task, {int? durationMinutes}) {
    _sessionSaved = false;
    _persistedRowId = null;
    _runStore.clear();
    final session = FocusSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      task: task,
      startedAt: DateTime.now(),
      plannedDuration:
          Duration(minutes: durationMinutes ?? _settings.focusDuration),
      cycles: _settings.cycles,
      status: SessionStatus.preparing,
    );

    state = FocusSessionState(
      session: session,
      remaining: session.plannedDuration,
    );
  }

  void startSession() async {
    if (state == null) return;

    final session = state!.session;
    _engine.setBreakDurations(_settings.shortBreak, _settings.longBreak);
    _engine.startSession(session);

    try {
      await _persistActiveSession();
    } catch (e) {
      // Ignore persistence errors - session still runs in memory
    }

    _writeRunSnapshot();

    try {
      final blockedApps = _appRepository.getActiveBlockedPackages();
      // Strict sessions never allow bypassing the block at the OS level.
      await _nativeService.startBlocking(blockedApps,
          allowEmergencyExit: !_isStrictMode && _settings.allowEmergencyExit);

      await _nativeService.startForegroundService(
        _notificationTitle(),
        _notificationBody(
          session.task,
          session.plannedDuration.inMinutes,
        ),
      );
    } catch (e) {
      // Native service calls failed - session still runs but without blocking
    }
  }

  Future<void> _persistActiveSession() async {
    final engineState = _engine.currentState;
    if (engineState == null) return;

    await _sessionRepository.invalidateActiveSessions();

    final session = engineState.session.copyWith(
      status: SessionStatus.running,
    );
    _persistedRowId = await _sessionRepository.saveSession(session);
  }

  void pause() {
    _engine.pause();
    _writeRunSnapshot();
  }

  void resume() {
    _engine.resume();
    _writeRunSnapshot();
  }

  void cancel() async {
    _engine.cancel();
    _runStore.clear();
    try {
      await _nativeService.stopBlocking();
      await _nativeService.stopForegroundService();
    } catch (e) {
      // Ignore native service errors on cleanup
    }
    await _saveSession(SessionStatus.cancelled);
  }

  void completeSession() async {
    final current = _engine.currentState;
    if (current == null || current.session.status != SessionStatus.completed) {
      _engine.complete();
    }
    _runStore.clear();
    try {
      await _nativeService.stopBlocking();
      await _nativeService.stopForegroundService();
    } catch (e) {
      // Ignore native service errors on cleanup
    }
    await _saveSession(SessionStatus.completed);
  }

  Future<void> _saveSession(SessionStatus finalStatus) async {
    final engineState = _engine.currentState;
    if (engineState == null) return;

    final session = engineState.session;
    final score = ScoreCalculator.calculateSessionScore(
      completed: finalStatus == SessionStatus.completed,
      cyclesCompleted: session.completedCycles,
      actualDuration: session.actualDuration,
      interruptionCount: session.interruptionCount,
      blockedAttemptCount: session.blockedAttemptCount,
    );

    final completedSession = session.copyWith(
      endedAt: DateTime.now(),
      status: finalStatus,
      actualDuration: Duration(seconds: _engine.actualElapsedSeconds),
      score: score,
    );

    if (_persistedRowId != null) {
      await _sessionRepository.updateSession(completedSession,
          rowId: _persistedRowId);
      _persistedRowId = null;
    } else {
      await _sessionRepository.saveSession(completedSession);
    }
  }

  void onBlockedAppAttempted(String packageName) {
    if (state == null) return;
    _engine.recordBlockedAttempt();
  }

  int calculateScore() {
    if (state == null) return 0;

    final session = state!.session;
    return ScoreCalculator.calculateSessionScore(
      completed: session.isCompleted,
      cyclesCompleted: session.completedCycles,
      actualDuration: session.actualDuration,
      interruptionCount: session.interruptionCount,
      blockedAttemptCount: session.blockedAttemptCount,
    );
  }

  void recoverSession() async {
    if (state == null) return;

    if (state!.session.isActive) {
      try {
        await _nativeService.startBlocking(
            _appRepository.getActiveBlockedPackages(),
            allowEmergencyExit: _settings.allowEmergencyExit);
        await _nativeService.startForegroundService(
          _notificationTitle(),
          _notificationRecoveringBody(
            state!.session.task,
            state!.remaining.inMinutes,
          ),
        );
      } catch (e) {
        // Ignore native service errors on recovery
      }
    }
  }

  /// Seeds the controller from a persisted active session after a cold start:
  /// re-hydrates the engine countdown (so the clock keeps ticking and the
  /// pause/resume buttons work) and re-engages the native blocking.
  Future<void> restoreActiveSession(FocusSession session) async {
    if (_engine.currentState != null) return;

    _sessionSaved = false;
    _persistedRowId = int.tryParse(session.id);

    _engine.setBreakDurations(_settings.shortBreak, _settings.longBreak);

    final snapshot = _runStore.read();
    if (snapshot != null) {
      _engine.restoreRun(session, snapshot);
    } else {
      _engine.restoreSession(session);
    }
    _writeRunSnapshot();

    try {
      await _nativeService.startBlocking(
        _appRepository.getActiveBlockedPackages(),
        allowEmergencyExit: !_isStrictMode && _settings.allowEmergencyExit,
      );

      final engineState = _engine.currentState;
      await _nativeService.startForegroundService(
        _notificationTitle(),
        _notificationRecoveringBody(
          session.task,
          engineState?.remaining.inMinutes ?? session.plannedDuration.inMinutes,
        ),
      );
    } catch (e) {
      // Native service calls failed - the in-app session still runs
    }
  }

  /// Writes the current live phase of the running session so it can be
  /// resumed precisely if the process gets killed.
  void _writeRunSnapshot() {
    final engineState = _engine.currentState;
    if (engineState == null) return;

    if (!engineState.session.isActive) {
      _runStore.clear();
      return;
    }

    final now = DateTime.now();
    final snapshot = FocusRunSnapshot(
      isOnBreak: engineState.isBreak,
      cycle: engineState.currentCycle,
      breakTotal: engineState.isBreak ? engineState.breakTotal : Duration.zero,
      focusEndAt: !engineState.isBreak && !engineState.isPaused
          ? now.add(engineState.remaining)
          : null,
      breakEndAt: engineState.isBreak && !engineState.isPaused
          ? now.add(engineState.breakRemaining)
          : null,
      pausedRemaining: engineState.isPaused
          ? (engineState.isBreak
              ? engineState.breakRemaining
              : engineState.remaining)
          : null,
      pausedAt: engineState.isPaused ? now : null,
    );
    _runStore.save(snapshot);
  }

  void completeBreak() {
    _engine.completeBreak();
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _engine.dispose();
    super.dispose();
  }
}
