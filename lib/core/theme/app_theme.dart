import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBgPrimary,
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFFB05CFF),
        secondary: const Color(0xFF4EF2FF),
        surface: AppColors.darkCardPrimary,
        error: AppColors.error,
      ),
    );
    return base.copyWith(
      textTheme: _textTheme(base.textTheme),
      cardTheme: _cardTheme(),
      appBarTheme: _appBarTheme(true),
      drawerTheme: _drawerTheme(true),
      chipTheme: _chipTheme(true),
      dividerTheme: _dividerTheme(true),
      inputDecorationTheme: _inputDecorationTheme(true),
      navigationBarTheme: _navBarTheme(true),
    );
  }

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBgPrimary,
      colorScheme: ColorScheme.light(
        primary: const Color(0xFFB05CFF),
        secondary: const Color(0xFF4EF2FF),
        surface: AppColors.lightCardPrimary,
        error: AppColors.error,
      ),
    );
    return base.copyWith(
      textTheme: _textTheme(base.textTheme),
      cardTheme: _cardThemeLight(),
      appBarTheme: _appBarTheme(false),
      drawerTheme: _drawerTheme(false),
      chipTheme: _chipTheme(false),
      dividerTheme: _dividerTheme(false),
      inputDecorationTheme: _inputDecorationTheme(false),
      navigationBarTheme: _navBarTheme(false),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    return GoogleFonts.interTextTheme(base).copyWith(
      displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5),
      displayMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: -0.3),
      headlineLarge: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600),
      headlineMedium: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500),
      titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400),
      bodyMedium: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400),
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
    );
  }

  static CardThemeData _cardTheme() {
    return CardThemeData(
      color: AppColors.darkCardPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide.none),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
    );
  }

  static CardThemeData _cardThemeLight() {
    return CardThemeData(
      color: AppColors.lightCardPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: AppColors.lightBorder, width: 1)),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
    );
  }

  static AppBarTheme _appBarTheme(bool isDark) {
    return AppBarTheme(
      backgroundColor: Colors.transparent, elevation: 0, centerTitle: false,
      titleTextStyle: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      iconTheme: IconThemeData(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
    );
  }

  static DrawerThemeData _drawerTheme(bool isDark) {
    return DrawerThemeData(backgroundColor: isDark ? AppColors.darkBgSecondary : AppColors.lightCardPrimary);
  }

  static ChipThemeData _chipTheme(bool isDark) {
    return ChipThemeData(
      backgroundColor: isDark ? AppColors.darkCardSecondary : const Color(0xFFF0F2F5),
      labelStyle: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, fontSize: 12),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  static DividerThemeData _dividerTheme(bool isDark) {
    return DividerThemeData(color: isDark ? const Color(0xFF2A2A30) : AppColors.lightBorder, thickness: 1, space: 1);
  }

  static InputDecorationTheme _inputDecorationTheme(bool isDark) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? AppColors.darkCardSecondary : const Color(0xFFF0F2F5),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? const Color(0xFFB05CFF) : const Color(0xFF7C4DFF), width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: TextStyle(color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary, fontSize: 14),
    );
  }

  static NavigationBarThemeData _navBarTheme(bool isDark) {
    return NavigationBarThemeData(
      backgroundColor: isDark ? AppColors.darkBgSecondary : AppColors.lightCardPrimary,
      indicatorColor: isDark ? const Color(0xFF2A2A35) : const Color(0xFFF0F0FF),
      labelTextStyle: WidgetStatePropertyAll(GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }

  static BoxDecoration glassCard(bool isDark) {
    return BoxDecoration(
      color: isDark ? AppColors.darkCardPrimary.withOpacity(0.8) : AppColors.lightCardPrimary.withOpacity(0.9),
      borderRadius: BorderRadius.circular(16),
      border: isDark ? Border.all(color: Colors.white.withOpacity(0.05)) : Border.all(color: AppColors.lightBorder),
      boxShadow: [BoxShadow(color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4))],
    );
  }

  static BoxDecoration gradientCard(Gradient gradient) {
    return BoxDecoration(
      gradient: gradient, borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 16, offset: const Offset(0, 4))],
    );
  }
}
