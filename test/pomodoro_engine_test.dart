import 'package:flutter_test/flutter_test.dart';
import 'package:focuslock/features/focus/domain/entities/focus_session.dart';
import 'package:focuslock/features/focus/domain/usecases/pomodoro_engine.dart';

void main() {
  final engines = <PomodoroEngine>[];

  PomodoroEngine newEngine() {
    final engine = PomodoroEngine();
    engines.add(engine);
    return engine;
  }

  tearDownAll(() {
    for (final engine in engines) {
      engine.dispose();
    }
    engines.clear();
  });

  group('PomodoroEngine.restoreRun', () {
    test('focus cycle elapsed while away completes a single-cycle session',
        () {
      final engine = newEngine();
      final startedAt = DateTime.now().subtract(const Duration(minutes: 30));
      final session = FocusSession(
        id: '1',
        task: 'Task',
        startedAt: startedAt,
        plannedDuration: const Duration(minutes: 25),
        cycles: 1,
      );

      engine.restoreRun(
        session,
        FocusRunSnapshot(
          isOnBreak: false,
          cycle: 1,
          focusEndAt: startedAt.add(const Duration(minutes: 25)),
        ),
      );

      expect(engine.currentState!.session.isCompleted, isTrue);
    });

    test('mid-break restore keeps the break running with remaining time', () {
      final engine = newEngine();
      final startedAt = DateTime.now().subtract(const Duration(minutes: 25));
      final session = FocusSession(
        id: '1',
        task: 'Task',
        startedAt: startedAt,
        plannedDuration: const Duration(minutes: 25),
        cycles: 4,
      );

      engine.restoreRun(
        session,
        FocusRunSnapshot(
          isOnBreak: true,
          cycle: 1,
          breakTotal: const Duration(minutes: 5),
          breakEndAt: DateTime.now().add(const Duration(minutes: 2)),
        ),
      );

      final state = engine.currentState!;
      expect(state.isBreak, isTrue);
      expect(state.breakTotal, const Duration(minutes: 5));
      expect(state.breakRemaining.inSeconds, greaterThan(0));
      expect(state.breakRemaining.inSeconds, lessThanOrEqualTo(120));
    });

    test('break elapsed while away advances to the next focus cycle', () {
      final engine = newEngine();
      final startedAt = DateTime.now().subtract(const Duration(minutes: 25));
      final session = FocusSession(
        id: '1',
        task: 'Task',
        startedAt: startedAt,
        plannedDuration: const Duration(minutes: 25),
        cycles: 4,
      );

      engine.restoreRun(
        session,
        FocusRunSnapshot(
          isOnBreak: true,
          cycle: 1,
          breakTotal: const Duration(minutes: 5),
          breakEndAt: DateTime.now().subtract(const Duration(minutes: 1)),
        ),
      );

      final state = engine.currentState!;
      expect(state.isBreak, isFalse);
      expect(state.currentCycle, 2);
      expect(state.session.status, SessionStatus.running);
      expect(state.remaining, const Duration(minutes: 25));
    });

    test('paused restore does not complete and keeps frozen remaining', () {
      final engine = newEngine();
      final startedAt = DateTime.now().subtract(const Duration(minutes: 5));
      final session = FocusSession(
        id: '1',
        task: 'Task',
        startedAt: startedAt,
        plannedDuration: const Duration(minutes: 25),
        cycles: 1,
      );

      engine.restoreRun(
        session,
        FocusRunSnapshot(
          isOnBreak: false,
          cycle: 1,
          pausedRemaining: const Duration(minutes: 20),
          pausedAt: DateTime.now(),
        ),
      );

      final state = engine.currentState!;
      expect(state.isPaused, isTrue);
      expect(state.remaining, const Duration(minutes: 20));
      expect(state.session.isCompleted, isFalse);
    });

    test('paused mid-break restore keeps the break paused', () {
      final engine = newEngine();
      final startedAt = DateTime.now().subtract(const Duration(minutes: 25));
      final session = FocusSession(
        id: '1',
        task: 'Task',
        startedAt: startedAt,
        plannedDuration: const Duration(minutes: 25),
        cycles: 4,
      );

      engine.restoreRun(
        session,
        FocusRunSnapshot(
          isOnBreak: true,
          cycle: 1,
          breakTotal: const Duration(minutes: 5),
          pausedRemaining: const Duration(minutes: 3),
          pausedAt: DateTime.now(),
        ),
      );

      final state = engine.currentState!;
      expect(state.isBreak, isTrue);
      expect(state.isPaused, isTrue);
      expect(state.breakRemaining, const Duration(minutes: 3));
    });
  });

  group('PomodoroEngine.recordBlockedAttempt', () {
    test('increments the blocked attempt counter', () {
      final engine = newEngine();
      final session = FocusSession(
        id: '1',
        task: 'Task',
        startedAt: DateTime.now(),
        plannedDuration: const Duration(minutes: 25),
        cycles: 1,
      );

      engine.startSession(session);
      engine.recordBlockedAttempt();
      engine.recordBlockedAttempt();

      expect(engine.currentState!.session.blockedAttemptCount, 2);
    });
  });
}