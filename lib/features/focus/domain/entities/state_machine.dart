import '../entities/focus_session.dart';

class InvalidStateTransition implements Exception {
  final SessionStatus from;
  final SessionStatus to;

  const InvalidStateTransition(this.from, this.to);

  @override
  String toString() => 'Invalid state transition: $from -> $to';
}

class FocusSessionStateMachine {
  static const Map<SessionStatus, List<SessionStatus>> _allowedTransitions = {
    SessionStatus.idle: [SessionStatus.preparing],
    SessionStatus.preparing: [SessionStatus.running, SessionStatus.cancelled],
    SessionStatus.running: [SessionStatus.paused, SessionStatus.completed, SessionStatus.cancelled, SessionStatus.interrupted],
    SessionStatus.paused: [SessionStatus.running, SessionStatus.cancelled],
    SessionStatus.completed: [SessionStatus.idle],
    SessionStatus.cancelled: [SessionStatus.idle],
    SessionStatus.interrupted: [SessionStatus.idle],
  };

  SessionStatus transition(SessionStatus current, SessionStatus next) {
    final allowed = _allowedTransitions[current];
    if (allowed == null || !allowed.contains(next)) {
      throw InvalidStateTransition(current, next);
    }
    return next;
  }

  bool canTransition(SessionStatus current, SessionStatus next) {
    final allowed = _allowedTransitions[current];
    return allowed?.contains(next) ?? false;
  }
}
