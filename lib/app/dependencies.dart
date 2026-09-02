import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/database/app_database.dart';
import '../core/services/native_focus_service.dart';
import '../features/settings/data/repositories/settings_repository.dart';
import '../features/focus/data/repositories/focus_session_repository.dart';
import '../features/apps/data/repositories/app_repository.dart';
import '../features/focus/domain/usecases/pomodoro_engine.dart';
import '../features/focus/presentation/controllers/focus_session_controller.dart';
import '../features/focus/domain/entities/focus_session_state.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final nativeFocusServiceProvider = Provider<NativeFocusService>((ref) => NativeFocusService());

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  // We can't use ref.watch here for async, so we'll use a different approach
  throw UnimplementedError('SettingsRepository requires SharedPreferences to be initialized first');
});

final focusSessionRepositoryProvider = Provider<FocusSessionRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return FocusSessionRepository(database);
});

final appRepositoryProvider = Provider<AppRepository>((ref) {
  throw UnimplementedError('AppRepository requires SharedPreferences to be initialized first');
});

final pomodoroEngineProvider = Provider<PomodoroEngine>((ref) => PomodoroEngine());

final focusSessionControllerProvider = StateNotifierProvider<FocusSessionController, FocusSessionState?>((ref) {
  return FocusSessionController(
    ref.watch(pomodoroEngineProvider),
    ref.watch(settingsRepositoryProvider),
    ref.watch(appRepositoryProvider),
    ref.watch(nativeFocusServiceProvider),
    ref.watch(focusSessionRepositoryProvider),
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

// Provider for onboarding status - uses the future from sharedPreferencesProvider
final hasCompletedOnboardingProvider = FutureProvider<bool>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return prefs.getBool('hasCompletedOnboarding') ?? false;
});

// Initialize dependencies - call this in main() before runApp
Future<void> initializeDependencies() async {
  // This will be called in main.dart
}
