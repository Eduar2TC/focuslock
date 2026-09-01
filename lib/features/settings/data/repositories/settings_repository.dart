import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class SettingsRepository {
  final SharedPreferences _prefs;

  SettingsRepository(this._prefs);

  int get focusDuration => _prefs.getInt('focusDuration') ?? AppConstants.defaultFocusDuration;
  int get shortBreak => _prefs.getInt('shortBreak') ?? AppConstants.defaultShortBreak;
  int get longBreak => _prefs.getInt('longBreak') ?? AppConstants.defaultLongBreak;
  int get cycles => _prefs.getInt('cycles') ?? AppConstants.defaultCycles;
  bool get soundEnabled => _prefs.getBool('soundEnabled') ?? true;
  bool get vibrationEnabled => _prefs.getBool('vibrationEnabled') ?? true;
  bool get allowEmergencyExit => _prefs.getBool('allowEmergencyExit') ?? true;
  String get enforcementLevel => _prefs.getString('enforcementLevel') ?? 'normal';

  Future<void> setFocusDuration(int minutes) async {
    await _prefs.setInt('focusDuration', minutes);
  }

  Future<void> setShortBreak(int minutes) async {
    await _prefs.setInt('shortBreak', minutes);
  }

  Future<void> setLongBreak(int minutes) async {
    await _prefs.setInt('longBreak', minutes);
  }

  Future<void> setCycles(int cycles) async {
    await _prefs.setInt('cycles', cycles);
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool('soundEnabled', enabled);
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    await _prefs.setBool('vibrationEnabled', enabled);
  }

  Future<void> setAllowEmergencyExit(bool allow) async {
    await _prefs.setBool('allowEmergencyExit', allow);
  }

  Future<void> setEnforcementLevel(String level) async {
    await _prefs.setString('enforcementLevel', level);
  }

  bool get hasCompletedOnboarding => _prefs.getBool('hasCompletedOnboarding') ?? false;

  Future<void> completeOnboarding() async {
    await _prefs.setBool('hasCompletedOnboarding', true);
  }

  String get theme => _prefs.getString('theme') ?? 'dark';

  Future<void> setTheme(String theme) async {
    await _prefs.setString('theme', theme);
  }
}
