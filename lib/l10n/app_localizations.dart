import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// The name of the app
  ///
  /// In en, this message translates to:
  /// **'FocusLock'**
  String get app_name;

  /// Morning greeting
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// Afternoon greeting
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// Evening greeting
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// AM time period
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get timeAM;

  /// PM time period
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get timePM;

  /// Cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// Delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// Edit action
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// Error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get commonError;

  /// Singular day
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get commonDay;

  /// Plural days
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get commonDays;

  /// Cycles label
  ///
  /// In en, this message translates to:
  /// **'cycles'**
  String get commonCycles;

  /// Home page title
  ///
  /// In en, this message translates to:
  /// **'Today\'s focus'**
  String get homeTitle;

  /// Button to start a focus session
  ///
  /// In en, this message translates to:
  /// **'Start Focus'**
  String get homeStartButton;

  /// Button to resume an active focus session
  ///
  /// In en, this message translates to:
  /// **'Resume Session'**
  String get homeResumeSession;

  /// Text indicating an active focus session is running
  ///
  /// In en, this message translates to:
  /// **'Focus session in progress'**
  String get homeActiveSession;

  /// Button to view statistics
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get homeStatsButton;

  /// Button to view settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeSettingsButton;

  /// Label for focus time stat
  ///
  /// In en, this message translates to:
  /// **'Focus Time'**
  String get homeStatFocusTimeLabel;

  /// Label for streak stat
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get homeStatStreakLabel;

  /// Onboarding step 1 title
  ///
  /// In en, this message translates to:
  /// **'Welcome to FocusLock'**
  String get onboardingStep1Title;

  /// Onboarding step 1 subtitle
  ///
  /// In en, this message translates to:
  /// **'A tool for deep work, not another distraction.'**
  String get onboardingStep1Subtitle;

  /// Onboarding step 2 title
  ///
  /// In en, this message translates to:
  /// **'Define Your Intention'**
  String get onboardingStep2Title;

  /// Onboarding step 2 subtitle
  ///
  /// In en, this message translates to:
  /// **'Tell us what you want to accomplish. This creates commitment.'**
  String get onboardingStep2Subtitle;

  /// Onboarding step 3 title
  ///
  /// In en, this message translates to:
  /// **'Set Your Timer'**
  String get onboardingStep3Title;

  /// Onboarding step 3 subtitle
  ///
  /// In en, this message translates to:
  /// **'Choose how long you want to focus. Start with 25 minutes.'**
  String get onboardingStep3Subtitle;

  /// Onboarding step 4 title
  ///
  /// In en, this message translates to:
  /// **'Choose Your Distractions'**
  String get onboardingStep4Title;

  /// Onboarding step 4 subtitle
  ///
  /// In en, this message translates to:
  /// **'Select the apps that pull you away from your work.'**
  String get onboardingStep4Subtitle;

  /// Onboarding step 5 title
  ///
  /// In en, this message translates to:
  /// **'Grant Permissions'**
  String get onboardingStep5Title;

  /// Onboarding step 5 subtitle
  ///
  /// In en, this message translates to:
  /// **'FocusLock needs these to protect your focus time.'**
  String get onboardingStep5Subtitle;

  /// Onboarding step 6 title
  ///
  /// In en, this message translates to:
  /// **'You\'re Ready'**
  String get onboardingStep6Title;

  /// Onboarding step 6 subtitle
  ///
  /// In en, this message translates to:
  /// **'Put your phone down and start working. We will handle the rest.'**
  String get onboardingStep6Subtitle;

  /// Next button on onboarding
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingButtonNext;

  /// Start button on onboarding
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingButtonStart;

  /// Pre-session page title
  ///
  /// In en, this message translates to:
  /// **'New Session'**
  String get presessionAppbarTitle;

  /// Task input label
  ///
  /// In en, this message translates to:
  /// **'What are you working on?'**
  String get presessionTaskLabel;

  /// Task input hint
  ///
  /// In en, this message translates to:
  /// **'e.g., Deep writing, Coding Sprint...'**
  String get presessionTaskHint;

  /// Duration selector label
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get presessionDurationLabel;

  /// Shows the active session duration; tap a chip to override
  ///
  /// In en, this message translates to:
  /// **'{duration} min will be used unless you pick another option'**
  String presessionDurationSummary(int duration);

  /// Blocked apps section label
  ///
  /// In en, this message translates to:
  /// **'Blocked Apps'**
  String get presessionBlockedAppsLabel;

  /// Empty blocked apps message
  ///
  /// In en, this message translates to:
  /// **'No apps blocked. Tap Edit to select apps.'**
  String get presessionNoBlockedApps;

  /// Error when task is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a task'**
  String get presessionErrorEmptyTask;

  /// Button to start focus session
  ///
  /// In en, this message translates to:
  /// **'Start Focus'**
  String get presessionStartButton;

  /// Cycle indicator text
  ///
  /// In en, this message translates to:
  /// **'Cycle {current} of {total}'**
  String focusCycleIndicator(int current, int total);

  /// Break period title
  ///
  /// In en, this message translates to:
  /// **'Break'**
  String get focusBreakTitle;

  /// Button to skip break
  ///
  /// In en, this message translates to:
  /// **'Skip break'**
  String get focusSkipBreak;

  /// Button to resume session
  ///
  /// In en, this message translates to:
  /// **'Resume Focus'**
  String get focusResume;

  /// Button to pause session
  ///
  /// In en, this message translates to:
  /// **'Pause Session'**
  String get focusPause;

  /// Cancel dialog title
  ///
  /// In en, this message translates to:
  /// **'Cancel Session?'**
  String get focusCancelDialogTitle;

  /// Cancel dialog content
  ///
  /// In en, this message translates to:
  /// **'Your progress will be saved but the session will be marked as cancelled.'**
  String get focusCancelDialogContent;

  /// Button to keep focusing
  ///
  /// In en, this message translates to:
  /// **'Keep Focus'**
  String get focusCancelDialogKeepGoing;

  /// Button to confirm cancellation
  ///
  /// In en, this message translates to:
  /// **'Cancel Session'**
  String get focusCancelDialogConfirm;

  /// Exit session dialog title
  ///
  /// In en, this message translates to:
  /// **'Leave Session?'**
  String get focusExitDialogTitle;

  /// Exit session dialog content
  ///
  /// In en, this message translates to:
  /// **'Your focus session keeps running in the background. You can resume it from the home screen or the notification.'**
  String get focusExitDialogContent;

  /// Button to stay in the focus session
  ///
  /// In en, this message translates to:
  /// **'Keep Focusing'**
  String get focusExitDialogStay;

  /// Button to leave the session while it keeps running
  ///
  /// In en, this message translates to:
  /// **'Exit to Home'**
  String get focusExitDialogExit;

  /// Title when session completed
  ///
  /// In en, this message translates to:
  /// **'Session Complete'**
  String get completionTitleCompleted;

  /// Title when session cancelled
  ///
  /// In en, this message translates to:
  /// **'Session Ended'**
  String get completionTitleCancelled;

  /// Task info label
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get completionInfoTask;

  /// Score info label
  ///
  /// In en, this message translates to:
  /// **'Focus Score'**
  String get completionInfoScore;

  /// Streak info label
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get completionInfoCurrentStreak;

  /// Encouraging subtitle shown when a session completes
  ///
  /// In en, this message translates to:
  /// **'Nice work! Every focused minute counts.'**
  String get completionEncourage;

  /// Done button on completion
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get completionDoneButton;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsAppbarTitle;

  /// Focus settings section
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get settingsSectionFocus;

  /// Focus duration setting
  ///
  /// In en, this message translates to:
  /// **'Focus Duration'**
  String get settingsFocusDuration;

  /// Short break setting
  ///
  /// In en, this message translates to:
  /// **'Short Break'**
  String get settingsShortBreak;

  /// Long break setting
  ///
  /// In en, this message translates to:
  /// **'Long Break'**
  String get settingsLongBreak;

  /// Cycles setting
  ///
  /// In en, this message translates to:
  /// **'Cycles'**
  String get settingsCycles;

  /// Blocking settings section
  ///
  /// In en, this message translates to:
  /// **'Blocking'**
  String get settingsSectionBlocking;

  /// Allow bypass blocking setting - when enabled, blocked apps can be opened freely
  ///
  /// In en, this message translates to:
  /// **'Allow Bypass Blocking'**
  String get settingsAllowBypassBlocking;

  /// Allow cancel session setting - when enabled, the cancel button is shown during focus
  ///
  /// In en, this message translates to:
  /// **'Allow Cancel Session'**
  String get settingsAllowCancelSession;

  /// Notifications settings section
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsSectionNotifications;

  /// Sound setting
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get settingsSound;

  /// Vibration setting
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get settingsVibration;

  /// Data settings section
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsSectionData;

  /// Export data action
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get settingsExportData;

  /// Delete history action
  ///
  /// In en, this message translates to:
  /// **'Delete History'**
  String get settingsDeleteHistory;

  /// Export success message
  ///
  /// In en, this message translates to:
  /// **'Data exported successfully'**
  String get settingsExportSuccess;

  /// Export error message
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String settingsExportError(String error);

  /// Delete dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete All History'**
  String get settingsDeleteDialogTitle;

  /// Delete dialog content
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your focus sessions. This action cannot be undone.'**
  String get settingsDeleteDialogContent;

  /// Delete success message
  ///
  /// In en, this message translates to:
  /// **'History deleted successfully'**
  String get settingsDeleteSuccess;

  /// Delete error message
  ///
  /// In en, this message translates to:
  /// **'Delete failed: {error}'**
  String settingsDeleteError(String error);

  /// Statistics page title
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statsAppbarTitle;

  /// Overview section title
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get statsOverviewSection;

  /// Sessions stat label
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get statsSessionsLabel;

  /// Sessions stat value
  ///
  /// In en, this message translates to:
  /// **'{count} completed'**
  String statsSessionsValue(int count);

  /// Focus time stat label
  ///
  /// In en, this message translates to:
  /// **'Focus Time'**
  String get statsTotalFocusTimeLabel;

  /// Streak stat label
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get statsCurrentStreakLabel;

  /// Streak stat value
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String statsCurrentStreakValue(int count);

  /// Today section label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get statsTodayLabel;

  /// Today section with count
  ///
  /// In en, this message translates to:
  /// **'Today ({count} sessions)'**
  String statsTodayWithCount(int count);

  /// Empty today title
  ///
  /// In en, this message translates to:
  /// **'No sessions today'**
  String get statsEmptyTodayTitle;

  /// Empty today description
  ///
  /// In en, this message translates to:
  /// **'Start a focus session to see your progress here.'**
  String get statsEmptyTodayDescription;

  /// Call to action button in the empty today state
  ///
  /// In en, this message translates to:
  /// **'Start Focus'**
  String get statsEmptyTodayCta;

  /// Apps page title
  ///
  /// In en, this message translates to:
  /// **'Blocked Apps'**
  String get appsAppbarTitle;

  /// Permissions required title
  ///
  /// In en, this message translates to:
  /// **'Permissions Required'**
  String get appsPermissionsRequired;

  /// Grant usage access button
  ///
  /// In en, this message translates to:
  /// **'Grant Usage Access'**
  String get appsGrantUsageAccess;

  /// Grant accessibility access button
  ///
  /// In en, this message translates to:
  /// **'Grant Accessibility Access'**
  String get appsGrantAccessibilityAccess;

  /// Empty apps title
  ///
  /// In en, this message translates to:
  /// **'No apps found'**
  String get appsEmptyTitle;

  /// Error loading apps
  ///
  /// In en, this message translates to:
  /// **'Failed to load apps: {error}'**
  String appsErrorLoad(String error);

  /// Notification title for active session
  ///
  /// In en, this message translates to:
  /// **'Focus Session Active'**
  String get notificationSessionActiveTitle;

  /// Notification body for active session
  ///
  /// In en, this message translates to:
  /// **'{task} - {minutes} minutes'**
  String notificationSessionActiveBody(String task, int minutes);

  /// Notification body when recovering session
  ///
  /// In en, this message translates to:
  /// **'{task} - {minutes} minutes remaining'**
  String notificationSessionRecoveringBody(String task, int minutes);

  /// First session achievement title
  ///
  /// In en, this message translates to:
  /// **'First Step'**
  String get achievementFirstSessionTitle;

  /// First session achievement description
  ///
  /// In en, this message translates to:
  /// **'Complete your first focus session'**
  String get achievementFirstSessionDescription;

  /// 3-day streak achievement title
  ///
  /// In en, this message translates to:
  /// **'Consistent'**
  String get achievementStreak3Title;

  /// 3-day streak achievement description
  ///
  /// In en, this message translates to:
  /// **'Maintain a 3-day streak'**
  String get achievementStreak3Description;

  /// 7-day streak achievement title
  ///
  /// In en, this message translates to:
  /// **'Dedicated'**
  String get achievementStreak7Title;

  /// 7-day streak achievement description
  ///
  /// In en, this message translates to:
  /// **'Maintain a 7-day streak'**
  String get achievementStreak7Description;

  /// 10 sessions achievement title
  ///
  /// In en, this message translates to:
  /// **'Focused'**
  String get achievementSessions10Title;

  /// 10 sessions achievement description
  ///
  /// In en, this message translates to:
  /// **'Complete 10 focus sessions'**
  String get achievementSessions10Description;

  /// 50 sessions achievement title
  ///
  /// In en, this message translates to:
  /// **'Disciplined'**
  String get achievementSessions50Title;

  /// 50 sessions achievement description
  ///
  /// In en, this message translates to:
  /// **'Complete 50 focus sessions'**
  String get achievementSessions50Description;

  /// 10 hours focus achievement title
  ///
  /// In en, this message translates to:
  /// **'Deep Worker'**
  String get achievementFocus10hTitle;

  /// 10 hours focus achievement description
  ///
  /// In en, this message translates to:
  /// **'Accumulate 10 hours of focus time'**
  String get achievementFocus10hDescription;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Clear text field action
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClear;

  /// Header chip label
  ///
  /// In en, this message translates to:
  /// **'Calm Mind'**
  String get homeCalmMind;

  /// Subtitle under the greeting
  ///
  /// In en, this message translates to:
  /// **'Your scheduled deep session is ready.'**
  String get homeScheduleReady;

  /// Number of completed sessions today
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} session completed} other{{count} sessions completed}}'**
  String homeSessionsCompleted(int count);

  /// Percent of daily goal reached
  ///
  /// In en, this message translates to:
  /// **'{percent}% goal'**
  String homeGoalPercent(int percent);

  /// Current streak in days
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} day streak} other{{count} days streak}}'**
  String homeStreakLabel(int count);

  /// Best streak value
  ///
  /// In en, this message translates to:
  /// **'Best: {count} days'**
  String homeBestStreak(int count);

  /// Streak badge
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get homeStreakActive;

  /// Recent sessions section title
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get homeRecentActivity;

  /// Link to statistics
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get homeViewAll;

  /// Empty recent activity message
  ///
  /// In en, this message translates to:
  /// **'No sessions yet. Start your first focus session.'**
  String get homeRecentEmpty;

  /// Completed session status
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get homeRecentCompleted;

  /// Cancelled session status
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get homeRecentCancelled;

  /// Pre-session header chip
  ///
  /// In en, this message translates to:
  /// **'Session Setup'**
  String get presessionSetupChip;

  /// Pre-session header title
  ///
  /// In en, this message translates to:
  /// **'Ready to focus?'**
  String get presessionReadyTitle;

  /// Pre-session header subtitle
  ///
  /// In en, this message translates to:
  /// **'Set your intention and lock away distractions.'**
  String get presessionReadySubtitle;

  /// Task input required badge
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get presessionRequired;

  /// Default task text prefilled in the input
  ///
  /// In en, this message translates to:
  /// **'Build my Flutter application'**
  String get presessionTaskDefault;

  /// Custom duration action
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get presessionCustom;

  /// Minutes unit label
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get presessionMin;

  /// Blocked apps section title
  ///
  /// In en, this message translates to:
  /// **'Apps to block'**
  String get presessionAppsToBlock;

  /// Number of active blocked apps
  ///
  /// In en, this message translates to:
  /// **'{count} active'**
  String presessionActiveCount(int count);

  /// Manage blocked apps action
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get presessionManage;

  /// Remaining blocked apps count
  ///
  /// In en, this message translates to:
  /// **'+{count} more'**
  String presessionMoreCount(int count);

  /// Enforcement mode section title
  ///
  /// In en, this message translates to:
  /// **'Enforcement Mode'**
  String get presessionEnforcementMode;

  /// Standard enforcement mode name
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get modeStandard;

  /// Standard enforcement mode description
  ///
  /// In en, this message translates to:
  /// **'Leave when you need to without penalty. Keeps track of intentional exits.'**
  String get modeStandardDescription;

  /// Strict enforcement mode name
  ///
  /// In en, this message translates to:
  /// **'Strict'**
  String get modeStrict;

  /// Strict enforcement mode description
  ///
  /// In en, this message translates to:
  /// **'Leaving counts as an interruption. Emergency unlock requires a 60-second cooldown wait.'**
  String get modeStrictDescription;

  /// Recommended mode badge
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get modeRecommended;

  /// Start button including the chosen duration
  ///
  /// In en, this message translates to:
  /// **'Start Focus ({min} min)'**
  String presessionStartWithDuration(int min);

  /// Tip about face-down display dimming
  ///
  /// In en, this message translates to:
  /// **'Putting your phone face-down will automatically dim the display.'**
  String get presessionFaceDownTip;

  /// Strict mode chip label
  ///
  /// In en, this message translates to:
  /// **'STRICT FOCUS'**
  String get focusModeStrict;

  /// Standard mode chip label
  ///
  /// In en, this message translates to:
  /// **'STANDARD FOCUS'**
  String get focusModeStandard;

  /// Break indicator under the timer
  ///
  /// In en, this message translates to:
  /// **'BREAK TIME'**
  String get focusBreakTime;

  /// Focus indicator under the timer
  ///
  /// In en, this message translates to:
  /// **'RESTRICTED MODE'**
  String get focusRestrictedMode;

  /// Paused state indicator
  ///
  /// In en, this message translates to:
  /// **'PAUSED'**
  String get focusPausedLabel;

  /// Message when no apps are blocked
  ///
  /// In en, this message translates to:
  /// **'No apps blocked'**
  String get focusNoAppsBlocked;

  /// Message when one or more apps are blocked
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Phone is locked down • {count} app blocked} other{Phone is locked down • {count} apps blocked}}'**
  String focusLockedDownCount(int count);

  /// Zen mantra shown during focus
  ///
  /// In en, this message translates to:
  /// **'Put your phone down and dive in.'**
  String get focusZenPill;

  /// Action to end the session early
  ///
  /// In en, this message translates to:
  /// **'End session early'**
  String get focusEndSessionEarly;

  /// End session confirmation sheet title
  ///
  /// In en, this message translates to:
  /// **'Break Focus Session?'**
  String get focusSheetTitle;

  /// End session confirmation sheet body
  ///
  /// In en, this message translates to:
  /// **'Your current streak will reset for today.'**
  String get focusSheetBody;

  /// Button to cancel the session and unlock the phone
  ///
  /// In en, this message translates to:
  /// **'Unlock Phone'**
  String get focusUnlockPhone;

  /// Fallback task label when no intention is set
  ///
  /// In en, this message translates to:
  /// **'Your focus session'**
  String get blockedDefaultTask;

  /// Fallback blocked app name
  ///
  /// In en, this message translates to:
  /// **'This app'**
  String get blockedFallbackApp;

  /// Blocked app page badge
  ///
  /// In en, this message translates to:
  /// **'Intervention Gate'**
  String get blockedInterventionGate;

  /// Blocked app page title
  ///
  /// In en, this message translates to:
  /// **'Stay focused.'**
  String get blockedStayFocused;

  /// Blocked app page subtitle
  ///
  /// In en, this message translates to:
  /// **'Breathe. Your future self will thank you for finishing this session.'**
  String get blockedBreathe;

  /// Intention card label
  ///
  /// In en, this message translates to:
  /// **'You chose to focus on'**
  String get blockedYouChose;

  /// Intention card badge
  ///
  /// In en, this message translates to:
  /// **'Deep Work'**
  String get blockedDeepWork;

  /// Remaining focus time
  ///
  /// In en, this message translates to:
  /// **'{time} remaining'**
  String blockedTimeRemaining(String time);

  /// Planned session duration
  ///
  /// In en, this message translates to:
  /// **'Session target: {minutes}m'**
  String blockedSessionTarget(int minutes);

  /// Blocked app card title
  ///
  /// In en, this message translates to:
  /// **'{app} is locked'**
  String blockedAppIsLocked(String app);

  /// Blocked app card subtitle
  ///
  /// In en, this message translates to:
  /// **'Scheduled inside your focus shield'**
  String get blockedFocusShield;

  /// Strict mode warning title
  ///
  /// In en, this message translates to:
  /// **'Strict Mode is active'**
  String get blockedStrictActive;

  /// Strict mode warning body
  ///
  /// In en, this message translates to:
  /// **'Leaving this session early will be permanently logged as an interruption on your weekly streak.'**
  String get blockedStrictWarning;

  /// Primary action on blocked app page
  ///
  /// In en, this message translates to:
  /// **'Return to focus'**
  String get blockedReturnToFocus;

  /// Secondary action on blocked app page
  ///
  /// In en, this message translates to:
  /// **'End session anyway'**
  String get blockedEndSessionAnyway;

  /// Motivational hint under the actions
  ///
  /// In en, this message translates to:
  /// **'Urges peak and fade within 3 minutes'**
  String get blockedUrges;

  /// Abandon session sheet title
  ///
  /// In en, this message translates to:
  /// **'Break your streak?'**
  String get blockedBreakStreak;

  /// Abandon session sheet body
  ///
  /// In en, this message translates to:
  /// **'You are only minutes away from locking in today\'s best focus session. Take three slow breaths instead.'**
  String get blockedBreath;

  /// Abandon session sheet primary action
  ///
  /// In en, this message translates to:
  /// **'I will keep going'**
  String get blockedKeepGoing;

  /// Abandon session sheet secondary action
  ///
  /// In en, this message translates to:
  /// **'Quit session'**
  String get blockedQuitSession;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
