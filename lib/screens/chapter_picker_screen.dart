import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/chapter.dart';
import '../models/question.dart';
import '../models/subject.dart';
import '../services/preferences_service.dart';
import '../theme/app_theme.dart';
import '../theme/bq_colors.dart';
import '../theme/theme_scope.dart';
import '../widgets/pill_button.dart';
import 'game_qcm_screen.dart';

/// Liste des chapitres d'une matière + bouton « tout réviser ».
class ChapterPickerScreen extends StatelessWidget {
  const ChapterPickerScreen({super.key, required this.subject});

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    ThemeScope.of(context);
    final Niveau niveau = PreferencesService.instance.niveau;
    final List<Chapter> visible = <Chapter>[
      for (final Chapter c in subject.chapters)
        if (c.matchesUserNiveau(niveau)) c,
    ];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              subject.gradient.first,
              AppColors.lavender50,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    PillButton(
                      label: '←',
                      onTap: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(
                      subject.emoji,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(subject.name, style: AppText.title),
                const SizedBox(height: 2),
                Text(
                  'choisis un chapitre',
                  style: AppText.subtitle,
                ),
                const SizedBox(height: 14),
                _AllChaptersTile(
                  key: const ValueKey<String>('all-chapters'),
                  subject: subject,
                  onTap: () => _launch(context, null),
                ),
                const SizedBox(height: 8),
                _BossTile(
                  key: const ValueKey<String>('boss'),
                  subject: subject,
                  onTap: () => _launchBoss(context),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: visible.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'Aucun chapitre pour ce niveau.\n'
                              'Change le filtre niveau dans le profil.',
                              textAlign: TextAlign.center,
                              style: AppText.subtitle,
                            ),
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: visible.length,
                          separatorBuilder: (BuildContext _, int index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (BuildContext ctx, int i) {
                            final Chapter c = visible[i];
                            return _ChapterTile(
                              key: ValueKey<String>('chapter-${c.id}'),
                              chapter: c,
                              onTap: () => _launch(context, c),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launch(BuildContext context, Chapter? chapter) {
    HapticFeedback.selectionClick();
    final List<Question> pool = chapter == null
        ? <Question>[
            for (final Chapter c in subject.chapters) ...c.questions,
          ]
        : chapter.questions;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GameQcmScreen(
          questionPool: pool,
          subjectId: subject.id,
          title: chapter == null
              ? '${subject.shortName} · tout'
              : chapter.name,
        ),
      ),
    );
  }

  void _launchBoss(BuildContext context) {
    HapticFeedback.mediumImpact();
    final List<Question> pool = <Question>[
      for (final Chapter c in subject.chapters) ...c.questions,
    ];
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GameQcmScreen(
          questionPool: pool,
          subjectId: subject.id,
          title: 'Boss · ${subject.shortName}',
          questionCount: 5,
          secondsPerQuestion: 25,
          bossMode: true,
        ),
      ),
    );
  }
}

class _AllChaptersTile extends StatelessWidget {
  const _AllChaptersTile({
    super.key,
    required this.subject,
    required this.onTap,
  });

  final Subject subject;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                subject.color,
                subject.color.withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: subject.color.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              const Text('🎲', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Tout réviser',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${subject.totalQuestions} questions au hasard',
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const Text('▶',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChapterTile extends StatelessWidget {
  const _ChapterTile({
    super.key,
    required this.chapter,
    required this.onTap,
  });

  final Chapter chapter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Bq.accent.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Bq.cardBg,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child:
                    Text(chapter.emoji, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      chapter.name,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Bq.textOnBg,
                      ),
                    ),
                    Text(
                      '${chapter.questions.length} questions',
                      style: GoogleFonts.quicksand(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Bq.textOnBg.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const Text('→',
                  style:
                      TextStyle(fontSize: 18, color: AppColors.violet)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BossTile extends StatelessWidget {
  const _BossTile({super.key, required this.subject, required this.onTap});

  final Subject subject;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[Color(0xFF2D1538), Color(0xFFE83E8C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.danger.withValues(alpha: 0.4),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              const Text('👹', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Boss Battle',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '5 questions · 1 vie · ×3 XP',
                      style: GoogleFonts.quicksand(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '×3',
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: AppColors.danger,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
