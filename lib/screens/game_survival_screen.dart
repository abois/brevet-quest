import 'dart:async';

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
import '../theme/bq_colors.dart';
import '../theme/theme_scope.dart';
import '../widgets/pill_button.dart';
import 'result_screen.dart';

/// Mode Élimination : 3 vies, endless, jusqu'à perdre toutes les vies.
class GameSurvivalScreen extends StatefulWidget {
  const GameSurvivalScreen({super.key});

  @override
  State<GameSurvivalScreen> createState() => _GameSurvivalScreenState();
}

class _GameSurvivalScreenState extends State<GameSurvivalScreen> {
  List<Question>? _pool;
  int _cursor = 0;

  Question? _current;
  int _lives = 3;
  int _streak = 0;
  int _answered = 0;
  int _correct = 0;
  int? _selected;
  bool _locked = false;
  Timer? _autoNextTimer;

  @override
  void dispose() {
    _autoNextTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _setupPool();
  }

  Future<void> _setupPool() async {
    final Niveau niveau = PreferencesService.instance.niveau;
    final List<Question> base = <Question>[
      ...SubjectsData.allQuestionsByTypeForNiveau(QuestionType.qcm, niveau),
      ...SubjectsData.allQuestionsByTypeForNiveau(
          QuestionType.trueFalse, niveau),
    ];
    if (base.isEmpty) {
      if (!mounted) return;
      setState(() => _pool = <Question>[]);
      return;
    }
    final List<Question> picked =
        await ProgressService.instance.pickUnseen<Question>(
      poolId: 'survival-${niveau.id}',
      pool: base,
      idOf: (Question q) => q.id,
      count: base.length,
    );
    if (!mounted) return;
    setState(() {
      _pool = picked;
      _cursor = 0;
      _current = picked.isNotEmpty ? picked.first : null;
    });
  }

  Question? _next() {
    if (_pool == null || _pool!.isEmpty) return null;
    _cursor = (_cursor + 1) % _pool!.length;
    return _pool![_cursor];
  }

  void _onPick(int i) {
    if (_locked || _current == null) return;
    HapticFeedback.selectionClick();
    final bool ok = _current!.isCorrect(i);
    AudioService.instance.play(ok ? Sfx.correct : Sfx.wrong);
    setState(() {
      _selected = i;
      _locked = true;
      _answered++;
      if (ok) {
        _correct++;
        _streak++;
      } else {
        _lives--;
        _streak = 0;
      }
    });
    // Auto-suivant : 900ms si correct, 4500ms si faux pour lire
    // l'explication. Le user peut tap pour passer plus tôt.
    _autoNextTimer?.cancel();
    _autoNextTimer = Timer(
      Duration(milliseconds: ok ? 900 : 4500),
      _advance,
    );
  }

  void _advance() {
    _autoNextTimer?.cancel();
    if (!mounted) return;
    if (_lives <= 0) {
      _finish();
      return;
    }
    setState(() {
      _current = _next();
      _selected = null;
      _locked = false;
    });
  }

  void _onTapToContinue() {
    if (!_locked) return;
    _advance();
  }

  Future<void> _finish() async {
    final SessionRecordResult record =
        await ProgressService.instance.recordSession(
      SessionResult(
        subjectId: null,
        answered: _answered,
        correct: _correct,
        gameId: GameId.survival.id,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext resultCtx) => ResultScreen(
          title: 'Élimination · streak $_streak',
          correct: _correct,
          answered: _answered,
          record: record,
          onReplay: () {
            Navigator.of(resultCtx).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => const GameSurvivalScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeScope.of(context);
    if (_pool == null || _current == null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: ThemeService.instance.preset.bgGradient),
          child: const SafeArea(
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }
    if (_pool!.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Aucune question disponible.')),
      );
    }
    final Question q = _current!;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ThemeService.instance.preset.bgGradient),
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
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    _LivesDisplay(lives: _lives),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Bq.cardBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text('⚡', style: TextStyle(fontSize: 13)),
                          const SizedBox(width: 4),
                          Text(
                            '$_streak',
                            style: GoogleFonts.quicksand(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Bq.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Bq.cardBg,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Bq.accent.withValues(alpha: 0.18),
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
                      color: Bq.textOnBg,
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
                if (_locked) ...<Widget>[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _onTapToContinue,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Bq.accent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'tape pour continuer →',
                        style: GoogleFonts.quicksand(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LivesDisplay extends StatelessWidget {
  const _LivesDisplay({required this.lives});

  final int lives;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Bq.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Text(
                i < lives ? '❤️' : '🖤',
                style: const TextStyle(fontSize: 14),
              ),
            ),
        ],
      ),
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
          : Bq.accent.withValues(alpha: 0.25);
    }
    if (isCorrect) return AppColors.successDark;
    if (isSelected) return AppColors.danger;
    return Colors.white.withValues(alpha: 0.6);
  }

  @override
  Widget build(BuildContext context) {
    final String letter = String.fromCharCode('A'.codeUnitAt(0) + index);
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
                  color: Bq.cardBg,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  letter,
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Bq.accentDeep,
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
                    color: Bq.textOnBg,
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
        color: Bq.pillBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Bq.accent.withValues(alpha: 0.3),
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
                color: Bq.textOnBg,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
