import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Dark Mode ──────────────────────────────────────────────────────
  static const Color darkBgPrimary = Color(0xFF080808);
  static const Color darkBgSecondary = Color(0xFF0D0D0F);
  static const Color darkBgTertiary = Color(0xFF121214);

  static const Color darkCardPrimary = Color(0xFF17171A);
  static const Color darkCardSecondary = Color(0xFF1D1D21);
  static const Color darkCardTertiary = Color(0xFF222228);

  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFDADADA);
  static const Color darkTextTertiary = Color(0xFF909090);

  // ── Light Mode ─────────────────────────────────────────────────────
  static const Color lightBgPrimary = Color(0xFFF6F8FB);
  static const Color lightCardPrimary = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE8EAF0);

  static const Color lightTextPrimary = Color(0xFF121212);
  static const Color lightTextSecondary = Color(0xFF4A4A4A);
  static const Color lightTextTertiary = Color(0xFF808080);

  // ── Gradients ──────────────────────────────────────────────────────
  static const Gradient cyanPurple = LinearGradient(
    colors: [Color(0xFF4EF2FF), Color(0xFFB05CFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient orangePink = LinearGradient(
    colors: [Color(0xFFFFC14D), Color(0xFFFF5EA8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient greenBlue = LinearGradient(
    colors: [Color(0xFF64FFC8), Color(0xFF5DAEFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Semantic Colors ────────────────────────────────────────────────
  static const Color success = Color(0xFF64FFC8);
  static const Color warning = Color(0xFFFFC14D);
  static const Color error = Color(0xFFFF5EA8);
  static const Color info = Color(0xFF4EF2FF);

  // ── Chart Colors ───────────────────────────────────────────────────
  static const List<Color> chartColors = [
    Color(0xFF4EF2FF),
    Color(0xFFB05CFF),
    Color(0xFFFFC14D),
    Color(0xFFFF5EA8),
    Color(0xFF64FFC8),
    Color(0xFF5DAEFF),
    Color(0xFFFF8A65),
    Color(0xFF7C4DFF),
  ];
}
