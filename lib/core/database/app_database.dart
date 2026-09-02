import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class FocusSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get task => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get plannedSeconds => integer()();
  IntColumn get actualSeconds => integer()();
  TextColumn get status => text()();
  IntColumn get cycles => integer()();
  IntColumn get completedCycles => integer().withDefault(const Constant(0))();
  IntColumn get interruptions => integer().withDefault(const Constant(0))();
  IntColumn get blockedAttempts => integer().withDefault(const Constant(0))();
  IntColumn get score => integer().withDefault(const Constant(0))();
}

@DriftDatabase(tables: [FocusSessions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> insertSession(FocusSessionsCompanion entry) {
    return into(focusSessions).insert(entry);
  }

  Future<bool> updateSession(FocusSessionsCompanion entry) {
    return update(focusSessions).replace(entry);
  }

  Future<FocusSession?> getActiveSession() {
    return (select(focusSessions)
          ..where((t) => t.status.isIn(['running', 'paused', 'preparing']))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<FocusSession>> getAllSessions() {
    return (select(focusSessions)
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
  }

  Future<List<FocusSession>> getCompletedSessions() {
    return (select(focusSessions)
          ..where((t) => t.status.equals('completed'))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
  }

  Future<List<FocusSession>> getSessionsByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return (select(focusSessions)
          ..where((t) =>
              t.startedAt.isBiggerOrEqualValue(startOfDay) &
              t.startedAt.isSmallerThanValue(endOfDay))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
  }

  Future<Duration> getTotalFocusTime() async {
    final result = await customSelect(
      'SELECT SUM(actual_seconds) as total FROM focus_sessions WHERE status = ?',
      variables: [Variable<String>('completed')],
    ).getSingleOrNull();
    final total = result?.data['total'] as int? ?? 0;
    return Duration(seconds: total);
  }

  Future<int> getCompletedSessionCount() async {
    return (select(focusSessions)
          ..where((t) => t.status.equals('completed')))
        .get()
        .then((list) => list.length);
  }

  Future<int> getCurrentStreak() async {
    final sessions = await getCompletedSessions();
    if (sessions.isEmpty) return 0;

    final dates = sessions
        .map((s) => DateTime(s.startedAt.year, s.startedAt.month, s.startedAt.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime expectedDate = DateTime.now();

    for (final date in dates) {
      if (date.isAtSameMomentAs(expectedDate) || date.isAfter(expectedDate)) {
        streak++;
        expectedDate = date.subtract(const Duration(days: 1));
      } else if (date.isBefore(expectedDate)) {
        break;
      }
    }
    return streak;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'focuslock.sqlite3'));
    return NativeDatabase.createInBackground(file);
  });
}