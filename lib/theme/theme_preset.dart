import 'package:flutter/material.dart';

/// Une palette complète pour Brevet Quest. Le `bgGradient` est l'arrière-plan,
/// mais aussi les couleurs des cartes, des pills, du `_SparkleTitle` et des
/// sparkles ✦ — pour qu'un changement de thème transforme vraiment l'UI.
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
    required this.cardBg,
    required this.cardBorder,
    required this.pillBg,
    required this.pillFg,
    required this.titleGradient,
    required this.sparkleColor,
    required this.textOnBg,
    this.unlockLevel = 0,
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
  final Color cardBg;
  final Color cardBorder;
  final Color pillBg;
  final Color pillFg;
  final List<Color> titleGradient;
  final Color sparkleColor;

  /// Couleur du texte principal sur le fond du thème (foncé pour les
  /// thèmes clairs, clair pour le thème dark).
  final Color textOnBg;

  /// Niveau XP requis pour débloquer le thème (0 = offert d'emblée).
  final int unlockLevel;

  final bool isDark;

  /// Violet Y2K — palette d'origine, offerte d'emblée.
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
    cardBg: Color(0xF2FFFFFF),
    cardBorder: Color(0xFFFFFFFF),
    pillBg: Color(0xD9FFFFFF),
    pillFg: Color(0xFF7B2D8F),
    titleGradient: <Color>[
      Color(0xFF4A1860),
      Color(0xFF7B2D8F),
      Color(0xFFE83E8C),
      Color(0xFF7B2D8F),
    ],
    sparkleColor: Color(0xFFFFFFFF),
    textOnBg: Color(0xFF2D1538),
    unlockLevel: 0,
  );

  /// Bleu cosmos — débloqué niveau 5.
  static const ThemePreset bleu = ThemePreset(
    id: 'bleu',
    name: 'Bleu Cosmos',
    emoji: '🔷',
    bgGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color(0xFFDDEBFF),
        Color(0xFFB6CFFF),
        Color(0xFF8FB1FF),
      ],
    ),
    bgGradientSoft: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[Color(0xFFDDEBFF), Color(0xFFF0F6FF)],
    ),
    statsGradient: <Color>[Color(0xFF8FB1FF), Color(0xFF2D5BA9)],
    accent: Color(0xFF2D5BA9),
    accentDeep: Color(0xFF14305F),
    cardBg: Color(0xF2FFFFFF),
    cardBorder: Color(0xFFFFFFFF),
    pillBg: Color(0xD9FFFFFF),
    pillFg: Color(0xFF2D5BA9),
    titleGradient: <Color>[
      Color(0xFF14305F),
      Color(0xFF2D5BA9),
      Color(0xFF5BB4F0),
      Color(0xFF2D5BA9),
    ],
    sparkleColor: Color(0xFFFFFFFF),
    textOnBg: Color(0xFF0F1F3A),
    unlockLevel: 5,
  );

  /// Rose néon — débloqué niveau 10.
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
    cardBg: Color(0xF2FFFFFF),
    cardBorder: Color(0xFFFFFFFF),
    pillBg: Color(0xD9FFFFFF),
    pillFg: Color(0xFFE83E8C),
    titleGradient: <Color>[
      Color(0xFF8C1F4F),
      Color(0xFFE83E8C),
      Color(0xFFFFB6D9),
      Color(0xFFE83E8C),
    ],
    sparkleColor: Color(0xFFFFFFFF),
    textOnBg: Color(0xFF3A0F22),
    unlockLevel: 10,
  );

  /// Mint — débloqué niveau 15.
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
    cardBg: Color(0xF2FFFFFF),
    cardBorder: Color(0xFFFFFFFF),
    pillBg: Color(0xD9FFFFFF),
    pillFg: Color(0xFF1F8A66),
    titleGradient: <Color>[
      Color(0xFF0F4A36),
      Color(0xFF1F8A66),
      Color(0xFF7BD9A0),
      Color(0xFF1F8A66),
    ],
    sparkleColor: Color(0xFFFFFFFF),
    textOnBg: Color(0xFF0E2A1F),
    unlockLevel: 15,
  );

  /// Dark mode — débloqué niveau 20.
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
    cardBg: Color(0xCC2D1538),
    cardBorder: Color(0xFFB8A8FF),
    pillBg: Color(0xCC1F0E2A),
    pillFg: Color(0xFFB8A8FF),
    titleGradient: <Color>[
      Color(0xFFB8A8FF),
      Color(0xFFFFFFFF),
      Color(0xFFFFD466),
      Color(0xFFFFFFFF),
    ],
    sparkleColor: Color(0xFFFFD466),
    textOnBg: Color(0xFFF6F0FF),
    unlockLevel: 20,
    isDark: true,
  );

  static const List<ThemePreset> all = <ThemePreset>[
    violet, bleu, rose, mint, dark,
  ];

  static ThemePreset byId(String id) {
    for (final ThemePreset p in all) {
      if (p.id == id) return p;
    }
    return violet;
  }

  bool isUnlocked(int userLevel) => userLevel >= unlockLevel;
}
