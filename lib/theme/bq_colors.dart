import 'package:flutter/material.dart';

import '../services/theme_service.dart';

/// Helpers couleurs **dynamiques** liés au ThemePreset courant.
/// À utiliser à la place d'AppColors hardcodé quand on veut que la
/// couleur change avec le thème (texte, accent, fond de carte…).
///
/// Ne sont pas const — les widgets concernés doivent retirer leur `const`.
class Bq {
  const Bq._();

  static Color get accent => ThemeService.instance.preset.accent;
  static Color get accentDeep => ThemeService.instance.preset.accentDeep;
  static Color get textOnBg => ThemeService.instance.preset.textOnBg;
  static Color get cardBg => ThemeService.instance.preset.cardBg;
  static Color get cardBorder => ThemeService.instance.preset.cardBorder;
  static Color get pillBg => ThemeService.instance.preset.pillBg;
  static Color get pillFg => ThemeService.instance.preset.pillFg;
  static Color get sparkle => ThemeService.instance.preset.sparkleColor;
  static bool get isDark => ThemeService.instance.preset.isDark;
}
