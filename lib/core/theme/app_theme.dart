import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color secondaryGold = Color(0xFFFFD700);
  static const Color cardRed = Color(0xFFD32F2F);
  static const Color cardBlack = Color(0xFF212121);
  
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: MaterialColor(
      primaryGreen.value,
      <int, Color>{
        50: primaryGreen.withOpacity(0.1),
        100: primaryGreen.withOpacity(0.2),
        200: primaryGreen.withOpacity(0.3),
        300: primaryGreen.withOpacity(0.4),
        400: primaryGreen.withOpacity(0.5),
        500: primaryGreen,
        600: primaryGreen.withOpacity(0.7),
        700: primaryGreen.withOpacity(0.8),
        800: primaryGreen.withOpacity(0.9),
        900: primaryGreen,
      },
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: MaterialColor(
      primaryGreen.value,
      <int, Color>{
        50: primaryGreen.withOpacity(0.1),
        100: primaryGreen.withOpacity(0.2),
        200: primaryGreen.withOpacity(0.3),
        300: primaryGreen.withOpacity(0.4),
        400: primaryGreen.withOpacity(0.5),
        500: primaryGreen,
        600: primaryGreen.withOpacity(0.7),
        700: primaryGreen.withOpacity(0.8),
        800: primaryGreen.withOpacity(0.9),
        900: primaryGreen,
      },
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      color: Color(0xFF1F1F1F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}