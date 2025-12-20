import 'package:flutter/material.dart';

/// Cashio App Colors
class AppColors {
  // Brand
  static const Color primary = Colors.blue; // Indigo Blue
  static const Color secondary = Color(0xFF22C55E); // Soft Green

  // Backgrounds
  static const Color background = Color(0xFFF5F6FA);

  // Light Gray
  static const Color surface = Color(0xFFFFFFFF); // Cards

  // Text
  static const Color textPrimary = Color(0xFF0F172A); // Dark Slate
  static const Color textSecondary = Color(0xFF64748B); // Muted Gray
  static const Color textWhite = Color.fromARGB(
    255,
    255,
    255,
    255,
  ); // Muted Gray

  // UI Elements
  static const Color button = Color(0xFF2563EB);
  static const Color border = Color(0xFFE2E8F0);

  // Status
  static const Color error = Color(0xFFEF4444); // Red
  static const Color success = Color(0xFF22C55E); // Green
  static const Color warning = Color(0xFFF59E0B); // Amber

  // Finance specific
  static const Color income = Color(0xFF16A34A);
  static const Color expense = Color(0xFFDC2626);
}
