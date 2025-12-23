import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Biru Soft
  static const Color primary = Color(0xFF4A90E2);
  static const Color primaryLight = Color(0xFF6BA5EA);
  static const Color primaryDark = Color(0xFF3B7BD0);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF7BB3F0);
  static const Color secondaryLight = Color(0xFF9BC5F3);
  static const Color secondaryDark = Color(0xFF5A9DE8);
  
  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F7FA);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF546E7A);
  static const Color textTertiary = Color(0xFF90A4AE);
  static const Color textLight = Color(0xFFB0BEC5);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFECEFF1);
  static const Color greyDark = Color(0xFF455A64);
  
  // Card Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x1A000000);
  
  // Button Colors
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = Color(0xFFE3F2FD);
  static const Color buttonDisabled = Color(0xFFBDBDBD);
  
  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF5F5F5);
  static const Color borderDark = Color(0xFFBDBDBD);
  
  // Special Colors for GERD Care
  static const Color healthGreen = Color(0xFF66BB6A);
  static const Color warningAmber = Color(0xFFFFCA28);
  static const Color dangerRed = Color(0xFFEF5350);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, surface],
  );
}
