// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'FocusLock';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get timeAM => 'AM';

  @override
  String get timePM => 'PM';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonError => 'Error';

  @override
  String get commonDay => 'day';

  @override
  String get commonDays => 'days';

  @override
  String get commonCycles => 'cycles';

  @override
  String get homeTitle => 'Today\'s focus';

  @override
  String get homeStartButton => 'Start Focus';

  @override
  String get homeResumeSession => 'Resume Session';

  @override
  String get homeActiveSession => 'Focus session in progress';

  @override
  String get homeStatsButton => 'Statistics';

  @override
  String get homeSettingsButton => 'Settings';

  @override
  String get homeStatFocusTimeLabel => 'Focus Time';

  @override
  String get homeStatStreakLabel => 'Streak';

  @override
  String get onboardingStep1Title => 'Welcome to FocusLock';

  @override
  String get onboardingStep1Subtitle =>
      'A tool for deep work, not another distraction.';

  @override
  String get onboardingStep2Title => 'Define Your Intention';

  @override
  String get onboardingStep2Subtitle =>
      'Tell us what you want to accomplish. This creates commitment.';

  @override
  String get onboardingStep3Title => 'Set Your Timer';

  @override
  String get onboardingStep3Subtitle =>
      'Choose how long you want to focus. Start with 25 minutes.';

  @override
  String get onboardingStep4Title => 'Choose Your Distractions';

  @override
  String get onboardingStep4Subtitle =>
      'Select the apps that pull you away from your work.';

  @override
  String get onboardingStep5Title => 'Grant Permissions';

  @override
  String get onboardingStep5Subtitle =>
      'FocusLock needs these to protect your focus time.';

  @override
  String get onboardingStep6Title => 'You\'re Ready';

  @override
  String get onboardingStep6Subtitle =>
      'Put your phone down and start working. We will handle the rest.';

  @override
  String get onboardingButtonNext => 'Next';

  @override
  String get onboardingButtonStart => 'Get Started';

  @override
  String get presessionAppbarTitle => 'New Session';

  @override
  String get presessionTaskLabel => 'What are you going to work on?';

  @override
  String get presessionTaskHint => 'Build my Flutter app';

  @override
  String get presessionDurationLabel => 'Duration';

  @override
  String presessionDurationSummary(int duration) {
    return '$duration min will be used unless you pick another option';
  }

  @override
  String get presessionBlockedAppsLabel => 'Blocked Apps';

  @override
  String get presessionNoBlockedApps =>
      'No apps blocked. Tap Edit to select apps.';

  @override
  String get presessionErrorEmptyTask => 'Please enter a task';

  @override
  String get presessionStartButton => 'Start Focus';

  @override
  String focusCycleIndicator(int current, int total) {
    return 'Cycle $current of $total';
  }

  @override
  String get focusBreakTitle => 'Break';

  @override
  String get focusSkipBreak => 'Skip break';

  @override
  String get focusResume => 'Resume';

  @override
  String get focusPause => 'Pause';

  @override
  String get focusCancelDialogTitle => 'Cancel Session?';

  @override
  String get focusCancelDialogContent =>
      'Your progress will be saved but the session will be marked as cancelled.';

  @override
  String get focusCancelDialogKeepGoing => 'Keep Focus';

  @override
  String get focusCancelDialogConfirm => 'Cancel Session';

  @override
  String get focusExitDialogTitle => 'Leave Session?';

  @override
  String get focusExitDialogContent =>
      'Your focus session keeps running in the background. You can resume it from the home screen or the notification.';

  @override
  String get focusExitDialogStay => 'Keep Focusing';

  @override
  String get focusExitDialogExit => 'Exit to Home';

  @override
  String get completionTitleCompleted => 'Session Complete';

  @override
  String get completionTitleCancelled => 'Session Ended';

  @override
  String get completionInfoTask => 'Task';

  @override
  String get completionInfoScore => 'Focus Score';

  @override
  String get completionInfoCurrentStreak => 'Current Streak';

  @override
  String get completionEncourage => 'Nice work! Every focused minute counts.';

  @override
  String get completionDoneButton => 'Done';

  @override
  String get settingsAppbarTitle => 'Settings';

  @override
  String get settingsSectionFocus => 'Focus';

  @override
  String get settingsFocusDuration => 'Focus Duration';

  @override
  String get settingsShortBreak => 'Short Break';

  @override
  String get settingsLongBreak => 'Long Break';

  @override
  String get settingsCycles => 'Cycles';

  @override
  String get settingsSectionBlocking => 'Blocking';

  @override
  String get settingsAllowBypassBlocking => 'Allow Bypass Blocking';

  @override
  String get settingsAllowCancelSession => 'Allow Cancel Session';

  @override
  String get settingsSectionNotifications => 'Notifications';

  @override
  String get settingsSound => 'Sound';

  @override
  String get settingsVibration => 'Vibration';

  @override
  String get settingsSectionData => 'Data';

  @override
  String get settingsExportData => 'Export Data';

  @override
  String get settingsDeleteHistory => 'Delete History';

  @override
  String get settingsExportSuccess => 'Data exported successfully';

  @override
  String settingsExportError(String error) {
    return 'Export failed: $error';
  }

  @override
  String get settingsDeleteDialogTitle => 'Delete All History';

  @override
  String get settingsDeleteDialogContent =>
      'This will permanently delete all your focus sessions. This action cannot be undone.';

  @override
  String get settingsDeleteSuccess => 'History deleted successfully';

  @override
  String settingsDeleteError(String error) {
    return 'Delete failed: $error';
  }

  @override
  String get statsAppbarTitle => 'Statistics';

  @override
  String get statsOverviewSection => 'Overview';

  @override
  String get statsSessionsLabel => 'Sessions';

  @override
  String statsSessionsValue(int count) {
    return '$count completed';
  }

  @override
  String get statsTotalFocusTimeLabel => 'Focus Time';

  @override
  String get statsCurrentStreakLabel => 'Current Streak';

  @override
  String statsCurrentStreakValue(int count) {
    return '$count days';
  }

  @override
  String get statsTodayLabel => 'Today';

  @override
  String statsTodayWithCount(int count) {
    return 'Today ($count sessions)';
  }

  @override
  String get statsEmptyTodayTitle => 'No sessions today';

  @override
  String get statsEmptyTodayDescription =>
      'Start a focus session to see your progress here.';

  @override
  String get statsEmptyTodayCta => 'Start Focus';

  @override
  String get appsAppbarTitle => 'Blocked Apps';

  @override
  String get appsPermissionsRequired => 'Permissions Required';

  @override
  String get appsGrantUsageAccess => 'Grant Usage Access';

  @override
  String get appsGrantAccessibilityAccess => 'Grant Accessibility Access';

  @override
  String get appsEmptyTitle => 'No apps found';

  @override
  String appsErrorLoad(String error) {
    return 'Failed to load apps: $error';
  }

  @override
  String get notificationSessionActiveTitle => 'Focus Session Active';

  @override
  String notificationSessionActiveBody(String task, int minutes) {
    return '$task - $minutes minutes';
  }

  @override
  String notificationSessionRecoveringBody(String task, int minutes) {
    return '$task - $minutes minutes remaining';
  }

  @override
  String get achievementFirstSessionTitle => 'First Step';

  @override
  String get achievementFirstSessionDescription =>
      'Complete your first focus session';

  @override
  String get achievementStreak3Title => 'Consistent';

  @override
  String get achievementStreak3Description => 'Maintain a 3-day streak';

  @override
  String get achievementStreak7Title => 'Dedicated';

  @override
  String get achievementStreak7Description => 'Maintain a 7-day streak';

  @override
  String get achievementSessions10Title => 'Focused';

  @override
  String get achievementSessions10Description => 'Complete 10 focus sessions';

  @override
  String get achievementSessions50Title => 'Disciplined';

  @override
  String get achievementSessions50Description => 'Complete 50 focus sessions';

  @override
  String get achievementFocus10hTitle => 'Deep Worker';

  @override
  String get achievementFocus10hDescription =>
      'Accumulate 10 hours of focus time';
}
