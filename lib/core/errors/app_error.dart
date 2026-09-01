sealed class AppError implements Exception {
  const AppError(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => 'AppError: $message';
}

class PermissionDenied extends AppError {
  const PermissionDenied(String permission)
      : super('Permission denied: $permission');
}

class AccessibilityDisabled extends AppError {
  const AccessibilityDisabled()
      : super('Accessibility service is disabled');
}

class UsageAccessDisabled extends AppError {
  const UsageAccessDisabled()
      : super('Usage access permission is required');
}

class BlockingUnavailable extends AppError {
  const BlockingUnavailable()
      : super('App blocking is not available');
}

class SessionAlreadyRunning extends AppError {
  const SessionAlreadyRunning()
      : super('A session is already in progress');
}

class InvalidSessionState extends AppError {
  const InvalidSessionState(String message)
      : super('Invalid session state: $message');
}

class StorageFailure extends AppError {
  const StorageFailure(String message, [Object? cause])
      : super('Storage failure: $message', cause);
}

class NotificationPermissionDenied extends AppError {
  const NotificationPermissionDenied()
      : super('Notification permission is required');
}
