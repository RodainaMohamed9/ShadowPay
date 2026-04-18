import 'package:flutter/material.dart';

class AppColors {
  // ========== Dark Mode Colors ==========
  static const Color darkBackground = Color(0xFF101622);
  static const Color darkSurface = Color(0xFF1A1F2F);
  static const Color darkPrimary = Color(0xFF00BBA7);
  static const Color darkSecondary = Color(0xFF00D1B8);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B8C5);
  static const Color darkHint = Color(0xFF8E98A8);
  static const Color darkProgressBg = Color(0xFF2A2F3F);

  // ========== Light Mode Colors ==========
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Colors.white;
  static const Color lightPrimary = Color(0xFF00897B);
  static const Color lightSecondary = Color(0xFF009688);
  static const Color lightTextPrimary = Color(0xFF1A1F2F);
  static const Color lightTextSecondary = Color(0xFF5F6A7A);
  static const Color lightHint = Color(0xFF8E98A8);
  static const Color lightProgressBg = Color(0xFFE0E0E0);

  // ========== Common Colors (used in both modes) ==========
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF34A853);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);

  // ========== Helper Methods ==========
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? darkBackground 
        : lightBackground;
  }
  
  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? darkSurface 
        : lightSurface;
  }
  
  static Color getTextPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? darkTextPrimary 
        : lightTextPrimary;
  }
  
  static Color getTextSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? darkTextSecondary 
        : lightTextSecondary;
  }
  
  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? darkPrimary 
        : lightPrimary;
  }
  
  static Color getSecondaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? darkSecondary 
        : lightSecondary;
  }
  
  static Color getHintColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? darkHint 
        : lightHint;
  }
  
  static Color getProgressBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? darkProgressBg 
        : lightProgressBg;
  }
}

// ========== Extension for easier usage ==========
extension ThemeColors on BuildContext {
  // Theme-based colors
  Color get primaryColor => AppColors.getPrimaryColor(this);
  Color get secondaryColor => AppColors.getSecondaryColor(this);
  Color get surfaceColor => AppColors.getSurfaceColor(this);
  Color get backgroundColor => AppColors.getBackgroundColor(this);
  Color get textPrimary => AppColors.getTextPrimary(this);
  Color get textSecondary => AppColors.getTextSecondary(this);
  Color get hintColor => AppColors.getHintColor(this);
  Color get progressBgColor => AppColors.getProgressBgColor(this);
  
  // Common colors
  Color get errorColor => AppColors.error;
  Color get successColor => AppColors.success;
  Color get warningColor => AppColors.warning;
  Color get infoColor => AppColors.info;
  
  // Direct dark/light colors (when you need specific mode)
  Color get darkPrimary => AppColors.darkPrimary;
  Color get lightPrimary => AppColors.lightPrimary;
  Color get darkBackground => AppColors.darkBackground;
  Color get lightBackground => AppColors.lightBackground;
  Color get darkSurface => AppColors.darkSurface;
  Color get lightSurface => AppColors.lightSurface;
  Color get darkTextPrimary => AppColors.darkTextPrimary;
  Color get lightTextPrimary => AppColors.lightTextPrimary;
  Color get darkTextSecondary => AppColors.darkTextSecondary;
  Color get lightTextSecondary => AppColors.lightTextSecondary;
  
  // Boolean helper
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;
}