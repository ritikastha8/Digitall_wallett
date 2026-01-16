import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ----------------- Primary Colors -----------------
  static const Color primary = Color(0xFFD07522);
  static const Color primaryDark = Color(0xFF357ABD);
  static const Color primaryLight = Color(0xFF78A9E0);

  // ----------------- Secondary Colors -----------------
  static const Color secondary = Color(0xFFFFA726);
  static const Color secondaryLight = Color(0xFFFFC168);

  // ----------------- Neutral Colors -----------------
  static const Color background = Color.fromARGB(255, 255, 255, 255);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F6FA);
  static const Color inputFill = Color(0xFFF5F5F5);

  // ----------------- Text Colors -----------------
  static const Color textPrimary = Color(0xFF2D3142);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  // ----------------- Borders & Dividers -----------------
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFEFF0F6);

  // ----------------- Status Colors -----------------
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ----------------- Dark Theme Colors -----------------
  static const Color darkBackground = Color(0xFF0F1419);
  static const Color darkSurface = Color(0xFF1A1F26);
  static const Color darkSurfaceVariant = Color(0xFF242A32);
  static const Color darkInputFill = Color(0xFF1E242C);

  static const Color darkTextPrimary = Color(0xFFE8EAED);
  static const Color darkTextSecondary = Color(0xFFB4B8BB);
  static const Color darkTextTertiary = Color(0xFF7C8186);

  static const Color darkBorder = Color(0xFF2D3339);
  static const Color darkDivider = Color(0xFF252B33);

  // ----------------- Shadows -----------------
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x146C63FF), blurRadius: 24, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> darkCardShadow = [
    BoxShadow(color: Color(0x26000000), blurRadius: 24, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> softShadow = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> darkSoftShadow = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(color: Color(0x406C63FF), blurRadius: 16, offset: Offset(0, 4)),
  ];

  // ----------------- Text opacity -----------------
  static const Color textSecondary60 = Color(0x996B7280);
  static const Color textSecondary50 = Color(0x806B7280);

  // ----------------- Gradients for Buttons -----------------
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFA726), Color(0xFFFFC168)],
  );
}
