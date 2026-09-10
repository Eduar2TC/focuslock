import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/database/app_database.dart' hide FocusSession;
import '../core/services/native_focus_service.dart';
import '../core/services/active_run_store.dart';
import '../core/constants/app_constants.dart';
import '../core/extensions/extensions.dart';
import '../features/settings/data/repositories/settings_repository.dart';
import '../features/focus/data/repositories/focus_session_repository.dart';
import '../features/focus/domain/entities/focus_session.dart';
import '../features/apps/data/repositories/app_repository.dart';
import '../features/focus/domain/usecases/pomodoro_engine.dart';
import '../features/focus/presentation/controllers/focus_session_controller.dart';
import '../features/focus/domain/entities/focus_session_state.dart';

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final nativeFocusServiceProvider =
    Provider<NativeFocusService>((ref) => NativeFocusService());

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  // We can't use ref.watch here for async, so we'll use a different approach
  throw UnimplementedError(
      'SettingsRepository requires SharedPreferences to be initialized first');
});

final focusSessionRepositoryProvider = Provider<FocusSessionRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return FocusSessionRepository(database);
});

final appRepositoryProvider = Provider<AppRepository>((ref) {
  throw UnimplementedError(
      'AppRepository requires SharedPreferences to be initialized first');
});

final activeRunStoreProvider = Provider<ActiveRunStore>((ref) {
  throw UnimplementedError(
      'ActiveRunStore requires SharedPreferences to be initialized first');
});

final pomodoroEngineProvider =
    Provider<PomodoroEngine>((ref) => PomodoroEngine());

final focusSessionControllerProvider =
    StateNotifierProvider<FocusSessionController, FocusSessionState?>((ref) {
  return FocusSessionController(
    ref.watch(pomodoroEngineProvider),
    ref.watch(settingsRepositoryProvider),
    ref.watch(appRepositoryProvider),
    ref.watch(nativeFocusServiceProvider),
    ref.watch(focusSessionRepositoryProvider),
    ref.watch(activeRunStoreProvider),
  );
});

final totalFocusTimeProvider = FutureProvider<Duration>((ref) async {
  final repository = ref.watch(focusSessionRepositoryProvider);
  return repository.getTotalFocusTime();
});

final currentStreakProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(focusSessionRepositoryProvider);
  return repository.getCurrentStreak();
});

final completedSessionsCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(focusSessionRepositoryProvider);
  return repository.getCompletedCount();
});

/// Aggregated data for the home dashboard (Today's Focus, weekly dots,
/// best streak and recent activity).
class HomeDashboardData {
  const HomeDashboardData({
    required this.todayFocusTime,
    required this.todayCompletedCount,
    required this.bestStreak,
    required this.weekActivity,
    required this.recent,
  });

  final Duration todayFocusTime;
  final int todayCompletedCount;
  final int bestStreak;
  final List<bool> weekActivity;
  final List<FocusSession> recent;

  factory HomeDashboardData.fromSessions(List<FocusSession> sessions) {
    final now = DateTime.now();
    final today = now.startOfDay;

    var todayTime = Duration.zero;
    var todayCount = 0;
    for (final s in sessions) {
      if (s.isCompleted && s.startedAt.startOfDay == today) {
        todayTime += s.actualDuration;
        todayCount++;
      }
    }

    final days = <DateTime>{};
    for (final s in sessions) {
      if (s.isCompleted) {
        days.add(s.startedAt.startOfDay);
      }
    }
    final sortedDays = days.toList()..sort();

    var best = 0;
    var run = 0;
    DateTime? prev;
    for (final d in sortedDays) {
      if (prev != null && d.difference(prev).inDays == 1) {
        run++;
      } else {
        run = 1;
      }
      if (run > best) best = run;
      prev = d;
    }

    final weekActivity = <bool>[];
    for (var i = 6; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      weekActivity.add(days.contains(day));
    }

    final recent = [...sessions]
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return HomeDashboardData(
      todayFocusTime: todayTime,
      todayCompletedCount: todayCount,
      bestStreak: best,
      weekActivity: weekActivity,
      recent: recent.take(5).toList(),
    );
  }
}

final homeDashboardProvider = FutureProvider<HomeDashboardData>((ref) async {
  final repository = ref.watch(focusSessionRepositoryProvider);
  final completed = await repository.getCompletedSessions();
  return HomeDashboardData.fromSessions(completed);
});

final statisticsProvider = FutureProvider<StatisticsData>((ref) async {
  final sessionRepository = ref.watch(focusSessionRepositoryProvider);
  final sessions = await sessionRepository.getAllSessions();
  final currentStreak = await sessionRepository.getCurrentStreak();
  final apps = ref.watch(appRepositoryProvider).getBlockedApps();
  return computeStatistics(sessions, currentStreak, apps);
});

/// Period switchers available on the statistics screen.
enum StatsPeriod { today, week, month }

/// A single bar of the focus-time chart.
class StatsBar {
  const StatsBar({
    required this.date,
    required this.value,
    this.highlighted = false,
  });

  final DateTime date;
  final Duration value;
  final bool highlighted;
}

/// Aggregated metrics for one statistics period.
class PeriodData {
  const PeriodData({
    required this.start,
    required this.end,
    required this.focusTime,
    required this.previousFocusTime,
    required this.completed,
    required this.cancelledOrInterrupted,
    required this.blockedAttempts,
    required this.bars,
    required this.dayCount,
  });

  final DateTime start;
  final DateTime end;
  final Duration focusTime;
  final Duration previousFocusTime;
  final int completed;
  final int cancelledOrInterrupted;
  final int blockedAttempts;
  final List<StatsBar> bars;
  final int dayCount;

  double get completionRate {
    final total = completed + cancelledOrInterrupted;
    return total == 0 ? 0 : completed / total;
  }

  Duration get dailyAverage => focusTime ~/ dayCount;
}

/// Everything the statistics screen needs, computed in a single pass.
class StatisticsData {
  const StatisticsData({
    required this.currentStreak,
    required this.bestStreak,
    required this.weekActivity,
    required this.weekConsistencyScore,
    required this.blockedApps,
    required this.peakHour,
    required this.beforeNoonRate,
    required this.today,
    required this.week,
    required this.month,
  });

  final int currentStreak;
  final int bestStreak;
  final List<bool> weekActivity;
  final int weekConsistencyScore;
  final List<BlockedApp> blockedApps;
  final int peakHour;
  final double beforeNoonRate;
  final PeriodData today;
  final PeriodData week;
  final PeriodData month;

  bool get hasAnyCompleted =>
      today.completed + week.completed + month.completed > 0;

  PeriodData of(StatsPeriod period) {
    switch (period) {
      case StatsPeriod.today:
        return today;
      case StatsPeriod.week:
        return week;
      case StatsPeriod.month:
        return month;
    }
  }
}

/// Builds the aggregated view-model for the statistics screen.
StatisticsData computeStatistics(
  List<FocusSession> sessions,
  int currentStreak,
  List<BlockedApp> blockedApps,
) {
  final completed = sessions.where((s) => s.isCompleted).toList();

  final completedDays = completed
      .map((s) => s.startedAt.startOfDay)
      .toSet()
      .toList()
    ..sort();

  var best = 0;
  var run = 0;
  DateTime? prev;
  for (final d in completedDays) {
    if (prev != null && d.difference(prev).inDays == 1) {
      run++;
    } else {
      run = 1;
    }
    if (run > best) best = run;
    prev = d;
  }

  final today = DateTime.now().startOfDay;

  final weekActivity = <bool>[];
  for (var i = 6; i >= 0; i--) {
    weekActivity.add(completedDays.contains(today.subtract(Duration(days: i))));
  }

  var peakHour = -1;
  var peakCount = 0;
  var beforeNoon = 0;
  final hourCounts = <int, int>{};
  for (final s in completed) {
    final h = s.startedAt.hour;
    final count = (hourCounts[h] ?? 0) + 1;
    hourCounts[h] = count;
    if (count > peakCount) {
      peakCount = count;
      peakHour = h;
    }
    if (h < 12) beforeNoon++;
  }
  final beforeNoonRate =
      completed.isEmpty ? 0.0 : beforeNoon / completed.length;

  var consistencySum = 0.0;
  for (var i = 6; i >= 0; i--) {
    final day = today.subtract(Duration(days: i));
    final daily = completed
        .where((s) => s.startedAt.startOfDay == day)
        .fold(Duration.zero, (sum, s) => sum + s.actualDuration);
    final goal = AppConstants.dailyFocusGoalMinutes.minutes;
    consistencySum += goal == Duration.zero
        ? 0
        : (daily.inSeconds / goal.inSeconds).clamp(0.0, 1.0);
  }
  final consistencyScore = (consistencySum / 7 * 100).round();

  final todayData = _buildPeriod(sessions, today, today, today, 1);
  final weekData = _buildPeriod(
    sessions,
    today.subtract(const Duration(days: 6)),
    today,
    today,
    7,
  );
  final monthData = _buildPeriod(
    sessions,
    today.subtract(const Duration(days: 29)),
    today,
    today,
    30,
    weeklyBuckets: true,
  );

  final enabledBlocked =
      blockedApps.where((app) => app.enabled).toList(growable: false);

  return StatisticsData(
    currentStreak: currentStreak,
    bestStreak: best,
    weekActivity: weekActivity,
    weekConsistencyScore: consistencyScore,
    blockedApps: enabledBlocked,
    peakHour: peakHour,
    beforeNoonRate: beforeNoonRate,
    today: todayData,
    week: weekData,
    month: monthData,
  );
}

Duration _sumFocus(
    List<FocusSession> list, bool Function(FocusSession) filter) {
  return list
      .where(filter)
      .fold(Duration.zero, (sum, s) => sum + s.actualDuration);
}

PeriodData _buildPeriod(
  List<FocusSession> all,
  DateTime from,
  DateTime to,
  DateTime today,
  int dayCount, {
  bool weeklyBuckets = false,
}) {
  final periodStart = from.startOfDay;
  final periodEnd = to.startOfDay;
  final daysInPeriod = periodEnd.difference(periodStart).inDays;
  final prevStart = periodStart.subtract(Duration(days: daysInPeriod + 1));
  final prevEnd = periodStart.subtract(const Duration(days: 1));

  final inPeriod = all.where((s) {
    final d = s.startedAt.startOfDay;
    return !d.isBefore(periodStart) && !d.isAfter(periodEnd);
  }).toList();

  final prevPeriod = all.where((s) {
    final d = s.startedAt.startOfDay;
    return !d.isBefore(prevStart) && !d.isAfter(prevEnd);
  }).toList();

  final bars = <StatsBar>[];
  if (weeklyBuckets) {
    for (var i = 0; i < 5; i++) {
      final start = periodEnd.subtract(Duration(days: 29 - 6 * i));
      final end = start.add(const Duration(days: 5));
      final value = _sumFocus(
        all,
        (s) {
          final d = s.startedAt.startOfDay;
          return !d.isBefore(start) && !d.isAfter(end);
        },
      );
      bars.add(StatsBar(
        date: start,
        value: value,
        highlighted: i == 4,
      ));
    }
  } else {
    for (var i = dayCount - 1; i >= 0; i--) {
      final date = periodEnd.subtract(Duration(days: i));
      final value = _sumFocus(
        all,
        (s) => s.startedAt.startOfDay == date,
      );
      bars.add(StatsBar(
        date: date,
        value: value,
        highlighted: date == today,
      ));
    }
  }

  return PeriodData(
    start: periodStart,
    end: periodEnd,
    focusTime: _sumFocus(inPeriod, (s) => s.isCompleted),
    previousFocusTime: _sumFocus(prevPeriod, (s) => s.isCompleted),
    completed: inPeriod.where((s) => s.isCompleted).length,
    cancelledOrInterrupted: inPeriod
        .where((s) => s.isCancelled || s.status == SessionStatus.interrupted)
        .length,
    blockedAttempts: inPeriod.fold(0, (sum, s) => sum + s.blockedAttemptCount),
    bars: bars,
    dayCount: dayCount,
  );
}

/// Latest blocked-app attempt reported by the native bridge, used by the
/// blocked-app intervention page.
final blockedAppAttemptProvider = StateProvider<String?>((ref) => null);

// Provider for onboarding status - uses the future from sharedPreferencesProvider
final hasCompletedOnboardingProvider = FutureProvider<bool>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return prefs.getBool('hasCompletedOnboarding') ?? false;
});

// Initialize dependencies - call this in main() before runApp
Future<void> initializeDependencies() async {
  // This will be called in main.dart
}
