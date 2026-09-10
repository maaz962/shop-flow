import 'package:flutter/material.dart';

/// Palette extracted from the ShopFlow logo / splash reference:
/// - Near-black, green-tinted background  (#0A0F0D)
/// - Bright emerald green                 (#22D66B) — the cart-icon gradient stop
/// - Deep green                           (#0F9D4F) — gradient tail / pressed state
/// - Mint tint                            (#7CF4A8) — chips / light highlights
/// - Logo gradient runs white -> green, top-left to bottom-right
class AppColors {
  AppColors._();

  // Brand green family
  static const Color green = Color(0xFF22D66B);
  static const Color greenDeep = Color(0xFF0F9D4F);
  static const Color greenLight = Color(0xFF7CF4A8);

  // Dark theme surfaces
  static const Color bgDark = Color(0xFF0A0F0D);
  static const Color bgDarkDeep = Color(0xFF050807);
  static const Color surfaceDark = Color(0xFF141C1A);
  static const Color surfaceDarkAlt = Color(0xFF1B2622);
  static const Color textOnDarkMuted = Color(0xFFB6C4BF);

  // Light theme surfaces
  static const Color bgLight = Color(0xFFF3FBF6);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF0B1F17); // brand-tinted near-black text
  static const Color textOnLightMuted = Color(0xFF5A6B64);

  // Contrast-safe "on green" color (green is bright enough that pure white
  // text sits a little low-contrast, so buttons/labels on green use this)
  static const Color onGreen = Color(0xFF06170F);

  /// Logo mark gradient — white fading into brand green, matches the cart icon.
  static const LinearGradient logoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white, green],
  );

  /// Splash / hero background gradient (near-black, subtle green depth).
  static const LinearGradient splashBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bgDark, bgDarkDeep],
  );

  /// CTA gradient for standout buttons in either theme.
  static const LinearGradient ctaGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [green, greenDeep],
  );

  /// Soft radial glow used behind the logo on the splash screen.
  static RadialGradient glow({double opacity = 0.35}) => RadialGradient(
    colors: [green.withOpacity(opacity), Colors.transparent],
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: 'Poppins',

    colorScheme: const ColorScheme.light(
      primary: AppColors.green,
      onPrimary: AppColors.onGreen,

      secondary: AppColors.greenDeep,
      onSecondary: Colors.white,

      tertiary: AppColors.greenLight,
      onTertiary: AppColors.ink,

      surface: AppColors.surfaceLight,
      onSurface: AppColors.ink,

      error: Color(0xFFD32F2F),
      onError: Colors.white,
    ),

    scaffoldBackgroundColor: AppColors.bgLight,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgLight,
      foregroundColor: AppColors.ink,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),

    cardTheme: CardThemeData(
      color: AppColors.surfaceLight,
      elevation: 2,
      shadowColor: AppColors.green.withOpacity(0.12),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.onGreen,
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.greenDeep,
        side: const BorderSide(color: AppColors.green),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.greenDeep),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      hintStyle: TextStyle(color: AppColors.ink.withOpacity(0.4)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.green, width: 2),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.greenLight.withOpacity(0.35),
      selectedColor: AppColors.green,
      labelStyle: const TextStyle(color: AppColors.ink),
      secondaryLabelStyle: const TextStyle(color: AppColors.onGreen),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),

    iconTheme: const IconThemeData(color: AppColors.ink),
    dividerColor: AppColors.ink.withOpacity(0.08),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: 'Poppins',

    colorScheme: const ColorScheme.dark(
      primary: AppColors.green,
      onPrimary: AppColors.onGreen,

      secondary: AppColors.greenLight,
      onSecondary: AppColors.onGreen,

      tertiary: AppColors.greenDeep,
      onTertiary: Colors.white,

      surface: AppColors.surfaceDark,
      onSurface: Colors.white,

      error: Color(0xFFEF5350),
      onError: Colors.black,
    ),

    scaffoldBackgroundColor: AppColors.bgDark,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgDark,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),

    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.4),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.onGreen,
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.green,
        side: const BorderSide(color: AppColors.green),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.green),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDarkAlt,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.green, width: 2),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceDarkAlt,
      selectedColor: AppColors.green,
      labelStyle: const TextStyle(color: Colors.white),
      secondaryLabelStyle: const TextStyle(color: AppColors.onGreen),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),

    iconTheme: const IconThemeData(color: Colors.white),
    dividerColor: Colors.white.withOpacity(0.08),
  );
}