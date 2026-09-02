import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../models/app_models.dart';

class NativeFocusService {
  static const _channel = MethodChannel(AppConstants.channelName);

  Future<List<InstalledApp>> getInstalledApps() async {
    try {
      final result = await _channel.invokeMethod<List>('getInstalledApps');
      return result
          ?.map((app) => InstalledApp.fromMap(Map<String, dynamic>.from(app)))
          .toList() ?? [];
    } on PlatformException catch (e) {
      throw Exception('Failed to get installed apps: ${e.message}');
    }
  }

  Future<Map<String, bool>> hasRequiredPermissions() async {
    try {
      final result = await _channel.invokeMethod<Map>('hasRequiredPermissions');
      return Map<String, bool>.from(result ?? {});
    } on PlatformException catch (e) {
      throw Exception('Failed to check permissions: ${e.message}');
    }
  }

  Future<void> openUsageSettings() async {
    try {
      await _channel.invokeMethod('openUsageSettings');
    } on PlatformException catch (e) {
      throw Exception('Failed to open usage settings: ${e.message}');
    }
  }

  Future<void> openAccessibilitySettings() async {
    try {
      await _channel.invokeMethod('openAccessibilitySettings');
    } on PlatformException catch (e) {
      throw Exception('Failed to open accessibility settings: ${e.message}');
    }
  }

  Future<void> startBlocking(List<String> packageNames) async {
    try {
      await _channel.invokeMethod('startBlocking', packageNames);
    } on PlatformException catch (e) {
      throw Exception('Failed to start blocking: ${e.message}');
    }
  }

  Future<void> stopBlocking() async {
    try {
      await _channel.invokeMethod('stopBlocking');
    } on PlatformException catch (e) {
      throw Exception('Failed to stop blocking: ${e.message}');
    }
  }

  Future<InstalledApp?> getCurrentForegroundApp() async {
    try {
      final result = await _channel.invokeMethod<Map>('getCurrentForegroundApp');
      return result != null ? InstalledApp.fromMap(Map<String, dynamic>.from(result)) : null;
    } on PlatformException catch (e) {
      throw Exception('Failed to get foreground app: ${e.message}');
    }
  }

  Future<void> startForegroundService(String title, String body) async {
    try {
      await _channel.invokeMethod('startForegroundService', {
        'title': title,
        'body': body,
      });
    } on PlatformException catch (e) {
      throw Exception('Failed to start foreground service: ${e.message}');
    }
  }

  Future<void> updateNotification(String title, String body) async {
    try {
      await _channel.invokeMethod('updateNotification', {
        'title': title,
        'body': body,
      });
    } on PlatformException catch (e) {
      throw Exception('Failed to update notification: ${e.message}');
    }
  }

  Future<void> stopForegroundService() async {
    try {
      await _channel.invokeMethod('stopForegroundService');
    } on PlatformException catch (e) {
      throw Exception('Failed to stop foreground service: ${e.message}');
    }
  }
}
