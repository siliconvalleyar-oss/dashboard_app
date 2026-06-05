import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // ── Theme ─────────────────────────────────────────────────────────
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  bool get isDark => theme.brightness == Brightness.dark;

  // ── Media Query ────────────────────────────────────────────────────
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get width => screenSize.width;
  double get height => screenSize.height;

  // ── Breakpoints ────────────────────────────────────────────────────
  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 1024;
  bool get isDesktop => width >= 1024;
  bool get isUltraWide => width >= 1600;

  // ── Grid Columns ───────────────────────────────────────────────────
  int get gridColumns {
    if (isUltraWide) return 6;
    if (isDesktop) return 4;
    if (isTablet) return 2;
    return 1;
  }

  // ── Padding ────────────────────────────────────────────────────────
  EdgeInsets get screenPadding => EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 12 : 20,
      );

  double get cardSpacing => isMobile ? 12 : 16;

  // ── Responsive Value ───────────────────────────────────────────────
  T responsive<T>({
    required T mobile,
    T? tablet,
    required T desktop,
    T? ultraWide,
  }) {
    if (isUltraWide && ultraWide != null) return ultraWide;
    if (isDesktop) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}
