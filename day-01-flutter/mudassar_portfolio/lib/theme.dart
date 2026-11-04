import 'package:flutter/material.dart';

// Colours used across the app: navy, green and light grey.
abstract final class AppColors {
  static const navy = Color(0xFF0A1F44);
  static const green = Color(0xFF1E7A46);
  static const greenLight = Color(0xFFE6F4EC);
  static const lightGrey = Color(0xFFF4F6F8);
  static const textDark = Color(0xFF1A2332);
  static const textMuted = Color(0xFF5A6B82);
}

ThemeData buildPortfolioTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.navy,
    primary: AppColors.navy,
    secondary: AppColors.green,
    surface: Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      displayMedium: TextStyle(
        fontSize: 52,
        height: 1.05,
        fontWeight: FontWeight.w800,
        color: AppColors.navy,
        letterSpacing: -1,
      ),
      headlineMedium: TextStyle(
        fontSize: 30,
        height: 1.15,
        fontWeight: FontWeight.w800,
        color: AppColors.navy,
        letterSpacing: -0.5,
      ),
      titleLarge: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
      bodyLarge: TextStyle(
        fontSize: 17,
        height: 1.6,
        color: AppColors.textMuted,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        height: 1.6,
        color: AppColors.textMuted,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.green,
        letterSpacing: 1.2,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE3E9F0)),
      ),
    ),
  );
}
