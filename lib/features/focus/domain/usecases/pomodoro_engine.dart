import 'dart:async';
import 'package:flutter/foundation.dart';
import '../entities/focus_session.dart';
import '../entities/focus_session_state.dart';
import '../entities/state_machine.dart';

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

  FocusSession _session = const FocusSession(
    id: '',
    task: '',
    startedAt: DateTime.now(),
    plannedDuration: Duration(minutes: 25),
  );

  void startSession(FocusSession session) {
    _session = session.copyWith(
      status: SessionStatus.running,
      startedAt: DateTime.now(),
    );

    _endTimestamp = DateTime.now().add(session.plannedDuration);

    _currentState = FocusSessionState(
      session: _session,
      remaining: session.plannedDuration,
      currentCycle: 1,
    );

    _startTimer();
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
    _endTimestamp = DateTime.now().add(_currentState!.remaining);

    _startTimer();

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

    _breakEndTimestamp = DateTime.now().add(breakDuration);

    _currentState = _currentState!.copyWith(
      isBreak: true,
      breakRemaining: breakDuration,
    );

    _startBreakTimer();
    _stateController.add(_currentState!);
  }

  void completeBreak() {
    if (_currentState == null) return;

    final nextCycle = _currentState!.currentCycle + 1;

    if (nextCycle > _session.cycles) {
      complete();
      return;
    }

    _currentState = _currentState!.copyWith(
      isBreak: false,
      currentCycle: nextCycle,
      breakRemaining: Duration.zero,
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
    _breakTimer = Timer.periodic(const Duration(seconds: 1), (_) => _breakTick());
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
    } else {
      final breakDuration = completedCycles % 4 == 0
          ? const Duration(minutes: 15)
          : const Duration(minutes: 5);

      startBreak(breakDuration);
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
