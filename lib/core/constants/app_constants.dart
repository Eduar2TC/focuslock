class AppConstants {
  AppConstants._();

  static const String appName = 'FocusLock';
  static const String appVersion = '1.0.0';

  static const int defaultFocusDuration = 25;
  static const int defaultShortBreak = 5;
  static const int defaultLongBreak = 15;
  static const int defaultCycles = 4;

  static const int minFocusDuration = 5;
  static const int maxFocusDuration = 120;
  static const int minBreakDuration = 1;
  static const int maxBreakDuration = 60;

  static const int scoreCompletedSession = 10;
  static const int scoreCycleCompleted = 2;
  static const int scoreFiveMinutesFocused = 1;
  static const int scoreCancellation = -5;
  static const int scoreBlockedAttempt = -3;

  static const String channelName = 'com.focuslock.app/native';
}
