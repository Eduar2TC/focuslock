import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/database/app_database.dart';
import '../core/services/native_focus_service.dart';
import '../features/settings/data/repositories/settings_repository.dart';
import '../features/focus/data/repositories/focus_session_repository.dart';
import '../features/apps/data/repositories/app_repository.dart';

late Provider<SharedPreferences> sharedPreferencesProvider;
late Provider<AppDatabase> databaseProvider;
late Provider<NativeFocusService> nativeFocusServiceProvider;
late Provider<SettingsRepository> settingsRepositoryProvider;
late Provider<FocusSessionRepository> focusSessionRepositoryProvider;
late Provider<AppRepository> appRepositoryProvider;

Future<void> initializeDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  final database = AppDatabase();

  sharedPreferencesProvider = Provider<SharedPreferences>((ref) => prefs);
  databaseProvider = Provider<AppDatabase>((ref) => database);
  nativeFocusServiceProvider = Provider<NativeFocusService>((ref) => NativeFocusService());
  settingsRepositoryProvider = Provider<SettingsRepository>((ref) => SettingsRepository(prefs));
  focusSessionRepositoryProvider = Provider<FocusSessionRepository>((ref) => FocusSessionRepository(database));
  appRepositoryProvider = Provider<AppRepository>((ref) => AppRepository(prefs));
}
