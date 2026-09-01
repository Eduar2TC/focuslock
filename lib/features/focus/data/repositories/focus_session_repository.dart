import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../focus/domain/entities/focus_session.dart';

class FocusSessionRepository {
  final AppDatabase _database;

  FocusSessionRepository(this._database);

  Future<int> saveSession(FocusSession session) async {
    return _database.into(_database.focusSessions).insert(
      FocusSessionsCompanion(
        task: Value(session.task),
        startedAt: Value(session.startedAt),
        endedAt: Value(session.endedAt),
        plannedSeconds: Value(session.plannedDuration.inSeconds),
        actualSeconds: Value(session.actualDuration.inSeconds),
        status: Value(_statusToString(session.status)),
        cycles: Value(session.cycles),
        interruptions: Value(session.interruptionCount),
        blockedAttempts: Value(session.blockedAttemptCount),
        score: Value(session.score),
      ),
    );
  }

  Future<void> updateSession(FocusSession session) async {
    await _database.update(_database.focusSessions).replace(
      FocusSessionsCompanion(
        id: Value(int.parse(session.id)),
        task: Value(session.task),
        startedAt: Value(session.startedAt),
        endedAt: Value(session.endedAt),
        plannedSeconds: Value(session.plannedDuration.inSeconds),
        actualSeconds: Value(session.actualDuration.inSeconds),
        status: Value(_statusToString(session.status)),
        cycles: Value(session.cycles),
        interruptions: Value(session.interruptionCount),
        blockedAttempts: Value(session.blockedAttemptCount),
        score: Value(session.score),
      ),
    );
  }

  Future<FocusSession?> getActiveSession() async {
    final data = await _database.getActiveSession();
    return data != null ? _toEntity(data) : null;
  }

  Future<List<FocusSession>> getAllSessions() async {
    final data = await _database.getAllSessions();
    return data.map(_toEntity).toList();
  }

  Future<List<FocusSession>> getCompletedSessions() async {
    final data = await _database.getCompletedSessions();
    return data.map(_toEntity).toList();
  }

  Future<List<FocusSession>> getSessionsByDate(DateTime date) async {
    final data = await _database.getSessionsByDate(date);
    return data.map(_toEntity).toList();
  }

  Future<Duration> getTotalFocusTime() async {
    return _database.getTotalFocusTime();
  }

  Future<int> getCurrentStreak() async {
    return _database.getCurrentStreak();
  }

  Future<int> getCompletedCount() async {
    return _database.getCompletedSessionCount();
  }

  FocusSession _toEntity(FocusSessionData data) {
    return FocusSession(
      id: data.id.toString(),
      task: data.task,
      startedAt: data.startedAt,
      endedAt: data.endedAt,
      plannedDuration: Duration(seconds: data.plannedSeconds),
      actualDuration: Duration(seconds: data.actualSeconds),
      status: _stringToStatus(data.status),
      cycles: data.cycles,
      completedCycles: data.cycles,
      interruptionCount: data.interruptions,
      blockedAttemptCount: data.blockedAttempts,
      score: data.score,
    );
  }

  String _statusToString(SessionStatus status) {
    switch (status) {
      case SessionStatus.idle:
        return 'idle';
      case SessionStatus.preparing:
        return 'preparing';
      case SessionStatus.running:
        return 'running';
      case SessionStatus.paused:
        return 'paused';
      case SessionStatus.completed:
        return 'completed';
      case SessionStatus.cancelled:
        return 'cancelled';
      case SessionStatus.interrupted:
        return 'interrupted';
    }
  }

  SessionStatus _stringToStatus(String status) {
    switch (status) {
      case 'idle':
        return SessionStatus.idle;
      case 'preparing':
        return SessionStatus.preparing;
      case 'running':
        return SessionStatus.running;
      case 'paused':
        return SessionStatus.paused;
      case 'completed':
        return SessionStatus.completed;
      case 'cancelled':
        return SessionStatus.cancelled;
      case 'interrupted':
        return SessionStatus.interrupted;
      default:
        return SessionStatus.idle;
    }
  }
}
