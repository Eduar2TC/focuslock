import 'package:flutter/foundation.dart';
import 'app_localizations.dart';

/// Holds the currently active [AppLocalizations] instance so background
/// services (e.g. foreground session notifications) can resolve localized
/// strings without a BuildContext.
///
/// Updated by the app's [MaterialApp.builder] whenever the locale changes.
final ValueNotifier<AppLocalizations?> activeAppLocalizations =
    ValueNotifier<AppLocalizations?>(null);