// This is a basic Flutter widget test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:focuslock/app/app.dart';
import 'package:focuslock/app/dependencies.dart';
import 'package:focuslock/core/services/active_run_store.dart';
import 'package:focuslock/features/settings/data/repositories/settings_repository.dart';
import 'package:focuslock/features/apps/data/repositories/app_repository.dart';

void main() {
  testWidgets('App loads without error', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(ProviderScope(
      overrides: [
        settingsRepositoryProvider
            .overrideWith((ref) => SettingsRepository(prefs)),
        appRepositoryProvider.overrideWith((ref) => AppRepository(prefs)),
        activeRunStoreProvider.overrideWith((ref) => ActiveRunStore(prefs)),
      ],
      child: const FocusLockApp(),
    ));

    // Wait for the startup gate to resolve into onboarding/home.
    await tester.pumpAndSettle();

    // Verify the app loads
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
