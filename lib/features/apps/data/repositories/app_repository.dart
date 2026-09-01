import 'package:shared_preferences/shared_preferences.dart';

class AppRepository {
  final SharedPreferences _prefs;

  AppRepository(this._prefs);

  List<BlockedApp> getBlockedApps() {
    final appsJson = _prefs.getStringList('blockedApps') ?? [];
    return appsJson.map((json) {
      final parts = json.split('|');
      return BlockedApp(
        packageName: parts[0],
        appName: parts.length > 1 ? parts[1] : parts[0],
        enabled: parts.length > 2 ? parts[2] == 'true' : true,
      );
    }).toList();
  }

  Future<void> saveBlockedApps(List<BlockedApp> apps) async {
    final appsJson = apps.map((app) =>
        '${app.packageName}|${app.appName}|${app.enabled}').toList();
    await _prefs.setStringList('blockedApps', appsJson);
  }

  Future<void> addBlockedApp(BlockedApp app) async {
    final apps = getBlockedApps();
    apps.add(app);
    await saveBlockedApps(apps);
  }

  Future<void> removeBlockedApp(String packageName) async {
    final apps = getBlockedApps();
    apps.removeWhere((app) => app.packageName == packageName);
    await saveBlockedApps(apps);
  }

  Future<void> toggleApp(String packageName, bool enabled) async {
    final apps = getBlockedApps();
    final index = apps.indexWhere((app) => app.packageName == packageName);
    if (index != -1) {
      apps[index] = BlockedApp(
        packageName: apps[index].packageName,
        appName: apps[index].appName,
        enabled: enabled,
      );
      await saveBlockedApps(apps);
    }
  }

  List<String> getActiveBlockedPackages() {
    return getBlockedApps()
        .where((app) => app.enabled)
        .map((app) => app.packageName)
        .toList();
  }
}

class BlockedApp {
  final String packageName;
  final String appName;
  final bool enabled;

  const BlockedApp({
    required this.packageName,
    required this.appName,
    this.enabled = true,
  });
}
