import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTypography {
  // Define reusable font styles
  static TextStyle poppins({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    FontStyle? fontStyle,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
    );
  }

  static TextStyle inter({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    FontStyle? fontStyle,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
    );
  }

  /// Returns a text theme adjusted for light or dark mode
  static TextTheme textTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final Color primaryText = isDark ? Colors.white : AppColors.textPrimary;
    final Color secondaryText = isDark
        ? Colors.white70
        : AppColors.textSecondary;

    return TextTheme(
      // Large display text (e.g. AppBar titles, section headers)
      displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),

      // Medium headline (subsections, cards, etc.)
      headlineMedium: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: primaryText,
      ),

      // Titles, smaller headers
      titleMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: primaryText,
      ),

      // Standard readable text
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryText,
      ),

      // Secondary / hint text
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryText,
      ),

      // Button text or chip labels
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.black : Colors.white,
      ),
    );
  }
}
