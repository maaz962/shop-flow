import 'package:flutter/material.dart';

/// Raw palette extracted from the reference shop-flow UI:
/// - Deep navy   (#16213E) -> hero background, primary buttons/chips
/// - Sky blue    (#B9DDED) -> mockup backdrop, secondary surfaces
/// - Gold        (#FFC107) -> star ratings / highlight accents
/// - Ink         (#102A3A) -> primary text on light surfaces
class AppColors {
  AppColors._();

  // Brand
  static const Color navy = Color(0xFF16213E);
  static const Color navyDeep = Color(0xFF0D1B2A);
  static const Color skyBlue = Color(0xFFB9DDED);
  static const Color skyBlueMuted = Color(0xFF5C9FBD);
  static const Color gold = Color(0xFFFFC107);
  static const Color goldBright = Color(0xFFFFD54F);

  // Ink / text
  static const Color ink = Color(0xFF102A3A);
  static const Color inkOnDark = Color(0xFFEAF4FA);

  // Light theme surfaces
  static const Color lightScaffold = Color(0xFFF5FAFD);
  static const Color lightSurface = Color(0xFFFFFFFF);

  // Dark theme surfaces
  static const Color darkScaffold = Color(0xFF0D1B24);
  static const Color darkSurface = Color(0xFF182936);
  static const Color darkPrimary = Color(0xFF8CCCE6); // brightened skyBlue

  /// Hero / onboarding background gradient (matches the reference's
  /// dark navy panel).
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navy, navyDeep],
  );

  /// CTA gradient for standout buttons/badges (e.g. "Checkout", promo cards).
  static const LinearGradient ctaGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [navy, skyBlueMuted],
  );

  /// Dark-mode counterpart of [heroGradient] — same family, lifted so it
  /// still reads against near-black scaffolds.
  static const LinearGradient heroGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkSurface, darkScaffold],
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,

    colorScheme: const ColorScheme.light(
      primary: AppColors.navy,
      onPrimary: Colors.white,

      secondary: AppColors.skyBlue,
      onSecondary: AppColors.ink,

      tertiary: AppColors.gold,
      onTertiary: AppColors.ink,

      surface: AppColors.lightSurface,
      onSurface: AppColors.ink,

      error: Color(0xFFD32F2F),
      onError: Colors.white,
    ),

    scaffoldBackgroundColor: AppColors.lightScaffold,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightScaffold,
      foregroundColor: AppColors.ink,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),

    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      elevation: 3,
      shadowColor: AppColors.navy.withOpacity(0.08),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.navy,
        side: const BorderSide(color: AppColors.navy),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.navy,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      hintStyle: TextStyle(color: AppColors.ink.withOpacity(0.4)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.navy, width: 2),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightSurface,
      selectedColor: AppColors.navy,
      labelStyle: const TextStyle(color: AppColors.ink),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      side: BorderSide(color: AppColors.ink.withOpacity(0.15)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),

    iconTheme: const IconThemeData(color: AppColors.ink),

    dividerColor: AppColors.ink.withOpacity(0.08),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkScaffold,

      secondary: AppColors.skyBlueMuted,
      onSecondary: Colors.white,

      tertiary: AppColors.goldBright,
      onTertiary: AppColors.ink,

      surface: AppColors.darkSurface,
      onSurface: Colors.white,

      error: Color(0xFFEF5350),
      onError: Colors.black,
    ),

    scaffoldBackgroundColor: AppColors.darkScaffold,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkScaffold,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),

    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.3),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkScaffold,
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,
        side: const BorderSide(color: AppColors.darkPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedColor: AppColors.darkPrimary,
      labelStyle: const TextStyle(color: Colors.white),
      secondaryLabelStyle: const TextStyle(color: AppColors.darkScaffold),
      side: BorderSide(color: Colors.white.withOpacity(0.12)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),

    iconTheme: const IconThemeData(color: Colors.white),

    dividerColor: Colors.white.withOpacity(0.08),
  );
}