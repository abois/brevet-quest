import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/subjects_data.dart';
import '../models/chapter.dart';
import '../models/daily_quest.dart';
import '../models/question.dart';
import '../services/audio_service.dart';
import '../services/preferences_service.dart';
import '../services/progress_service.dart';
import '../services/theme_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pill_button.dart';
import 'result_screen.dart';

/// QCM Flash : 10 questions, 30 s par question.
///
/// Si `questionPool` est fourni, on tire les 10 questions dedans (sinon
/// dans toutes les questions QCM/Vrai-Faux du seed).
class GameQcmScreen extends StatefulWidget {
  const GameQcmScreen({
    super.key,
    this.questionPool,
    this.questionType = QuestionType.qcm,
    this.subjectId,
    this.title = 'QCM Flash',
    this.questionCount = 10,
    this.secondsPerQuestion = 30,
    this.bossMode = false,
  });

  final List<Question>? questionPool;
  final QuestionType questionType;
  final String? subjectId;
  final String title;
  final int questionCount;
  final int secondsPerQuestion;

  /// Si vrai : 1 vie (mauvaise réponse = fin), ×3 XP, visuel boss.
  final bool bossMode;

  @override
  State<GameQcmScreen> createState() => _GameQcmScreenState();
}

class _GameQcmScreenState extends State<GameQcmScreen> {
  late List<Question> _questions;
  int _idx = 0;
  int _correct = 0;
  int? _selected;
  bool _locked = false;
  Timer? _ticker;
  int _remaining = 0;

  @override
  void initState() {
    super.initState();
    _questions = _pickQuestions();
    _remaining = widget.secondsPerQuestion;
    _startTimer();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  List<Question> _pickQuestions() {
    final Niveau niveau = PreferencesService.instance.niveau;
    final List<Question> source = widget.questionPool ??
        <Question>[
          ...SubjectsData.allQuestionsByTypeForNiveau(
              QuestionType.qcm, niveau),
          ...SubjectsData.allQuestionsByTypeForNiveau(
              QuestionType.trueFalse, niveau),
        ];
    final List<Question> shuffled = List<Question>.of(source)
      ..shuffle(Random());
    return shuffled.take(widget.questionCount).toList();
  }

  void _startTimer() {
    _ticker?.cancel();
    _remaining = widget.secondsPerQuestion;
    _ticker = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _remaining--);
      if (_remaining <= 0) {
        _ticker?.cancel();
        _onTimeout();
      }
    });
  }

  void _onTimeout() {
    if (_locked) return;
    HapticFeedback.lightImpact();
    setState(() {
      _locked = true;
      _selected = null;
    });
    Future<void>.delayed(const Duration(milliseconds: 900), _next);
  }

  void _onPick(int i) {
    if (_locked) return;
    final Question q = _questions[_idx];
    HapticFeedback.selectionClick();
    final bool ok = q.isCorrect(i);
    AudioService.instance.play(ok ? Sfx.correct : Sfx.wrong);
    setState(() {
      _selected = i;
      _locked = true;
      if (ok) _correct++;
    });
    _ticker?.cancel();
    // Boss : 1 erreur = fin de partie immédiate.
    if (widget.bossMode && !ok) {
      Future<void>.delayed(const Duration(milliseconds: 1400), _finish);
      return;
    }
    Future<void>.delayed(const Duration(milliseconds: 1100), _next);
  }

  void _next() {
    if (!mounted) return;
    if (_idx + 1 >= _questions.length) {
      _finish();
      return;
    }
    setState(() {
      _idx++;
      _selected = null;
      _locked = false;
    });
    _startTimer();
  }

  Future<void> _finish() async {
    final SessionRecordResult record =
        await ProgressService.instance.recordSession(
      SessionResult(
        subjectId: widget.subjectId,
        answered: _idx + 1,
        correct: _correct,
        gameId: GameId.qcm.id,
        xpMultiplier: widget.bossMode ? 3 : 1,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(
          title: widget.title,
          correct: _correct,
          answered: _questions.length,
          record: record,
          onReplay: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => GameQcmScreen(
                  questionPool: widget.questionPool,
                  questionType: widget.questionType,
                  subjectId: widget.subjectId,
                  title: widget.title,
                  questionCount: widget.questionCount,
                  secondsPerQuestion: widget.secondsPerQuestion,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const _EmptyState();
    }
    final Question q = _questions[_idx];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ThemeService.instance.preset.bgGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _Header(
                  title: widget.title,
                  index: _idx + 1,
                  total: _questions.length,
                  remaining: _remaining,
                  totalSeconds: widget.secondsPerQuestion,
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.violet.withValues(alpha: 0.18),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    q.prompt,
                    style: GoogleFonts.quicksand(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.plumDark,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: q.choices.length,
                    separatorBuilder: (BuildContext _, int index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (BuildContext ctx, int i) {
                      return _ChoiceTile(
                        key: ValueKey<String>('${q.id}-$i'),
                        label: q.choices[i],
                        index: i,
                        isCorrect: q.answerIndex == i,
                        isSelected: _selected == i,
                        revealed: _locked,
                        onTap: () => _onPick(i),
                      );
                    },
                  ),
                ),
                if (_locked && q.explanation != null)
                  _Explanation(text: q.explanation!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.index,
    required this.total,
    required this.remaining,
    required this.totalSeconds,
  });

  final String title;
  final int index;
  final int total;
  final int remaining;
  final int totalSeconds;

  @override
  Widget build(BuildContext context) {
    final double pct = remaining / totalSeconds;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            PillButton(
              label: '←',
              onTap: () => Navigator.of(context).pop(),
            ),
            const Spacer(),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '$index / $total',
                style: GoogleFonts.quicksand(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: AppColors.violet,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: remaining <= 5
                    ? AppColors.danger
                    : Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '⏱',
                    style: TextStyle(
                      fontSize: 12,
                      color: remaining <= 5
                          ? Colors.white
                          : AppColors.violet,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${remaining}s',
                    style: GoogleFonts.quicksand(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: remaining <= 5
                          ? Colors.white
                          : AppColors.violet,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: pct.clamp(0, 1),
            minHeight: 6,
            backgroundColor: Colors.white.withValues(alpha: 0.4),
            valueColor: AlwaysStoppedAnimation<Color>(
              remaining <= 5 ? AppColors.danger : AppColors.violet,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    super.key,
    required this.label,
    required this.index,
    required this.isCorrect,
    required this.isSelected,
    required this.revealed,
    required this.onTap,
  });

  final String label;
  final int index;
  final bool isCorrect;
  final bool isSelected;
  final bool revealed;
  final VoidCallback onTap;

  Color _bg() {
    if (!revealed) return Colors.white.withValues(alpha: 0.92);
    if (isCorrect) return AppColors.success;
    if (isSelected) return AppColors.danger.withValues(alpha: 0.85);
    return Colors.white.withValues(alpha: 0.45);
  }

  Color _border() {
    if (!revealed) {
      return isSelected
          ? AppColors.violet
          : AppColors.violet.withValues(alpha: 0.25);
    }
    if (isCorrect) return AppColors.successDark;
    if (isSelected) return AppColors.danger;
    return Colors.white.withValues(alpha: 0.6);
  }

  String? _icon() {
    if (!revealed) return null;
    if (isCorrect) return '✓';
    if (isSelected) return '✗';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final String letter =
        String.fromCharCode('A'.codeUnitAt(0) + index);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: revealed ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: _bg(),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border(), width: 2),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.lavender100,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  letter,
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: AppColors.violetDeep,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.plumDark,
                  ),
                ),
              ),
              if (_icon() != null)
                Text(
                  _icon()!,
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: isCorrect
                        ? AppColors.successDark
                        : Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Explanation extends StatelessWidget {
  const _Explanation({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.glassSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.violet.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('💡', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.quicksand(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.plumDark,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ThemeService.instance.preset.bgGradient),
        child: Center(
          child: Text(
            'Aucune question disponible.',
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.plumDark,
            ),
          ),
        ),
      ),
    );
  }
}
