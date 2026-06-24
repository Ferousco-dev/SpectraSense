import 'package:flutter/material.dart';

/// SpectraSense brand theme.
/// Primary green #0E8C2C, dark variant for hover/active states.
class AppTheme {
  static const Color primaryGreen = Color(0xFF0E8C2C);
  static const Color greenDark = Color(0xFF0A6B21);
  static const Color greenLight = Color(0xFF3FBF63);
  static const Color greenSoft = Color(0xFF8AE4A1);
  static const Color ping = Color(0xFFFFD84D);

  static const Color bg = Color(0xFF0B0F0C);
  static const Color surface = Color(0xFF16201A);
  static const Color textPrimary = Color(0xFFF2F7F3);
  static const Color textSecondary = Color(0xFF9DB3A4);

  // Confidence band colors
  static const Color bandHigh = Color(0xFF0E8C2C);
  static const Color bandMaybe = Color(0xFFE0A100);
  static const Color bandUnknown = Color(0xFF5A6B60);

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: const ColorScheme.dark(
          primary: primaryGreen,
          secondary: greenLight,
          surface: surface,
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: bg,
          elevation: 0,
          centerTitle: false,
        ),
      );
}
