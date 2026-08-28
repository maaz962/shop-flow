import 'package:flutter/material.dart';

class AppTheme {

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,

    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFFA800),
      secondary: Color(0xFF8CCCE6),

      surface: Colors.white,

      onPrimary: Colors.white,
      onSecondary: Color(0xFF102A3A),
      onSurface: Color(0xFF102A3A),
    ),

    scaffoldBackgroundColor: const Color(0xFFB9DDED),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFB9DDED),
      foregroundColor: Color(0xFF102A3A),
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFA800),
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFFFA800),
        side: const BorderSide(
          color: Color(0xFFFFA800),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFFFA800),
          width: 2,
        ),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFFFFA800),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFFB52E),
      secondary: Color(0xFF5C9FBD),

      surface: Color(0xFF182936),

      onPrimary: Color(0xFF17232D),
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),

    scaffoldBackgroundColor: const Color(0xFF0D1B24),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0D1B24),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: Color(0xFF182936),
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFB52E),
        foregroundColor: const Color(0xFF17232D),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFFFB52E),
        side: const BorderSide(
          color: Color(0xFFFFB52E),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF182936),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFFFB52E),
          width: 2,
        ),
      ),
    ),
  );
}