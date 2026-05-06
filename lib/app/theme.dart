import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ARIELA design tokens.
///
/// Single source of truth for colors, typography, and spacing.
/// Matches the locked brand guidelines in docs/brand-guidelines.md.
class ArielaTheme {
  ArielaTheme._();

  // ========== COLORS ==========

  // Primary — Lavender
  static const lavender50 = Color(0xFFF3F1FB);
  static const lavender200 = Color(0xFFD9D3F5);
  static const lavender400 = Color(0xFF9B8FE5);
  static const lavender600 = Color(0xFF6B5DD3); // Primary brand color
  static const lavender900 = Color(0xFF2D1B69);

  // Accent — Soft pink
  static const pink50 = Color(0xFFFDF2F6);
  static const pink200 = Color(0xFFF9D4E1);
  static const pink400 = Color(0xFFF2A6BF);
  static const pink600 = Color(0xFFE5739A); // Accent
  static const pink900 = Color(0xFF6B1F3F);

  // Neutrals — Warm grays
  static const surfaceBg = Color(0xFFFAFAF9);
  static const surfaceCard = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF4F2EE);
  static const textMuted = Color(0xFFA8A29E);
  static const textBody = Color(0xFF57534E);
  static const textHeading = Color(0xFF1C1B1A);

  // Semantic
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFEAB308);
  static const error = Color(0xFFDC2626);

  // ========== TYPOGRAPHY ==========

  static TextTheme get textTheme => TextTheme(
        displayLarge: GoogleFonts.dmSans(
          fontSize: 32,
          fontWeight: FontWeight.w500,
          height: 1.2,
          letterSpacing: -0.32,
          color: textHeading,
        ),
        headlineLarge: GoogleFonts.dmSans(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          height: 1.3,
          color: textHeading,
        ),
        headlineMedium: GoogleFonts.dmSans(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          height: 1.4,
          color: textHeading,
        ),
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.6,
          color: textBody,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: textBody,
        ),
        bodySmall: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.4,
          color: textMuted,
        ),
      );

  // ========== THEME ==========

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: surfaceBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: lavender600,
          brightness: Brightness.light,
          primary: lavender600,
          secondary: pink600,
          surface: surfaceCard,
          error: error,
        ),
        textTheme: textTheme,
      );
}