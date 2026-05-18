import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProMediaTheme {
  static const Color surface = Color(0xFF111317);
  static const Color onSurface = Color(0xFFE2E2E8);
  static const Color primary = Color(0xFFFFB4AA);
  static const Color secondary = Color(0xFFE9C349);
  static const Color surfaceContainer = Color(0xFF1E2024);
  static const Color outline = Color(0xFFAD8883);
  static const Color error = Color(0xFFFFB4AB);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: surface,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        onSurface: onSurface,
        primary: primary,
        secondary: secondary,
        error: error,
        outline: outline,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02 * 48,
          color: onSurface,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: onSurface,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: onSurface.withOpacity(0.7),
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.05 * 12,
          color: onSurface,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primary),
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: onSurface,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E2024),
        selectedItemColor: secondary,
        unselectedItemColor: Color(0xFFE7BDB7),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: onSurface,
          foregroundColor: surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 0.05 * 12,
          ),
        ),
      ),
    );
  }
}
