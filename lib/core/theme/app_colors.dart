import 'package:flutter/material.dart';

/// Semantic color tokens as defined in DESIGN.md.
class AppColors {
  AppColors._();

  // Primary & Background Brand Tokens
  static const Color primary = Color(0xFF1E293B); // Slate Navy
  static const Color primaryHover = Color(0xFF0F172A);
  static const Color primaryContainer = Color(0xFFF1F5F9);
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color background = Color(0xFFF8FAFC); // Very light slate
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Typography Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF94A3B8);

  // Border & Divider Colors
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderSubtle = Color(0xFFF1F5F9);

  // Status & Feedback Colors
  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0xFFD1FAE5);
  static const Color successText = Color(0xFF065F46);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color warningText = Color(0xFF92400E);

  static const Color veryLate = Color(0xFFF97316);
  static const Color veryLateBg = Color(0xFFFFEDD5);
  static const Color veryLateText = Color(0xFF9A3412);

  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEE2E2);
  static const Color errorText = Color(0xFF991B1B);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoBg = Color(0xFFDBEAFE);
  static const Color infoText = Color(0xFF1E40AF);

  static const Color neutral = Color(0xFF64748B);
  static const Color neutralBg = Color(0xFFF1F5F9);
  static const Color neutralText = Color(0xFF334155);
}
