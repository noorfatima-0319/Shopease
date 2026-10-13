import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Neutral background with one confident accent color.
// No gradients, no pill-shaped buttons, no decorative color noise.
class AppColors {
  static const Color primary = Color(0xFFD9502B);   // warm, clear accent
  static const Color primaryDark = Color(0xFFB8401F);
  static const Color ink = Color(0xFF1A1A1A);
  static const Color inkSoft = Color(0xFF6B6B6B);
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE6E6E6);
  static const Color success = Color(0xFF2E7D32);
  static const Color danger = Color(0xFFC0392B);
  static const Color star = Color(0xFFE2A000);
}

class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness b) {
    final isDark = b == Brightness.dark;

    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: b,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      surface: isDark ? const Color(0xFF1C1C1C) : AppColors.surface,
      onSurface: isDark ? const Color(0xFFEDEDED) : AppColors.ink,
      error: AppColors.danger,
    );

    final base = ThemeData(useMaterial3: true, brightness: b, colorScheme: scheme);

    return base.copyWith(
      scaffoldBackgroundColor: isDark ? const Color(0xFF121212) : AppColors.background,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF121212) : AppColors.background,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: isDark ? const Color(0xFF2A2A2A) : AppColors.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(color: isDark ? const Color(0xFF3A3A3A) : AppColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: isDark ? const Color(0xFF2A2A2A) : AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: isDark ? const Color(0xFF2A2A2A) : AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : AppColors.surface,
        side: BorderSide(color: isDark ? const Color(0xFF2A2A2A) : AppColors.border),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}
