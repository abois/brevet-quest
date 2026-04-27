import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/daily_quest.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import '../services/theme_service.dart';
import '../theme/app_theme.dart';
import '../theme/bq_colors.dart';
import '../widgets/pill_button.dart';

/// Écran de fin de partie — score, XP, badges débloqués, level-up.
class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.title,
    required this.correct,
    required this.answered,
    required this.record,
    required this.onReplay,
  });

  final String title;
  final int correct;
  final int answered;
  final SessionRecordResult record;
  final VoidCallback onReplay;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _xpScale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _xpScale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
    HapticFeedback.mediumImpact();
    if (widget.record.leveledUp) {
      AudioService.instance.play(Sfx.levelUp);
    } else if (widget.record.newBadges.isNotEmpty ||
        widget.record.newlyCompletedQuests.isNotEmpty) {
      AudioService.instance.play(Sfx.badge);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double accuracy =
        widget.answered == 0 ? 0 : widget.correct / widget.answered;
    final String mood = switch (accuracy) {
      >= 0.9 => '🌟 sans faute (ou presque) !',
      >= 0.7 => '✨ bien joué !',
      >= 0.5 => '🌷 pas mal',
      _ => '🌱 on continue à bosser',
    };

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeService.instance.preset.bgGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    PillButton(
                      label: '← accueil',
                      onTap: () =>
                          Navigator.of(context).popUntil((r) => r.isFirst),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(widget.title,
                    style: AppText.title.copyWith(color: Bq.textOnBg)),
                const SizedBox(height: 6),
                Text(mood,
                    style: AppText.subtitle.copyWith(color: Bq.accent)),
                const SizedBox(height: 24),
                _ScoreRing(
                  correct: widget.correct,
                  total: widget.answered,
                ),
                const SizedBox(height: 24),
                ScaleTransition(
                  scale: _xpScale,
                  child: _XpBadge(amount: widget.record.xpGained),
                ),
                const SizedBox(height: 16),
                if (widget.record.leveledUp)
                  _LevelUpBanner(level: widget.record.newLevel),
                if (widget.record.newlyCompletedQuests.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 14),
                  Text('quêtes complétées ✿',
                      style: AppText.subtitle.copyWith(color: Bq.accent)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      for (final DailyQuest q
                          in widget.record.newlyCompletedQuests)
                        _QuestPill(
                          key: ValueKey<String>('quest-${q.id}'),
                          quest: q,
                        ),
                    ],
                  ),
                ],
                if (widget.record.newBadges.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 14),
                  Text(
                    'badges débloqués ✿',
                    style: AppText.subtitle.copyWith(color: Bq.accent),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      for (final BadgeDef b in widget.record.newBadges)
                        _BadgePill(
                          key: ValueKey<String>('badge-${b.id}'),
                          badge: b,
                        ),
                    ],
                  ),
                ],
                const Spacer(),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _ActionButton(
                        label: '↻ rejouer',
                        primary: false,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          widget.onReplay();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ActionButton(
                        label: 'accueil →',
                        primary: true,
                        onTap: () => Navigator.of(context)
                            .popUntil((r) => r.isFirst),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({required this.correct, required this.total});

  final int correct;
  final int total;

  @override
  Widget build(BuildContext context) {
    final double pct = total == 0 ? 0 : correct / total;
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            width: 180,
            height: 180,
            child: CircularProgressIndicator(
              value: pct,
              strokeWidth: 14,
              backgroundColor: Colors.white.withValues(alpha: 0.4),
              valueColor: AlwaysStoppedAnimation<Color>(Bq.accent),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '$correct / $total',
                style: GoogleFonts.quicksand(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Bq.textOnBg,
                ),
              ),
              Text(
                '${(pct * 100).round()}%',
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Bq.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _XpBadge extends StatelessWidget {
  const _XpBadge({required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFFFFD466), Color(0xFFE83E8C)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.danger.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('✦', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 6),
          Text(
            '+$amount XP',
            style: GoogleFonts.quicksand(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelUpBanner extends StatelessWidget {
  const _LevelUpBanner({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Bq.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Bq.accent, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('🎉', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Text(
            'Niveau $level débloqué !',
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Bq.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestPill extends StatelessWidget {
  const _QuestPill({super.key, required this.quest});

  final DailyQuest quest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFFFFD466), Color(0xFFFFC7E0)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(quest.emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Text(
            quest.label,
            style: GoogleFonts.quicksand(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.plumDark,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+${quest.xpReward}',
              style: GoogleFonts.quicksand(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: AppColors.danger,
              ),
            ),
          ),
          // (Quest pill : couleurs fixes — gradient or/rose intentionnel)
        ],
      ),
    );
  }
}

class _BadgePill extends StatelessWidget {
  const _BadgePill({super.key, required this.badge});

  final BadgeDef badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Bq.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: Bq.accent.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(badge.emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Text(
            badge.label,
            style: GoogleFonts.quicksand(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Bq.textOnBg,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.primary,
    required this.onTap,
  });

  final String label;
  final bool primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: primary ? Bq.accent : Bq.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.85),
              width: 2,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.quicksand(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: primary ? Colors.white : Bq.textOnBg,
            ),
          ),
        ),
      ),
    );
  }
}
