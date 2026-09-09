class ScoreCalculator {
  ScoreCalculator._();

  static int calculateSessionScore({
    required bool completed,
    required int cyclesCompleted,
    required Duration actualDuration,
    required int interruptionCount,
    required int blockedAttemptCount,
  }) {
    int score = 0;

    if (completed) {
      score += 10;
    } else {
      score -= 5;
    }

    score += cyclesCompleted * 2;

    final focusedMinutes = actualDuration.inMinutes;
    score += (focusedMinutes ~/ 5);

    score -= blockedAttemptCount * 3;

    return score;
  }

  static String formatScore(int score) {
    return score >= 0 ? '+$score' : '$score';
  }
}
