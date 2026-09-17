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
  String get presessionTaskLabel => 'What are you working on?';

  @override
  String get presessionTaskHint => 'e.g., Deep writing, Coding Sprint...';

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
  String get focusResume => 'Resume Focus';

  @override
  String get focusPause => 'Pause Session';

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
  String get statsSessionsDone => 'done';

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
  String get statsSubtitle => 'Focus metrics & digital wellbeing';

  @override
  String get statsPeriodWeek => 'Week';

  @override
  String get statsPeriodMonth => 'Month';

  @override
  String statsDeltaToday(String delta) {
    return '$delta vs yesterday';
  }

  @override
  String statsDeltaWeek(String delta) {
    return '$delta vs last week';
  }

  @override
  String statsDeltaMonth(String delta) {
    return '$delta vs last month';
  }

  @override
  String statsDailyAvg(String value) {
    return 'Daily avg: $value';
  }

  @override
  String statsCompletionRate(int percent) {
    return '$percent% completion rate';
  }

  @override
  String get statsSuccessRateLabel => 'Success Rate';

  @override
  String get statsSuccessRateSubtitle => 'Strict mode intact';

  @override
  String statsPausesUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pause overrides used',
      one: '$count pause override used',
    );
    return '$_temp0';
  }

  @override
  String statsDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$_temp0';
  }

  @override
  String statsBestStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Best: $count days',
      one: 'Best: $count day',
    );
    return '$_temp0';
  }

  @override
  String get statsFocusChartTitle => 'Focus Time (Hours)';

  @override
  String statsDailyTarget(String target) {
    return 'Daily target: $target';
  }

  @override
  String statsTodayChip(String value) {
    return 'Today: $value';
  }

  @override
  String statsPeriodTotal(String value) {
    return 'Total: $value';
  }

  @override
  String statsWeeklyTotal(String value) {
    return 'Weekly Total: $value';
  }

  @override
  String statsOnTrack(String goal) {
    return 'On track for $goal goal';
  }

  @override
  String get statsInterventionsTitle => 'Interventions';

  @override
  String get statsInterventionsSubtitle =>
      'Distractions prevented by FocusLock during sessions';

  @override
  String statsInterventionsTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Total',
      one: '$count Total',
    );
    return '$_temp0';
  }

  @override
  String get statsAppBlocking => 'Blocking';

  @override
  String get statsBlockedAppsEmpty => 'No apps are being blocked yet.';

  @override
  String get statsQualityTitle => 'Focus Quality & Pattern';

  @override
  String get statsInsightChip => 'Insight';

  @override
  String statsPeakWindow(String start, String end) {
    return 'Peak Focus Window: $start – $end';
  }

  @override
  String statsInsightBody(int percent) {
    return 'You complete $percent% of sessions started before noon.';
  }

  @override
  String get statsConsistencyTitle => 'Consistency Score';

  @override
  String statsConsistencyValue(int score) {
    return '$score / 100';
  }

  @override
  String get appsAppbarTitle => 'Blocked Apps';

  @override
  String get appsPermissionsRequired => 'Permissions Required';

  @override
  String get appsGrantUsageAccess => 'Grant Usage Access';

  @override
  String get appsGrantAccessibilityAccess => 'Grant Accessibility Access';

  @override
  String get permissionsPageTitle => 'Permissions Required';

  @override
  String get permissionsPageSubtitle =>
      'A strict session blocks other apps. FocusLock needs these permissions to work.';

  @override
  String get permissionsUsageStats => 'Usage Access';

  @override
  String get permissionsAccessibility => 'Accessibility Access';

  @override
  String get permissionsGranted => 'Granted';

  @override
  String get permissionsMissing => 'Missing';

  @override
  String get permissionsAllGranted => 'All permissions granted';

  @override
  String get permissionsContinue => 'Continue';

  @override
  String get presessionErrorRequiresApps =>
      'Add at least one app to block before starting.';

  @override
  String get appsEmptyTitle => 'No apps found';

  @override
  String appsErrorLoad(String error) {
    return 'Failed to load apps: $error';
  }

  @override
  String statsErrorLoad(String error) {
    return 'Error loading statistics: $error';
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

  @override
  String get navHome => 'Home';

  @override
  String get commonClear => 'Clear';

  @override
  String get homeCalmMind => 'Calm Mind';

  @override
  String get homeScheduleReady => 'Your scheduled deep session is ready.';

  @override
  String homeSessionsCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions completed',
      one: '$count session completed',
    );
    return '$_temp0';
  }

  @override
  String homeGoalPercent(int percent) {
    return '$percent% goal';
  }

  @override
  String homeStreakLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days streak',
      one: '$count day streak',
    );
    return '$_temp0';
  }

  @override
  String homeBestStreak(int count) {
    return 'Best: $count days';
  }

  @override
  String get homeStreakActive => 'Active';

  @override
  String get homeRecentActivity => 'Recent Activity';

  @override
  String get homeViewAll => 'View all';

  @override
  String get homeRecentEmpty =>
      'No sessions yet. Start your first focus session.';

  @override
  String get homeRecentCompleted => 'Completed';

  @override
  String get homeRecentCancelled => 'Cancelled';

  @override
  String get presessionSetupChip => 'Session Setup';

  @override
  String get presessionReadyTitle => 'Ready to focus?';

  @override
  String get presessionReadySubtitle =>
      'Set your intention and lock away distractions.';

  @override
  String get presessionRequired => 'Required';

  @override
  String get presessionTaskDefault => 'Build my Flutter application';

  @override
  String get presessionCustom => 'Custom';

  @override
  String get presessionCustomDuration => 'Custom duration';

  @override
  String get presessionCustomSet => 'Set Duration';

  @override
  String presessionCustomMin(int min) {
    return '$min min';
  }

  @override
  String get presessionMin => 'min';

  @override
  String get presessionAppsToBlock => 'Apps to block';

  @override
  String presessionActiveCount(int count) {
    return '$count active';
  }

  @override
  String get presessionManage => 'Manage';

  @override
  String presessionMoreCount(int count) {
    return '+$count more';
  }

  @override
  String get presessionEnforcementMode => 'Enforcement Mode';

  @override
  String get modeStandard => 'Standard';

  @override
  String get modeStandardDescription =>
      'Leave when you need to without penalty. Keeps track of intentional exits.';

  @override
  String get modeStrict => 'Strict';

  @override
  String get modeStrictDescription =>
      'Leaving counts as an interruption. Emergency unlock requires a 60-second cooldown wait.';

  @override
  String get modeRecommended => 'Recommended';

  @override
  String presessionStartWithDuration(int min) {
    return 'Start Focus ($min min)';
  }

  @override
  String get presessionFaceDownTip =>
      'Putting your phone face-down will automatically dim the display.';

  @override
  String get focusModeStrict => 'STRICT FOCUS';

  @override
  String get focusModeStandard => 'STANDARD FOCUS';

  @override
  String get focusBreakTime => 'BREAK TIME';

  @override
  String get focusRestrictedMode => 'RESTRICTED MODE';

  @override
  String get focusPausedLabel => 'PAUSED';

  @override
  String get focusNoAppsBlocked => 'No apps blocked';

  @override
  String focusLockedDownCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Phone is locked down • $count apps blocked',
      one: 'Phone is locked down • $count app blocked',
    );
    return '$_temp0';
  }

  @override
  String get focusZenPill => 'Put your phone down and dive in.';

  @override
  String get focusEndSessionEarly => 'End session early';

  @override
  String get focusSheetTitle => 'Break Focus Session?';

  @override
  String get focusSheetBody => 'Your current streak will reset for today.';

  @override
  String get focusUnlockPhone => 'Unlock Phone';

  @override
  String get focusSheetConfirm => 'End Session';

  @override
  String get blockedDefaultTask => 'Your focus session';

  @override
  String get blockedFallbackApp => 'This app';

  @override
  String get blockedInterventionGate => 'Intervention Gate';

  @override
  String get blockedStayFocused => 'Stay focused.';

  @override
  String get blockedBreathe =>
      'Breathe. Your future self will thank you for finishing this session.';

  @override
  String get blockedYouChose => 'You chose to focus on';

  @override
  String get blockedDeepWork => 'Deep Work';

  @override
  String blockedTimeRemaining(String time) {
    return '$time remaining';
  }

  @override
  String blockedSessionTarget(int minutes) {
    return 'Session target: ${minutes}m';
  }

  @override
  String blockedAppIsLocked(String app) {
    return '$app is locked';
  }

  @override
  String get blockedFocusShield => 'Scheduled inside your focus shield';

  @override
  String get blockedStrictActive => 'Strict Mode is active';

  @override
  String get blockedStrictWarning =>
      'Leaving this session early will be permanently logged as an interruption on your weekly streak.';

  @override
  String get blockedReturnToFocus => 'Return to focus';

  @override
  String get blockedEndSessionAnyway => 'End session anyway';

  @override
  String get blockedUrges => 'Urges peak and fade within 3 minutes';

  @override
  String get blockedBreakStreak => 'Break your streak?';

  @override
  String get blockedBreath =>
      'You are only minutes away from locking in today\'s best focus session. Take three slow breaths instead.';

  @override
  String get blockedKeepGoing => 'I will keep going';

  @override
  String get blockedQuitSession => 'Quit session';
}
