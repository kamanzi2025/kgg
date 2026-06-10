import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF0D1117);
  static const Color cardBackground = Color(0xFF1A2233);
  static const Color cardBackgroundLight = Color(0xFF1F2D45);
  static const Color accentGold = Color(0xFFF5A623);
  static const Color accentAmber = Color(0xFFFFC107);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9BA3AF);
  static const Color textTertiary = Color(0xFF6B7280);
  static const Color successGreen = Color(0xFF22C55E);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color warningOrange = Color(0xFFF97316);
  static const Color borderColor = Color(0xFF2D3748);
  static const Color surfaceColor = Color(0xFF0F1923);
  static const Color chipSelected = Color(0xFF2A3A5C);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF5A623), Color(0xFFFFC107)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A2233), Color(0xFF0D1117)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF0D1117), Color(0xFF1B2A4A), Color(0xFF0D1117)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
