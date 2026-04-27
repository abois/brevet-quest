import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/audio_service.dart';
import '../theme/bq_colors.dart';

/// Petit bouton paire : musique 🔊/🔇 + SFX 🔔/🔕.
class AudioToggle extends StatelessWidget {
  const AudioToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AudioService.instance,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _ToggleChip(
              icon: AudioService.instance.musicMuted ? '🔇' : '🎵',
              onTap: () {
                HapticFeedback.selectionClick();
                AudioService.instance.toggleMusic();
              },
            ),
            const SizedBox(width: 6),
            _ToggleChip(
              icon: AudioService.instance.sfxMuted ? '🔕' : '🔔',
              onTap: () {
                HapticFeedback.selectionClick();
                AudioService.instance.toggleSfx();
              },
            ),
          ],
        );
      },
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({required this.icon, required this.onTap});

  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Bq.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.85),
              width: 1.5,
            ),
          ),
          child: Text(
            icon,
            style: GoogleFonts.quicksand(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
