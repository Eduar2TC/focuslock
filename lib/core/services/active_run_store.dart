import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/focus/domain/usecases/pomodoro_engine.dart';

/// Persists the live phase of an active focus run (cycle/break/pause state)
/// so it can be resumed exactly after the app process is killed.
class ActiveRunStore {
  ActiveRunStore(this._prefs);

  final SharedPreferences _prefs;

  FocusRunSnapshot? read() {
    final raw = _prefs.getString(FocusRunSnapshot.key);
    if (raw == null) return null;
    try {
      return FocusRunSnapshot.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> save(FocusRunSnapshot snapshot) {
    return _prefs.setString(
      FocusRunSnapshot.key,
      jsonEncode(snapshot.toJson()),
    );
  }

  Future<void> clear() => _prefs.remove(FocusRunSnapshot.key);
}
