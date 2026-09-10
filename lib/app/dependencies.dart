import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/database/app_database.dart' hide FocusSession;
import '../core/services/native_focus_service.dart';
import '../core/services/active_run_store.dart';
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
