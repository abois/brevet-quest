import 'package:flutter/material.dart';

/// Une palette de fond + accents pour Brevet Quest.
/// Garde une base cohérente (lavandes, violet d'accent) et fait varier
/// les gradients de fond + la carte de stats pour un effet visuel net.
class ThemePreset {
  const ThemePreset({
    required this.id,
    required this.name,
    required this.emoji,
    required this.bgGradient,
    required this.bgGradientSoft,
    required this.statsGradient,
    required this.accent,
    required this.accentDeep,
    this.isDark = false,
  });

  final String id;
  final String name;
  final String emoji;
  final LinearGradient bgGradient;
  final LinearGradient bgGradientSoft;
  final List<Color> statsGradient;
  final Color accent;
  final Color accentDeep;
  final bool isDark;

  /// Violet Y2K — palette d'origine.
  static const ThemePreset violet = ThemePreset(
    id: 'violet',
    name: 'Violet Y2K',
    emoji: '💜',
    bgGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color(0xFFE9D5FF),
        Color(0xFFD9C2FF),
        Color(0xFFB8A8FF),
      ],
    ),
    bgGradientSoft: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[Color(0xFFE9D5FF), Color(0xFFF6F0FF)],
    ),
    statsGradient: <Color>[Color(0xFFB8A8FF), Color(0xFF9B7FE8)],
    accent: Color(0xFF7B2D8F),
    accentDeep: Color(0xFF4A1860),
  );

  /// Rose néon — pour le côté pop & y2k.
  static const ThemePreset rose = ThemePreset(
    id: 'rose',
    name: 'Rose Néon',
    emoji: '🌸',
    bgGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color(0xFFFFE4F0),
        Color(0xFFFFC7E0),
        Color(0xFFFF9CC9),
      ],
    ),
    bgGradientSoft: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[Color(0xFFFFE4F0), Color(0xFFFFF5FA)],
    ),
    statsGradient: <Color>[Color(0xFFFF9CC9), Color(0xFFE83E8C)],
    accent: Color(0xFFE83E8C),
    accentDeep: Color(0xFF8C1F4F),
  );

  /// Mint — fraîcheur & étude détendue.
  static const ThemePreset mint = ThemePreset(
    id: 'mint',
    name: 'Mint',
    emoji: '🍃',
    bgGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color(0xFFD9F8E9),
        Color(0xFFB6F0D7),
        Color(0xFF8AD9B8),
      ],
    ),
    bgGradientSoft: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[Color(0xFFD9F8E9), Color(0xFFF0FFF8)],
    ),
    statsGradient: <Color>[Color(0xFF8AD9B8), Color(0xFF4A9B7E)],
    accent: Color(0xFF1F8A66),
    accentDeep: Color(0xFF0F4A36),
  );

  /// Dark mode — concentration tardive.
  static const ThemePreset dark = ThemePreset(
    id: 'dark',
    name: 'Dark',
    emoji: '🌙',
    bgGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color(0xFF2D1538),
        Color(0xFF1F0E2A),
        Color(0xFF0F0518),
      ],
    ),
    bgGradientSoft: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[Color(0xFF1F0E2A), Color(0xFF0F0518)],
    ),
    statsGradient: <Color>[Color(0xFF7B2D8F), Color(0xFFB8A8FF)],
    accent: Color(0xFFB8A8FF),
    accentDeep: Color(0xFF7B2D8F),
    isDark: true,
  );

  static const List<ThemePreset> all = <ThemePreset>[violet, rose, mint, dark];

  static ThemePreset byId(String id) {
    for (final ThemePreset p in all) {
      if (p.id == id) return p;
    }
    return violet;
  }
}
