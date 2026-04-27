import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/subjects_data.dart';
import '../models/chapter.dart';
import '../models/subject.dart';
import '../models/user_progress.dart';
import '../services/preferences_service.dart';
import '../services/progress_service.dart';
import '../services/theme_service.dart';
import '../theme/app_theme.dart';
import '../theme/theme_preset.dart';
import '../widgets/pill_button.dart';

/// Écran Profil — récompenses, badges, XP par matière, sélecteurs niveau et thème.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[
          ProgressService.instance,
          ThemeService.instance,
          PreferencesService.instance,
        ]),
        builder: (BuildContext ctx, _) {
          final ThemePreset theme = ThemeService.instance.preset;
          final UserProgress p = ProgressService.instance.progress;
          return Container(
            decoration: BoxDecoration(gradient: theme.bgGradient),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        PillButton(
                          label: '←',
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        const Spacer(),
                        Text(
                          'profil',
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: theme.accent,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text('mes récompenses ✿', style: AppText.display),
                    const SizedBox(height: 4),
                    Text(
                      'niveau ${p.level} · ${p.xp} XP au total',
                      style: AppText.subtitle,
                    ),
                    const SizedBox(height: 18),
                    _SectionTitle('badges (${p.badges.length}/${ProgressService.badgeDefs.length})'),
                    const SizedBox(height: 10),
                    _BadgesGrid(progress: p),
                    const SizedBox(height: 18),
                    _SectionTitle('XP par matière'),
                    const SizedBox(height: 10),
                    _XpBySubject(xpBySubject: p.xpBySubject),
                    const SizedBox(height: 18),
                    _SectionTitle('niveau de programme'),
                    const SizedBox(height: 10),
                    const _NiveauSelector(),
                    const SizedBox(height: 18),
                    _SectionTitle('thème'),
                    const SizedBox(height: 10),
                    const _ThemeSelector(),
                    const SizedBox(height: 18),
                    _SectionTitle('zone de danger'),
                    const SizedBox(height: 10),
                    _DangerZone(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.quicksand(
        fontSize: 13,
        fontWeight: FontWeight.w900,
        color: AppColors.violet,
        letterSpacing: 1.0,
      ),
    );
  }
}

class _BadgesGrid extends StatelessWidget {
  const _BadgesGrid({required this.progress});

  final UserProgress progress;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: <Widget>[
        for (final BadgeDef b in ProgressService.badgeDefs)
          _BadgeChip(
            key: ValueKey<String>('badge-${b.id}'),
            badge: b,
            unlocked: progress.badges.contains(b.id),
          ),
      ],
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({super.key, required this.badge, required this.unlocked});

  final BadgeDef badge;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: unlocked
            ? Colors.white.withValues(alpha: 0.95)
            : Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: unlocked
              ? AppColors.violet.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      child: Column(
        children: <Widget>[
          Opacity(
            opacity: unlocked ? 1 : 0.4,
            child: Text(
              badge.emoji,
              style: const TextStyle(fontSize: 32),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            badge.label,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: unlocked
                  ? AppColors.plumDark
                  : AppColors.plumDark.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}

class _XpBySubject extends StatelessWidget {
  const _XpBySubject({required this.xpBySubject});

  final Map<String, int> xpBySubject;

  @override
  Widget build(BuildContext context) {
    final List<Subject> subjects = SubjectsData.all;
    final int maxXp = xpBySubject.values.fold<int>(0,
        (int max, int v) => v > max ? v : max);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.85),
          width: 1.5,
        ),
      ),
      child: Column(
        children: <Widget>[
          for (int i = 0; i < subjects.length; i++) ...<Widget>[
            _SubjectXpRow(
              key: ValueKey<String>('xp-${subjects[i].id}'),
              subject: subjects[i],
              xp: xpBySubject[subjects[i].id] ?? 0,
              maxXp: maxXp == 0 ? 1 : maxXp,
            ),
            if (i < subjects.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _SubjectXpRow extends StatelessWidget {
  const _SubjectXpRow({
    super.key,
    required this.subject,
    required this.xp,
    required this.maxXp,
  });

  final Subject subject;
  final int xp;
  final int maxXp;

  @override
  Widget build(BuildContext context) {
    final double pct = (xp / maxXp).clamp(0.0, 1.0);
    return Row(
      children: <Widget>[
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.lavender100,
            shape: BoxShape.circle,
          ),
          child: Text(subject.emoji, style: const TextStyle(fontSize: 16)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      subject.shortName,
                      style: GoogleFonts.quicksand(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.plumDark,
                      ),
                    ),
                  ),
                  Text(
                    '$xp XP',
                    style: GoogleFonts.quicksand(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AppColors.violet,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 5,
                  backgroundColor:
                      AppColors.violet.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(subject.color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NiveauSelector extends StatelessWidget {
  const _NiveauSelector();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: PreferencesService.instance,
      builder: (BuildContext ctx, _) {
        final Niveau current = PreferencesService.instance.niveau;
        return Row(
          children: <Widget>[
            for (final Niveau n in Niveau.values)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _SelectorChip(
                    key: ValueKey<String>('niveau-${n.id}'),
                    label: n.label,
                    selected: current == n,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      PreferencesService.instance.setNiveau(n);
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context) {
    final ThemePreset current = ThemeService.instance.preset;
    final int level = ProgressService.instance.progress.level;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.start,
      children: <Widget>[
        for (final ThemePreset p in ThemePreset.all)
          _ThemeChip(
            key: ValueKey<String>('theme-${p.id}'),
            preset: p,
            selected: current.id == p.id,
            unlocked: p.isUnlocked(level),
            onTap: () {
              HapticFeedback.selectionClick();
              ThemeService.instance.setPreset(p);
            },
          ),
      ],
    );
  }
}

class _SelectorChip extends StatelessWidget {
  const _SelectorChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? AppColors.violet
                : Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.violet : AppColors.lavender200,
              width: 2,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: selected ? Colors.white : AppColors.plumDark,
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  const _ThemeChip({
    super.key,
    required this.preset,
    required this.selected,
    required this.unlocked,
    required this.onTap,
  });

  final ThemePreset preset;
  final bool selected;
  final bool unlocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        preset.isDark ? Colors.white : AppColors.plumDark;
    return Opacity(
      opacity: unlocked ? 1.0 : 0.55,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                width: 104,
                height: 104,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: BoxDecoration(
                  gradient: preset.bgGradient,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: selected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.55),
                    width: selected ? 3 : 1.5,
                  ),
                  boxShadow: selected
                      ? <BoxShadow>[
                          BoxShadow(
                            color: preset.accent.withValues(alpha: 0.45),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(preset.emoji, style: const TextStyle(fontSize: 26)),
                    const SizedBox(height: 4),
                    Text(
                      preset.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    SizedBox(
                      height: 14,
                      child: selected
                          ? const Text('✓',
                              style: TextStyle(fontSize: 13))
                          : (unlocked
                              ? const SizedBox.shrink()
                              : Text(
                                  'N${preset.unlockLevel}',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: textColor,
                                  ),
                                )),
                    ),
                  ],
                ),
              ),
              if (!unlocked)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock, size: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DangerZone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _confirmReset(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.danger, width: 1.5),
          ),
          child: Row(
            children: <Widget>[
              const Text('⚠️', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                'Réinitialiser ma progression',
                style: GoogleFonts.quicksand(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: AppColors.danger,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(
          'Tout effacer ?',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w900,
            color: AppColors.plumDark,
          ),
        ),
        content: Text(
          'XP, niveau, badges, streak et quêtes seront remis à zéro. '
          'Le thème reste celui sélectionné.',
          style: GoogleFonts.quicksand(color: AppColors.plumDark),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Effacer',
              style: GoogleFonts.quicksand(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (ok ?? false) {
      await ProgressService.instance.reset();
    }
  }
}
