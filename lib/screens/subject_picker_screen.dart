import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/subjects_data.dart';
import '../models/subject.dart';
import '../services/progress_service.dart';
import '../services/theme_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pill_button.dart';
import 'chapter_picker_screen.dart';

/// Liste des matières du brevet — chaque tuile montre la progression.
class SubjectPickerScreen extends StatelessWidget {
  const SubjectPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Subject> subjects = SubjectsData.all;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeService.instance.preset.bgGradientSoft,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: AnimatedBuilder(
              animation: ProgressService.instance,
              builder: (context, _) {
                final xpBySubject =
                    ProgressService.instance.progress.xpBySubject;
                return Column(
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
                          'matières',
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: AppColors.violet,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text('mes matières ✿', style: AppText.display),
                    const SizedBox(height: 4),
                    Text(
                      'choisis une matière à réviser',
                      style: AppText.subtitle,
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: subjects.length,
                        separatorBuilder: (BuildContext _, int index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (BuildContext ctx, int i) {
                          final Subject s = subjects[i];
                          return _SubjectTile(
                            key: ValueKey<String>('subject-${s.id}'),
                            subject: s,
                            xp: xpBySubject[s.id] ?? 0,
                            onTap: () {
                              HapticFeedback.selectionClick();
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      ChapterPickerScreen(subject: s),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SubjectTile extends StatelessWidget {
  const _SubjectTile({
    super.key,
    required this.subject,
    required this.xp,
    required this.onTap,
  });

  final Subject subject;
  final int xp;
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
              colors: subject.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.85),
              width: 2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: subject.color.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(subject.emoji,
                    style: const TextStyle(fontSize: 30)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      subject.shortName,
                      style: GoogleFonts.quicksand(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: AppColors.plumDark,
                      ),
                    ),
                    Text(
                      '${subject.chapters.length} chapitres · '
                      '${subject.totalQuestions} questions',
                      style: GoogleFonts.quicksand(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.plumDark.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '✦ $xp XP',
                        style: AppText.tag.copyWith(
                          color: AppColors.plumDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Text('→',
                  style:
                      TextStyle(fontSize: 22, color: AppColors.plumDark)),
            ],
          ),
        ),
      ),
    );
  }
}
