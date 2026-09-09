import 'package:flutter_test/flutter_test.dart';
import 'package:focuslock/core/utils/score_calculator.dart';
import 'package:focuslock/core/extensions/extensions.dart';

void main() {
  group('ScoreCalculator', () {
    test('completed session with no interruptions gets positive score', () {
      final score = ScoreCalculator.calculateSessionScore(
        completed: true,
        cyclesCompleted: 4,
        actualDuration: const Duration(minutes: 25),
        interruptionCount: 0,
        blockedAttemptCount: 0,
      );

      expect(score, greaterThan(0));
    });

    test('cancelled session gets negative score', () {
      final score = ScoreCalculator.calculateSessionScore(
        completed: false,
        cyclesCompleted: 0,
        actualDuration: const Duration(minutes: 5),
        interruptionCount: 0,
        blockedAttemptCount: 0,
      );

      expect(score, lessThan(0));
    });

    test('blocked attempts reduce score', () {
      final scoreWithoutBlocked = ScoreCalculator.calculateSessionScore(
        completed: true,
        cyclesCompleted: 1,
        actualDuration: const Duration(minutes: 25),
        interruptionCount: 0,
        blockedAttemptCount: 0,
      );

      final scoreWithBlocked = ScoreCalculator.calculateSessionScore(
        completed: true,
        cyclesCompleted: 1,
        actualDuration: const Duration(minutes: 25),
        interruptionCount: 0,
        blockedAttemptCount: 3,
      );

      expect(scoreWithBlocked, lessThan(scoreWithoutBlocked));
    });

    test('more cycles completed increases score', () {
      final scoreWith1Cycle = ScoreCalculator.calculateSessionScore(
        completed: true,
        cyclesCompleted: 1,
        actualDuration: const Duration(minutes: 25),
        interruptionCount: 0,
        blockedAttemptCount: 0,
      );

      final scoreWith4Cycles = ScoreCalculator.calculateSessionScore(
        completed: true,
        cyclesCompleted: 4,
        actualDuration: const Duration(minutes: 100),
        interruptionCount: 0,
        blockedAttemptCount: 0,
      );

      expect(scoreWith4Cycles, greaterThan(scoreWith1Cycle));
    });

    test('heavy blocking penalties can make even a completed session negative',
        () {
      final score = ScoreCalculator.calculateSessionScore(
        completed: true,
        cyclesCompleted: 0,
        actualDuration: Duration.zero,
        interruptionCount: 0,
        blockedAttemptCount: 10,
      );

      expect(score, lessThan(0));
    });
  });

  group('DurationExtension', () {
    test('formatted shows hours and minutes', () {
      const duration = Duration(hours: 2, minutes: 30);
      expect(duration.formatted, '2h 30m');
    });

    test('formatted shows only minutes', () {
      const duration = Duration(minutes: 45);
      expect(duration.formatted, '45m 0s');
    });

    test('timerFormatted shows HH:MM:SS', () {
      const duration = Duration(hours: 1, minutes: 30, seconds: 45);
      expect(duration.timerFormatted, '01:30:45');
    });

    test('timerFormatted shows MM:SS for short durations', () {
      const duration = Duration(minutes: 5, seconds: 30);
      expect(duration.timerFormatted, '05:30');
    });
  });
}
