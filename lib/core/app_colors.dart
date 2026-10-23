import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette (Balanced Blue and White)
  static const Color primaryDark = Color(0xFF0D47A1); // Deep Indian Blue
  static const Color primary = Color(0xFF1565C0); // Official Brand Blue
  static const Color primaryLight = Color(0xFF1976D2); // Medium Blue
  static const Color primaryTint = Color(0xFFE3F2FD); // Light Blue tint
  static const Color secondary = Color(0xFF0284C7); // Cyan Accent
  static const Color accent = Color(0xFF0284C7); // Cyan Accent alias

  // Background & Surface
  static const Color background = Color(0xFFF8FAFD); // Crisp Clean White-Blue
  static const Color surface = Color(0xFFFFFFFF); // Pure White
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);

  // Typography Colors
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status & Feedback
  static const Color success = Color(0xFF16A34A); // Green
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color error = Color(0xFFDC2626); // Red
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFFD97706); // Amber
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF2563EB); // Royal Blue
  static const Color infoLight = Color(0xFFDBEAFE);

  // Category Accent Colors
  static const Color cyberSafety = Color(0xFF0284C7);
  static const Color govServices = Color(0xFF2563EB);
  static const Color roadSafety = Color(0xFFD97706);
  static const Color healthEmergency = Color(0xFFDC2626);
  static const Color financialLiteracy = Color(0xFF059669);
  static const Color environment = Color(0xFF16A34A);

  static Color getCategoryColor(String categoryId) {
    switch (categoryId) {
      case 'cyber_safety':
        return cyberSafety;
      case 'gov_services':
        return govServices;
      case 'road_safety':
        return roadSafety;
      case 'health_emergency':
        return healthEmergency;
      case 'financial_literacy':
        return financialLiteracy;
      case 'environment':
        return environment;
      default:
        return primary;
    }
  }
}
