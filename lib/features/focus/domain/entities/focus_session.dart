enum SessionStatus {
  idle,
  preparing,
  running,
  paused,
  completed,
  cancelled,
  interrupted,
}

class FocusSession {
  final String id;
  final String task;
  final DateTime startedAt;
  final DateTime? endedAt;
  final Duration plannedDuration;
  final Duration actualDuration;
  final SessionStatus status;
  final int cycles;
  final int completedCycles;
  final int interruptionCount;
  final int blockedAttemptCount;
  final int score;

  const FocusSession({
    required this.id,
    required this.task,
    required this.startedAt,
    this.endedAt,
    required this.plannedDuration,
    this.actualDuration = Duration.zero,
    this.status = SessionStatus.idle,
    this.cycles = 4,
    this.completedCycles = 0,
    this.interruptionCount = 0,
    this.blockedAttemptCount = 0,
    this.score = 0,
  });

  FocusSession copyWith({
    String? id,
    String? task,
    DateTime? startedAt,
    DateTime? endedAt,
    Duration? plannedDuration,
    Duration? actualDuration,
    SessionStatus? status,
    int? cycles,
    int? completedCycles,
    int? interruptionCount,
    int? blockedAttemptCount,
    int? score,
  }) {
    return FocusSession(
      id: id ?? this.id,
      task: task ?? this.task,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      plannedDuration: plannedDuration ?? this.plannedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      status: status ?? this.status,
      cycles: cycles ?? this.cycles,
      completedCycles: completedCycles ?? this.completedCycles,
      interruptionCount: interruptionCount ?? this.interruptionCount,
      blockedAttemptCount: blockedAttemptCount ?? this.blockedAttemptCount,
      score: score ?? this.score,
    );
  }

  bool get isActive => status == SessionStatus.running || status == SessionStatus.paused;
  bool get isCompleted => status == SessionStatus.completed;
  bool get isCancelled => status == SessionStatus.cancelled;
}
