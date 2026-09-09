import 'package:flutter/material.dart';

/// Design system defined in `design/DESIGN.md`.
///
/// Material 3 minimalist, dark-first palette centered on a calm emerald
/// accent. Typography uses the Inter family loaded from `assets/fonts`.
class AppTheme {
  AppTheme._();

  // --- Surface tokens (Level 0 canvas) ---
  static const Color backgroundColor = Color(0xFF121316);
  static const Color surfaceColor = Color(0xFF1F1F23);
  static const Color cardColor = Color(0xFF1F1F23);
  static const Color surfaceContainerLowest = Color(0xFF0D0E11);
  static const Color surfaceContainerLow = Color(0xFF1B1B1F);
  static const Color surfaceContainerHigh = Color(0xFF292A2D);
  static const Color surfaceContainerHighest = Color(0xFF343538);

  // --- Text tokens ---
  static const Color textColor = Color(0xFFE3E2E6);
  static const Color textSecondaryColor = Color(0xFFBBCABF);
  static const Color onSurfaceVariant = Color(0xFFBBCABF);
  static const Color onSurface = Color(0xFFE3E2E6);

  // --- Brand / functional tokens ---
  static const Color primaryColor = Color(0xFF4EDEA3);
  static const Color onPrimaryColor = Color(0xFF003824);
  static const Color primaryContainer = Color(0xFF10B981);
  static const Color onPrimaryContainer = Color(0xFF00422B);
  static const Color inversePrimary = Color(0xFF006C49);
  static const Color accentColor = Color(0xFF45DFA4);
  static const Color secondaryColor = Color(0xFF45DFA4);
  static const Color tertiaryColor = Color(0xFFFFB95F);
  static const Color errorColor = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);

  // --- Strokes ---
  static const Color dividerColor = Color(0xFF353844);
  static const Color outlineColor = Color(0xFF86948A);
  static const Color outlineVariant = Color(0xFF3C4A42);

  static const String fontFamily = 'Inter';

  static ThemeData get darkTheme {
    const scheme = ColorScheme.dark(
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondaryColor,
      onSecondary: Color(0xFF003825),
      secondaryContainer: Color(0xFF00BD85),
      onSecondaryContainer: Color(0xFF00452E),
      tertiary: tertiaryColor,
      onTertiary: Color(0xFF472A00),
      tertiaryContainer: Color(0xFFE29100),
      onTertiaryContainer: Color(0xFF523200),
      error: errorColor,
      onError: Color(0xFF690005),
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      outline: outlineColor,
      outlineVariant: outlineVariant,
      surface: backgroundColor,
      onSurface: onSurface,
      surfaceContainerLowest: surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow,
      surfaceContainer: cardColor,
      surfaceContainerHigh: surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest,
      inverseSurface: Color(0xFFE3E2E6),
      onInverseSurface: Color(0xFF2F3034),
      inversePrimary: inversePrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      dividerColor: dividerColor,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 72,
          height: 1.11,
          fontWeight: FontWeight.w600,
          letterSpacing: -1.6,
          color: onSurface,
        ),
        displayMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 56,
          height: 1.14,
          fontWeight: FontWeight.w600,
          letterSpacing: -1,
          color: onSurface,
        ),
        displaySmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 48,
          height: 1.17,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.6,
          color: onSurface,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        headlineLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 32,
          height: 1.25,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: onSurface,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 24,
          height: 1.33,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.1,
          color: onSurface,
        ),
        headlineSmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          height: 1.4,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        titleLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          height: 1.4,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        titleMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          height: 1.5,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        titleSmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          height: 1.43,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          height: 1.5,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
          color: onSurface,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          height: 1.43,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
          color: onSurface,
        ),
        bodySmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          height: 1.33,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
          color: onSurfaceVariant,
        ),
        labelLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          height: 1.43,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          color: onSurface,
        ),
        labelMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          height: 1.33,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          color: onSurface,
        ),
        labelSmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 10,
          height: 1.4,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: onSurfaceVariant,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        iconTheme: IconThemeData(color: onSurface),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryContainer,
          foregroundColor: onPrimaryContainer,
          minimumSize: const Size(double.infinity, 56),
          elevation: 0,
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: onSurface,
          backgroundColor: cardColor,
          minimumSize: const Size(double.infinity, 48),
          side: const BorderSide(color: outlineVariant, width: 1),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          shape: const StadiumBorder(),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF121316);
          }
          return const Color(0xFF949AA8);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryContainer;
          }
          return surfaceContainerHighest;
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceContainerHigh,
        contentTextStyle: const TextStyle(color: onSurface, fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: outlineVariant),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          height: 1.4,
          color: onSurfaceVariant,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerHigh,
        hintStyle: const TextStyle(color: onSurfaceVariant, fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }
}