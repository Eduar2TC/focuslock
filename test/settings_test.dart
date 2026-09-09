import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:focuslock/features/settings/data/repositories/settings_repository.dart';
import 'package:focuslock/core/constants/app_constants.dart';

void main() {
  group('SettingsRepository', () {
    late SharedPreferences prefs;
    late SettingsRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      repository = SettingsRepository(prefs);
    });

    test('default focus duration is 25 minutes', () {
      expect(repository.focusDuration, AppConstants.defaultFocusDuration);
    });

    test('default short break is 5 minutes', () {
      expect(repository.shortBreak, AppConstants.defaultShortBreak);
    });

    test('default long break is 15 minutes', () {
      expect(repository.longBreak, AppConstants.defaultLongBreak);
    });

    test('default cycles is 4', () {
      expect(repository.cycles, AppConstants.defaultCycles);
    });

    test('can set focus duration', () async {
      await repository.setFocusDuration(30);
      expect(repository.focusDuration, 30);
    });

    test('can set short break', () async {
      await repository.setShortBreak(10);
      expect(repository.shortBreak, 10);
    });

    test('can set long break', () async {
      await repository.setLongBreak(20);
      expect(repository.longBreak, 20);
    });

    test('can set cycles', () async {
      await repository.setCycles(6);
      expect(repository.cycles, 6);
    });

    test('default sound enabled is true', () {
      expect(repository.soundEnabled, true);
    });

    test('default vibration enabled is true', () {
      expect(repository.vibrationEnabled, true);
    });

    test('default allow emergency exit is false', () {
      expect(repository.allowEmergencyExit, false);
    });

    test('can toggle sound', () async {
      await repository.setSoundEnabled(false);
      expect(repository.soundEnabled, false);
    });

    test('can toggle vibration', () async {
      await repository.setVibrationEnabled(false);
      expect(repository.vibrationEnabled, false);
    });

    test('hasCompletedOnboarding defaults to false', () {
      expect(repository.hasCompletedOnboarding, false);
    });

    test('can complete onboarding', () async {
      await repository.completeOnboarding();
      expect(repository.hasCompletedOnboarding, true);
    });
  });
}
