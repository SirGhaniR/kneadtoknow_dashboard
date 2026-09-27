import 'package:flutter/material.dart';

class AppColors {
  static const gray50 = Color(0xFFf9fafb);
  static const gray100 = Color(0xFFf3f4f6);
  static const gray200 = Color(0xFFe5e7eb);
  static const gray300 = Color(0xFFd1d5db);
  static const gray400 = Color(0xFF9ca3af);
  static const gray500 = Color(0xFF6b7280);
  static const gray600 = Color(0xFF4b5563);
  static const gray700 = Color(0xFF374151);
  static const gray800 = Color(0xFF1f2937);
  static const gray900 = Color(0xFF111827);
  static const gray950 = Color(0xFF030712);
  static const yellow50 = Color(0xFFfefce8);
  static const yellow100 = Color(0xFFfef9c3);
  static const yellow200 = Color(0xFFfef08a);
  static const yellow300 = Color(0xFFfde047);
  static const yellow400 = Color(0xFFfacc15);
  static const yellow500 = Color(0xFFeab308);
  static const yellow600 = Color(0xFFca8a04);
  static const yellow700 = Color(0xFFa16207);
  static const yellow800 = Color(0xFF854d0e);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Montserrat',
      scaffoldBackgroundColor: AppColors.gray50,
      colorScheme: const ColorScheme.light(
        primary: AppColors.gray900,
        secondary: AppColors.yellow600,
        surface: Colors.white,
        onSurface: AppColors.gray900,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.gray900,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        isDense: true,
        fillColor: AppColors.gray100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: const BorderSide(color: AppColors.gray200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: const BorderSide(color: AppColors.gray200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: const BorderSide(color: AppColors.gray500),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        hintStyle: TextStyle(fontSize: 14, color: AppColors.gray500),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.gray900,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.gray900,
          side: const BorderSide(color: AppColors.gray900, width: 0.5),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.gray700,
        thickness: 0.5,
      ),
    );
  }
}
