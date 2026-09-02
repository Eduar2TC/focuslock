import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focuslock/core/utils/score_calculator.dart';
import 'package:focuslock/features/focus/domain/entities/focus_session.dart';
import 'package:focuslock/features/focus/domain/entities/focus_session_state.dart';
import 'package:focuslock/features/focus/domain/usecases/pomodoro_engine.dart';
import 'package:focuslock/features/settings/data/repositories/settings_repository.dart';
import 'package:focuslock/features/apps/data/repositories/app_repository.dart';
import 'package:focuslock/core/services/native_focus_service.dart';
import 'package:focuslock/features/focus/data/repositories/focus_session_repository.dart';

class FocusSessionController extends StateNotifier<FocusSessionState?> {
  final PomodoroEngine _engine;
  final SettingsRepository _settings;
  final AppRepository _appRepository;
  final NativeFocusService _nativeService;
  final FocusSessionRepository _sessionRepository;

  StreamSubscription<FocusSessionState>? _stateSubscription;

  FocusSessionController(
    this._engine,
    this._settings,
    this._appRepository,
    this._nativeService,
    this._sessionRepository,
  ) : super(null) {
    _stateSubscription = _engine.stateStream.listen((sessionState) {
      state = sessionState;
    });
  }

  void prepareSession(String task) {
    final session = FocusSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      task: task,
      startedAt: DateTime.now(),
      plannedDuration: Duration(minutes: _settings.focusDuration),
      cycles: _settings.cycles,
      status: SessionStatus.preparing,
    );

    state = FocusSessionState(
      session: session,
      remaining: session.plannedDuration,
    );
  }

  void startSession() {
    if (state == null) return;

    final session = state!.session;
    _engine.setBreakDurations(_settings.shortBreak, _settings.longBreak);
    _engine.startSession(session);

    final blockedApps = _appRepository.getActiveBlockedPackages();
    _nativeService.startBlocking(blockedApps);

    _nativeService.startForegroundService(
      'Focus Session Active',
      '${session.task} - ${session.plannedDuration.inMinutes} minutes',
    );
  }

  void pause() {
    _engine.pause();
  }

  void resume() {
    _engine.resume();
  }

  void cancel() {
    _engine.cancel();
    _nativeService.stopBlocking();
    _nativeService.stopForegroundService();
    _saveSession(SessionStatus.cancelled);
  }

  void completeSession() {
    _engine.complete();
    _nativeService.stopBlocking();
    _nativeService.stopForegroundService();
    _saveSession(SessionStatus.completed);
  }

  void _saveSession(SessionStatus finalStatus) {
    if (state == null) return;

    final session = state!.session;
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
      actualDuration: Duration(seconds: _engine.totalElapsedSeconds),
      score: score,
    );

    _sessionRepository.saveSession(completedSession);
  }

  void onBlockedAppAttempted(String packageName) {
    if (state == null) return;

    final currentSession = state!.session;
    final updatedSession = currentSession.copyWith(
      blockedAttemptCount: currentSession.blockedAttemptCount + 1,
    );

    state = state!.copyWith(session: updatedSession);
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

  void recoverSession() {
    if (state == null) return;

    if (state!.session.isActive) {
      _nativeService.startBlocking(_appRepository.getActiveBlockedPackages());
      _nativeService.startForegroundService(
        'Focus Session Active',
        '${state!.session.task} - ${state!.remaining.inMinutes} minutes remaining',
      );
    }
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _engine.dispose();
    super.dispose();
  }
}
