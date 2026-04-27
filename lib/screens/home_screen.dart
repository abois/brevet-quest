import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/daily_quest.dart';
import '../models/question.dart';
import '../models/user_progress.dart';
import '../models/chapter.dart';
import '../services/preferences_service.dart';
import '../services/progress_service.dart';
import '../services/theme_service.dart';
import '../theme/app_theme.dart';
import '../theme/bq_colors.dart';
import '../theme/theme_scope.dart';
import '../theme/theme_preset.dart';
import '../widgets/audio_toggle.dart';
import 'game_calc_screen.dart';
import 'game_dictee_screen.dart';
import 'game_brevet_screen.dart';
import 'game_intrus_screen.dart';
import 'game_memory_screen.dart';
import 'game_pendu_screen.dart';
import 'game_problemes_screen.dart';
import 'game_qcm_screen.dart';
import 'game_sort_screen.dart';
import 'game_survival_screen.dart';
import 'game_timeline_screen.dart';
import 'game_truefalse_screen.dart';
import 'profile_screen.dart';
import 'subject_picker_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeScope.of(context);
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[
          ProgressService.instance,
          ThemeService.instance,
          PreferencesService.instance,
        ]),
        builder: (context, _) {
          final ThemePreset theme = ThemeService.instance.preset;
          return Container(
            decoration: BoxDecoration(gradient: theme.bgGradient),
            child: SafeArea(
              child: Builder(
                builder: (context) {
                  final UserProgress p = ProgressService.instance.progress;
                  final List<DailyQuest> quests =
                      ProgressService.instance.todaysQuests;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Expanded(
                          child: _SparkleTitle('✦ Brevet Quest ✦'),
                        ),
                        const SizedBox(width: 8),
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: _ProfileChip(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Text(
                          'révise en jouant ♡  ',
                          style: GoogleFonts.quicksand(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Bq.accentDeep
                                .withValues(alpha: 0.85),
                            letterSpacing: 1.5,
                          ),
                        ),
                        const _NiveauPill(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _StatsCard(progress: p),
                    const SizedBox(height: 16),
                    _QuestsCard(quests: quests, progress: p),
                    const SizedBox(height: 16),
                    Text(
                      'mini-jeux ✿',
                      style: AppText.subtitle.copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    const _GameCard(
                      emoji: '⚡',
                      title: 'QCM Flash',
                      subtitle: '10 questions · chrono 30 s',
                      tags: <String>['#mix', '#vitesse'],
                      featured: true,
                      kind: _GameKind.qcm,
                      rotation: -0.018,
                    ),
                    const SizedBox(height: 10),
                    const _GameCard(
                      emoji: '👉',
                      title: 'Vrai / Faux',
                      subtitle: 'swipe · 60 s',
                      tags: <String>['#swipe', '#fun'],
                      kind: _GameKind.trueFalse,
                      rotation: 0.014,
                    ),
                    const SizedBox(height: 10),
                    const _GameCard(
                      emoji: '🧮',
                      title: 'Calcul Mental',
                      subtitle: 'tables, %, fractions · 60 s',
                      tags: <String>['#maths', '#chrono'],
                      kind: _GameKind.calc,
                      rotation: -0.01,
                    ),
                    const SizedBox(height: 10),
                    const _GameCard(
                      emoji: '🎴',
                      title: 'Memory',
                      subtitle: '8 paires à retrouver',
                      tags: <String>['#concentration', '#paires'],
                      kind: _GameKind.memory,
                      rotation: 0.012,
                    ),
                    const SizedBox(height: 10),
                    const _GameCard(
                      emoji: '💀',
                      title: 'Élimination',
                      subtitle: '3 vies · endless',
                      tags: <String>['#hardcore', '#streak'],
                      kind: _GameKind.survival,
                      rotation: -0.014,
                    ),
                    const SizedBox(height: 10),
                    const _GameCard(
                      emoji: '⏰',
                      title: 'Frise chronologique',
                      subtitle: 'remets dans l\'ordre',
                      tags: <String>['#histoire', '#dragdrop'],
                      kind: _GameKind.timeline,
                      rotation: 0.012,
                    ),
                    const SizedBox(height: 10),
                    const _GameCard(
                      emoji: '🎧',
                      title: 'Dictée',
                      subtitle: '6 phrases · 2 écoutes',
                      tags: <String>['#audio', '#orthographe'],
                      kind: _GameKind.dictee,
                      rotation: -0.011,
                    ),
                    const SizedBox(height: 10),
                    const _GameCard(
                      emoji: '🗂️',
                      title: 'Tri par catégories',
                      subtitle: 'glisse 9 items en 3 colonnes',
                      tags: <String>['#dragdrop', '#logique'],
                      kind: _GameKind.sort,
                      rotation: 0.013,
                    ),
                    const SizedBox(height: 10),
                    const _GameCard(
                      emoji: '🎭',
                      title: 'L\'intrus',
                      subtitle: 'trouve celui qui ne va pas',
                      tags: <String>['#vif', '#culture'],
                      kind: _GameKind.intrus,
                      rotation: -0.012,
                    ),
                    const SizedBox(height: 10),
                    const _GameCard(
                      emoji: '🪢',
                      title: 'Pendu',
                      subtitle: '3 mots · 6 erreurs max',
                      tags: <String>['#vocab', '#orthographe'],
                      kind: _GameKind.pendu,
                      rotation: 0.011,
                    ),
                    const SizedBox(height: 10),
                    const _GameCard(
                      emoji: '📐',
                      title: 'Problèmes',
                      subtitle: '10 problèmes · Pythagore, Thalès, % …',
                      tags: <String>['#géométrie', '#calcul'],
                      kind: _GameKind.problemes,
                      rotation: -0.013,
                    ),
                    const SizedBox(height: 10),
                    const _GameCard(
                      emoji: '📜',
                      title: 'Brevet Blanc',
                      subtitle: 'Sujet complet · note /20 · XP ×2',
                      tags: <String>['#brevet', '#officiel'],
                      kind: _GameKind.brevet,
                      rotation: 0.012,
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            HapticFeedback.selectionClick();
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const SubjectPickerScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),
                            decoration: BoxDecoration(
                              color: Bq.pillBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Bq.cardBg,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text('📚',
                                    style: TextStyle(fontSize: 16)),
                                const SizedBox(width: 8),
                                Text(
                                  'réviser par matière',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: Bq.accent,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text('→',
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Center(child: AudioToggle()),
                  ],
                ),
              );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

enum _GameKind {
  qcm,
  trueFalse,
  calc,
  memory,
  survival,
  timeline,
  dictee,
  sort,
  intrus,
  pendu,
  problemes,
  brevet,
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.progress});

  final UserProgress progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: ThemeService.instance.preset.statsGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Bq.cardBg,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Bq.accent.withValues(alpha: 0.30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Bq.cardBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${progress.level}',
                  style: GoogleFonts.quicksand(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Bq.accentDeep,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Niveau ${progress.level}',
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${progress.xpInLevel} / ${progress.xpForNextLevel} XP',
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  _StreakChip(days: progress.streakDays),
                  const SizedBox(height: 4),
                  _FreezeChip(count: progress.streakFreezes),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.levelProgress,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.35),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              _StatPill(
                emoji: '✓',
                label: '${progress.totalCorrect}',
                hint: 'bonnes',
              ),
              const SizedBox(width: 8),
              _StatPill(
                emoji: '🎯',
                label: '${(progress.accuracy * 100).round()}%',
                hint: 'précision',
              ),
              const SizedBox(width: 8),
              _StatPill(
                emoji: '🏅',
                label: '${progress.badges.length}',
                hint: 'badges',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Bq.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('🔥', style: TextStyle(fontSize: 13)),
          const SizedBox(width: 4),
          Text(
            '$days',
            style: GoogleFonts.quicksand(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: AppColors.danger,
            ),
          ),
        ],
      ),
    );
  }
}

class _FreezeChip extends StatelessWidget {
  const _FreezeChip({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Bq.cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('🧊', style: TextStyle(fontSize: 11)),
          const SizedBox(width: 3),
          Text(
            '$count',
            style: GoogleFonts.quicksand(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Bq.accentDeep,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.emoji,
    required this.label,
    required this.hint,
  });

  final String emoji;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(emoji, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.quicksand(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 3),
            Text(
              hint,
              style: GoogleFonts.quicksand(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Bq.cardBg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestsCard extends StatelessWidget {
  const _QuestsCard({required this.quests, required this.progress});

  final List<DailyQuest> quests;
  final UserProgress progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Bq.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Bq.cardBg,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Bq.accent.withValues(alpha: 0.16),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'quêtes du jour ✿',
                style: AppText.subtitle.copyWith(fontSize: 13),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Bq.cardBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${progress.questsClaimed.length} / ${quests.length}',
                  style: GoogleFonts.quicksand(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Bq.accentDeep,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < quests.length; i++) ...<Widget>[
            _QuestRow(
              key: ValueKey<String>(quests[i].id),
              quest: quests[i],
              current: progress.questsProgress[quests[i].id] ?? 0,
              done: progress.questsClaimed.contains(quests[i].id),
            ),
            if (i < quests.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _QuestRow extends StatelessWidget {
  const _QuestRow({
    super.key,
    required this.quest,
    required this.current,
    required this.done,
  });

  final DailyQuest quest;
  final int current;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final double pct =
        quest.target == 0 ? 1 : (current / quest.target).clamp(0.0, 1.0);
    return Row(
      children: <Widget>[
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: done ? AppColors.success : Bq.cardBg,
            shape: BoxShape.circle,
          ),
          child: Text(
            done ? '✓' : quest.emoji,
            style: TextStyle(
              fontSize: done ? 18 : 17,
              fontWeight: done ? FontWeight.w900 : FontWeight.w400,
              color: done ? AppColors.successDark : null,
            ),
          ),
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
                      quest.label,
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: done
                            ? AppColors.successDark
                            : Bq.textOnBg,
                        decoration: done ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                  Text(
                    '+${quest.xpReward}',
                    style: GoogleFonts.quicksand(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: AppColors.danger,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        minHeight: 5,
                        backgroundColor:
                            Bq.accent.withValues(alpha: 0.12),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          done ? AppColors.successDark : Bq.accent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$current/${quest.target}',
                    style: GoogleFonts.quicksand(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Bq.textOnBg.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.kind,
    this.rotation = 0,
    this.featured = false,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final List<String> tags;
  final _GameKind kind;
  final double rotation;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final ThemePreset theme = ThemeService.instance.preset;
    final Color textColor = theme.isDark ? Colors.white : Bq.textOnBg;
    final List<Color> gradient =
        featured ? theme.statsGradient : theme.cardGradient;
    return Transform.rotate(
      angle: rotation,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => _launch(context),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: theme.cardBorder.withValues(alpha: 0.85),
                width: 2,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: theme.accent
                      .withValues(alpha: featured ? 0.28 : 0.16),
                  blurRadius: featured ? 18 : 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  alignment: Alignment.center,
                  child: Text(emoji, style: const TextStyle(fontSize: 32)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.quicksand(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: textColor.withValues(alpha: 0.75),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        children: <Widget>[
                          for (final String t in tags)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.55),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                t,
                                style: AppText.tag.copyWith(
                                  color: textColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (featured)
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Bq.cardBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Text('▶',
                        style: TextStyle(fontSize: 16)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launch(BuildContext context) {
    HapticFeedback.selectionClick();
    final Widget screen = switch (kind) {
      _GameKind.qcm => const GameQcmScreen(
          questionType: QuestionType.qcm,
        ),
      _GameKind.trueFalse => const GameTrueFalseScreen(),
      _GameKind.calc => const GameCalcScreen(),
      _GameKind.memory => const GameMemoryScreen(),
      _GameKind.survival => const GameSurvivalScreen(),
      _GameKind.timeline => const GameTimelineScreen(),
      _GameKind.dictee => const GameDicteeScreen(),
      _GameKind.sort => const GameSortScreen(),
      _GameKind.intrus => const GameIntrusScreen(),
      _GameKind.pendu => const GamePenduScreen(),
      _GameKind.problemes => const GameProblemesScreen(),
      _GameKind.brevet => const GameBrevetScreen(),
    };
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }
}

class _SparkleTitle extends StatelessWidget {
  const _SparkleTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemePreset theme = ThemeService.instance.preset;
    return ShaderMask(
      shaderCallback: (Rect rect) =>
          LinearGradient(colors: theme.titleGradient).createShader(rect),
      child: Text(
        text,
        style: GoogleFonts.quicksand(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _ProfileChip extends StatelessWidget {
  const _ProfileChip();

  @override
  Widget build(BuildContext context) {
    final int level = ProgressService.instance.progress.level;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const ProfileScreen(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Bq.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Bq.cardBg,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('🏆', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(
                'N$level',
                style: GoogleFonts.quicksand(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Bq.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NiveauPill extends StatelessWidget {
  const _NiveauPill();

  @override
  Widget build(BuildContext context) {
    final Niveau n = PreferencesService.instance.niveau;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const ProfileScreen(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Bq.pillBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Bq.cardBg,
              width: 1,
            ),
          ),
          child: Text(
            'niveau ${n.short}',
            style: GoogleFonts.quicksand(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Bq.accentDeep,
            ),
          ),
        ),
      ),
    );
  }
}
