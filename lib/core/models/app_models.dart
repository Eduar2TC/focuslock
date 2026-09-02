class InstalledApp {
  final String packageName;
  final String appName;
  final String? icon;

  const InstalledApp({
    required this.packageName,
    required this.appName,
    this.icon,
  });

  factory InstalledApp.fromMap(Map<String, dynamic> map) {
    return InstalledApp(
      packageName: map['packageName'] as String,
      appName: map['appName'] as String,
      icon: map['icon'] as String?,
    );
  }
}

class AppUsageEvent {
  final String packageName;
  final DateTime timestamp;

  const AppUsageEvent({
    required this.packageName,
    required this.timestamp,
  });
}
