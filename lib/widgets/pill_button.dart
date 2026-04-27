import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/theme_service.dart';
import '../theme/theme_preset.dart';

/// Bouton pilule — couleur dérivée du ThemePreset courant pour qu'un
/// changement de thème impacte aussi les boutons.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
  });

  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ThemePreset theme = ThemeService.instance.preset;
    return Material(
      color: theme.pillBg,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: color ?? theme.pillFg,
            ),
          ),
        ),
      ),
    );
  }
}
