import 'dart:async';
import 'package:focuslock/features/focus/domain/entities/focus_session.dart';
import 'package:focuslock/features/focus/domain/entities/focus_session_state.dart';
import 'package:focuslock/features/focus/domain/entities/state_machine.dart';

class PomodoroEngine {
  final FocusSessionStateMachine _stateMachine = FocusSessionStateMachine();
  Timer? _timer;
  Timer? _breakTimer;

  final StreamController<FocusSessionState> _stateController =
      StreamController<FocusSessionState>.broadcast();
  Stream<FocusSessionState> get stateStream => _stateController.stream;

  FocusSessionState? _currentState;
  FocusSessionState? get currentState => _currentState;

  DateTime? _endTimestamp;
  DateTime? _breakEndTimestamp;
  DateTime? _sessionStartTime;

  int _shortBreakMinutes = 5;
  int _longBreakMinutes = 15;

  FocusSession _session = FocusSession(
    id: '',
    task: '',
    startedAt: DateTime.now(),
    plannedDuration: Duration(minutes: 25),
  );

  Duration _totalPausedDuration = Duration.zero;
  DateTime? _pauseStartTime;

  int get totalElapsedSeconds {
    if (_sessionStartTime == null) return 0;
    return DateTime.now().difference(_sessionStartTime!).inSeconds;
  }

  int get actualElapsedSeconds {
    if (_sessionStartTime == null) return 0;
    final total = DateTime.now().difference(_sessionStartTime!);
    final paused = _totalPausedDuration +
        (_pauseStartTime != null
            ? DateTime.now().difference(_pauseStartTime!)
            : Duration.zero);
    return (total - paused).inSeconds;
  }

  void setBreakDurations(int shortBreakMinutes, int longBreakMinutes) {
    _shortBreakMinutes = shortBreakMinutes;
    _longBreakMinutes = longBreakMinutes;
  }

  void startSession(FocusSession session) {
    _session = session.copyWith(
      status: SessionStatus.running,
      startedAt: DateTime.now(),
    );
    _sessionStartTime = DateTime.now();

    _endTimestamp = DateTime.now().add(session.plannedDuration);

    _currentState = FocusSessionState(
      session: _session,
      remaining: session.plannedDuration,
      currentCycle: 1,
    );

    _startTimer();
    _stateController.add(_currentState!);
  }

  /// Restores a persisted active session after the app was re-launched from a
  /// cold start, resuming the countdown from the wall clock so time spent
  /// while the app was dead is respected.
  void restoreSession(FocusSession session) {
    _stopTimer();
    _stopBreakTimer();

    _session = session.copyWith(status: SessionStatus.running);
    _sessionStartTime = _session.startedAt;

    _currentState = FocusSessionState(
      session: _session,
      remaining: session.plannedDuration,
      currentCycle: session.completedCycles + 1,
    );

    _endTimestamp = _session.startedAt.add(session.plannedDuration);
    final remaining = recoverRemaining(_endTimestamp!);
    if (remaining == Duration.zero) {
      _handleFocusComplete();
    } else {
      _currentState = _currentState!.copyWith(remaining: remaining);
      _startTimer();
    }
    _stateController.add(_currentState!);
  }

  /// Records a blocked-app attempt on the engine session so it is persisted
  /// through the same single source of truth as the rest of the session data.
  void recordBlockedAttempt() {
    if (_currentState == null) return;

    final current = _currentState!.session;
    _session = current.copyWith(
      blockedAttemptCount: current.blockedAttemptCount + 1,
    );
    _currentState = _currentState!.copyWith(session: _session);
    _stateController.add(_currentState!);
  }

  void pause() {
    if (_currentState == null) return;

    final newStatus = _stateMachine.transition(
      _session.status,
      SessionStatus.paused,
    );

    _session = _session.copyWith(status: newStatus);
    _stopTimer();
    _stopBreakTimer();
    _pauseStartTime = DateTime.now();

    _currentState = _currentState!.copyWith(
      session: _session,
      isPaused: true,
    );

    _stateController.add(_currentState!);
  }

  void resume() {
    if (_currentState == null) return;

    final newStatus = _stateMachine.transition(
      _session.status,
      SessionStatus.running,
    );

    _session = _session.copyWith(status: newStatus);

    if (_pauseStartTime != null) {
      _totalPausedDuration += DateTime.now().difference(_pauseStartTime!);
      _pauseStartTime = null;
    }

    if (_currentState!.isBreak) {
      _breakEndTimestamp = DateTime.now().add(_currentState!.breakRemaining);
      _startBreakTimer();
    } else {
      _endTimestamp = DateTime.now().add(_currentState!.remaining);
      _startTimer();
    }

    _currentState = _currentState!.copyWith(
      session: _session,
      isPaused: false,
    );

    _stateController.add(_currentState!);
  }

  void cancel() {
    if (_currentState == null) return;

    final newStatus = _stateMachine.transition(
      _session.status,
      SessionStatus.cancelled,
    );

    final actualDuration = DateTime.now().difference(_session.startedAt);

    _session = _session.copyWith(
      status: newStatus,
      endedAt: DateTime.now(),
      actualDuration: actualDuration,
    );

    _stopTimer();
    _stopBreakTimer();

    _currentState = _currentState!.copyWith(session: _session);
    _stateController.add(_currentState!);
  }

  void complete() {
    if (_currentState == null) return;

    final actualDuration = DateTime.now().difference(_session.startedAt);

    _session = _session.copyWith(
      status: SessionStatus.completed,
      endedAt: DateTime.now(),
      actualDuration: actualDuration,
    );

    _stopTimer();
    _stopBreakTimer();

    _currentState = _currentState!.copyWith(session: _session);
    _stateController.add(_currentState!);
  }

  void startBreak(Duration breakDuration) {
    if (_currentState == null) return;

    _stopTimer();

    _breakEndTimestamp = DateTime.now().add(breakDuration);

    _currentState = _currentState!.copyWith(
      isBreak: true,
      breakRemaining: breakDuration,
      breakTotal: breakDuration,
    );

    _startBreakTimer();
    _stateController.add(_currentState!);
  }

  void completeBreak() {
    if (_currentState == null) return;

    _stopBreakTimer();

    final nextCycle = _currentState!.currentCycle + 1;

    if (nextCycle > _session.cycles) {
      complete();
      return;
    }

    _currentState = _currentState!.copyWith(
      isBreak: false,
      currentCycle: nextCycle,
      breakRemaining: Duration.zero,
      breakTotal: Duration.zero,
    );

    _session = _session.copyWith(
      status: SessionStatus.running,
      startedAt: DateTime.now(),
    );

    _endTimestamp = DateTime.now().add(_session.plannedDuration);
    _startTimer();

    _stateController.add(_currentState!);
  }

  void _startTimer() {
    _stopTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _startBreakTimer() {
    _stopBreakTimer();
    _breakTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => _breakTick());
  }

  void _stopBreakTimer() {
    _breakTimer?.cancel();
    _breakTimer = null;
  }

  void _tick() {
    if (_endTimestamp == null || _currentState == null) return;

    final now = DateTime.now();
    final remaining = _endTimestamp!.difference(now);

    if (remaining.isNegative) {
      _handleFocusComplete();
      return;
    }

    _currentState = _currentState!.copyWith(remaining: remaining);
    _stateController.add(_currentState!);
  }

  void _breakTick() {
    if (_breakEndTimestamp == null || _currentState == null) return;

    final now = DateTime.now();
    final remaining = _breakEndTimestamp!.difference(now);

    if (remaining.isNegative) {
      completeBreak();
      return;
    }

    _currentState = _currentState!.copyWith(breakRemaining: remaining);
    _stateController.add(_currentState!);
  }

  void _handleFocusComplete() {
    final completedCycles = _currentState!.currentCycle;
    final totalCycles = _session.cycles;

    final updatedSession = _session.copyWith(
      completedCycles: completedCycles,
    );

    _currentState = _currentState!.copyWith(session: updatedSession);

    if (completedCycles >= totalCycles) {
      complete();
    } else if (completedCycles % 4 == 0) {
      startBreak(Duration(minutes: _longBreakMinutes));
    } else {
      startBreak(Duration(minutes: _shortBreakMinutes));
    }
  }

  Duration recoverRemaining(DateTime endTimestamp) {
    final now = DateTime.now();
    final remaining = endTimestamp.difference(now);
    return remaining.isNegative ? Duration.zero : remaining;
  }

  void recoverFromBackground(DateTime endTimestamp) {
    _endTimestamp = endTimestamp;
    final remaining = recoverRemaining(endTimestamp);

    if (remaining == Duration.zero) {
      _handleFocusComplete();
    } else {
      _startTimer();
      if (_currentState != null) {
        _currentState = _currentState!.copyWith(remaining: remaining);
        _stateController.add(_currentState!);
      }
    }
  }

  void dispose() {
    _stopTimer();
    _stopBreakTimer();
    _stateController.close();
  }
}
