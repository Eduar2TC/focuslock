import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';
import 'app/dependencies.dart';
import 'core/services/active_run_store.dart';
import 'features/settings/data/repositories/settings_repository.dart';
import 'features/apps/data/repositories/app_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF121316),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(
    ProviderScope(
      overrides: [
        settingsRepositoryProvider
            .overrideWith((ref) => SettingsRepository(prefs)),
        appRepositoryProvider.overrideWith((ref) => AppRepository(prefs)),
        activeRunStoreProvider.overrideWith((ref) => ActiveRunStore(prefs)),
      ],
      child: const FocusLockApp(),
    ),
  );
}
