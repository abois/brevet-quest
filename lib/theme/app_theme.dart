import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palette Y2K violet/lavande — `Indices` (mode ado 14+).
class AppColors {
  const AppColors._();

  // Lavandes (couleur primaire validée)
  static const lavender50 = Color(0xFFF6F0FF);
  static const lavender100 = Color(0xFFE9D5FF);
  static const lavender200 = Color(0xFFD9C2FF);
  static const lavender300 = Color(0xFFB8A8FF);
  static const lavender400 = Color(0xFF9B7FE8);

  // Accents profonds
  static const violet = Color(0xFF7B2D8F);
  static const violetDeep = Color(0xFF4A1860);
  static const plumDark = Color(0xFF2D1538);

  // Neutres tamisés
  static const cream = Color(0xFFFEF9FB);
  static const glass = Color(0xE6FFFFFF);
  static const glassSoft = Color(0xB3FFFFFF);

  // Status
  static const success = Color(0xFFC1F4DD);
  static const successDark = Color(0xFF1F5C42);
  static const warning = Color(0xFFFFD466);
  static const danger = Color(0xFFE83E8C);

  // Gradient principal de fond
  static const bgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE9D5FF), // lavender
      Color(0xFFD9C2FF),
      Color(0xFFB8A8FF),
    ],
  );

  static const bgGradientSoft = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE9D5FF), Color(0xFFF6F0FF)],
  );
}

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.violet,
        brightness: Brightness.light,
        primary: AppColors.violet,
        secondary: AppColors.lavender300,
        surface: AppColors.cream,
      ),
      scaffoldBackgroundColor: AppColors.cream,
    );

    return base.copyWith(
      textTheme: GoogleFonts.quicksandTextTheme(base.textTheme).apply(
        bodyColor: AppColors.plumDark,
        displayColor: AppColors.plumDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.violet,
          foregroundColor: Colors.white,
          padding:
              const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.quicksand(
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

/// Helpers de typographie cohérente pour `Indices`.
class AppText {
  const AppText._();

  static TextStyle display = GoogleFonts.quicksand(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: AppColors.plumDark,
    letterSpacing: 0.5,
  );

  static TextStyle title = GoogleFonts.quicksand(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    color: AppColors.plumDark,
  );

  static TextStyle subtitle = GoogleFonts.quicksand(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.violet,
    letterSpacing: 0.3,
  );

  static TextStyle body = GoogleFonts.quicksand(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.plumDark,
    height: 1.4,
  );

  static TextStyle pill = GoogleFonts.quicksand(
    fontSize: 11,
    fontWeight: FontWeight.w900,
    letterSpacing: 0.5,
  );

  static TextStyle tag = GoogleFonts.quicksand(
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );
}
