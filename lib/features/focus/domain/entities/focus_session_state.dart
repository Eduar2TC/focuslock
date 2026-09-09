import '../entities/focus_session.dart';

class FocusSessionState {
  final FocusSession session;
  final Duration remaining;
  final bool isPaused;
  final int currentCycle;
  final bool isBreak;
  final Duration breakRemaining;
  final Duration breakTotal;

  const FocusSessionState({
    required this.session,
    required this.remaining,
    this.isPaused = false,
    this.currentCycle = 1,
    this.isBreak = false,
    this.breakRemaining = Duration.zero,
    this.breakTotal = Duration.zero,
  });

  FocusSessionState copyWith({
    FocusSession? session,
    Duration? remaining,
    bool? isPaused,
    int? currentCycle,
    bool? isBreak,
    Duration? breakRemaining,
    Duration? breakTotal,
  }) {
    return FocusSessionState(
      session: session ?? this.session,
      remaining: remaining ?? this.remaining,
      isPaused: isPaused ?? this.isPaused,
      currentCycle: currentCycle ?? this.currentCycle,
      isBreak: isBreak ?? this.isBreak,
      breakRemaining: breakRemaining ?? this.breakRemaining,
      breakTotal: breakTotal ?? this.breakTotal,
    );
  }

  double get progress {
    if (isBreak) {
      if (breakTotal.inSeconds <= 0) return 0;
      final ratio = 1 - (breakRemaining.inSeconds / breakTotal.inSeconds);
      return ratio.clamp(0.0, 1.0).toDouble();
    }
    if (session.plannedDuration.inSeconds == 0) return 0;
    return 1 - (remaining.inSeconds / session.plannedDuration.inSeconds);
  }
}
