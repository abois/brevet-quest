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

/// Vrai / Faux : swipe les cartes pendant 60 s.
/// Droite = Vrai · Gauche = Faux.
class GameTrueFalseScreen extends StatefulWidget {
  const GameTrueFalseScreen({
    super.key,
    this.totalSeconds = 60,
  });

  final int totalSeconds;

  @override
  State<GameTrueFalseScreen> createState() => _GameTrueFalseScreenState();
}

class _GameTrueFalseScreenState extends State<GameTrueFalseScreen> {
  late List<Question> _deck;
  int _idx = 0;
  int _correct = 0;
  int _answered = 0;
  Timer? _ticker;
  late int _remaining;
  Offset _drag = Offset.zero;

  static const double _threshold = 110;

  @override
  void initState() {
    super.initState();
    _deck = _buildDeck();
    _remaining = widget.totalSeconds;
    _ticker = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _remaining--);
      if (_remaining <= 0) {
        t.cancel();
        _finish();
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  List<Question> _buildDeck() {
    final Niveau niveau = PreferencesService.instance.niveau;
    final List<Question> base = <Question>[
      ...SubjectsData.allQuestionsByTypeForNiveau(
          QuestionType.trueFalse, niveau),
      // On ajoute les QCM transformables en Vrai/Faux serait coûteux,
      // on reste sur les vrais Vrai/Faux du seed et on boucle si vide.
    ];
    base.shuffle(Random());
    if (base.isEmpty) return <Question>[];
    // Boucler le deck pour avoir 60s de matériel.
    final List<Question> deck = <Question>[];
    while (deck.length < 60) {
      deck.addAll(base);
    }
    return deck;
  }

  void _onDragUpdate(DragUpdateDetails d) {
    setState(() => _drag = _drag + Offset(d.delta.dx, d.delta.dy * 0.3));
  }

  void _onDragEnd(DragEndDetails _) {
    if (_drag.dx.abs() > _threshold) {
      _commit(_drag.dx > 0);
    } else {
      setState(() => _drag = Offset.zero);
    }
  }

  void _commit(bool answeredTrue) {
    if (_idx >= _deck.length) return;
    final Question q = _deck[_idx];
    // 0 = Vrai, 1 = Faux dans le seed
    final int picked = answeredTrue ? 0 : 1;
    final bool ok = q.isCorrect(picked);
    HapticFeedback.lightImpact();
    AudioService.instance.play(Sfx.swipe);
    AudioService.instance.play(ok ? Sfx.correct : Sfx.wrong);
    setState(() {
      _answered++;
      if (ok) _correct++;
      _idx++;
      _drag = Offset.zero;
    });
    if (_idx >= _deck.length) _finish();
  }

  Future<void> _finish() async {
    _ticker?.cancel();
    final SessionRecordResult record =
        await ProgressService.instance.recordSession(
      SessionResult(
        subjectId: null,
        answered: _answered,
        correct: _correct,
        gameId: GameId.trueFalse.id,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(
          title: 'Vrai / Faux',
          correct: _correct,
          answered: _answered,
          record: record,
          onReplay: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => GameTrueFalseScreen(
                  totalSeconds: widget.totalSeconds,
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
    if (_deck.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Aucune affirmation disponible.')),
      );
    }
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ThemeService.instance.preset.bgGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              children: <Widget>[
                _Header(
                  remaining: _remaining,
                  totalSeconds: widget.totalSeconds,
                  correct: _correct,
                  answered: _answered,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      const _Hint(),
                      if (_idx + 1 < _deck.length)
                        _BackgroundCard(
                          key: ValueKey<String>('bg-${_deck[_idx + 1].id}'),
                          question: _deck[_idx + 1],
                        ),
                      if (_idx < _deck.length)
                        _SwipeCard(
                          key: ValueKey<String>('top-$_idx'),
                          question: _deck[_idx],
                          drag: _drag,
                          onUpdate: _onDragUpdate,
                          onEnd: _onDragEnd,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _ActionPad(
                        emoji: '✗',
                        label: 'FAUX',
                        color: AppColors.danger,
                        onTap: () => _commit(false),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionPad(
                        emoji: '✓',
                        label: 'VRAI',
                        color: AppColors.successDark,
                        onTap: () => _commit(true),
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

class _Header extends StatelessWidget {
  const _Header({
    required this.remaining,
    required this.totalSeconds,
    required this.correct,
    required this.answered,
  });

  final int remaining;
  final int totalSeconds;
  final int correct;
  final int answered;

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
                '$correct ✓ · $answered total',
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
                color: remaining <= 10
                    ? AppColors.danger
                    : Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '⏱ ${remaining}s',
                style: GoogleFonts.quicksand(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: remaining <= 10 ? Colors.white : AppColors.violet,
                ),
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
              remaining <= 10 ? AppColors.danger : AppColors.violet,
            ),
          ),
        ),
      ],
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Center(
        child: Text(
          '← faux   ·   vrai →',
          style: GoogleFonts.quicksand(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.violet.withValues(alpha: 0.7),
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

class _BackgroundCard extends StatelessWidget {
  const _BackgroundCard({super.key, required this.question});

  final Question question;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.94,
      child: _CardSurface(
        opacity: 0.6,
        child: Text(
          question.prompt,
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.plumDark.withValues(alpha: 0.4),
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class _SwipeCard extends StatelessWidget {
  const _SwipeCard({
    super.key,
    required this.question,
    required this.drag,
    required this.onUpdate,
    required this.onEnd,
  });

  final Question question;
  final Offset drag;
  final ValueChanged<DragUpdateDetails> onUpdate;
  final ValueChanged<DragEndDetails> onEnd;

  @override
  Widget build(BuildContext context) {
    final double angle = drag.dx / 1500;
    final double opacity =
        (drag.dx.abs() / 200).clamp(0.0, 1.0).toDouble();
    return GestureDetector(
      onPanUpdate: onUpdate,
      onPanEnd: onEnd,
      child: Transform.translate(
        offset: drag,
        child: Transform.rotate(
          angle: angle,
          child: _CardSurface(
            opacity: 0.97,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Text(
                    question.prompt,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.plumDark,
                      height: 1.4,
                    ),
                  ),
                ),
                if (drag.dx > 30)
                  Positioned(
                    top: 14,
                    left: 14,
                    child: _Stamp(
                      label: 'VRAI',
                      color: AppColors.successDark,
                      opacity: opacity,
                      angle: -0.3,
                    ),
                  ),
                if (drag.dx < -30)
                  Positioned(
                    top: 14,
                    right: 14,
                    child: _Stamp(
                      label: 'FAUX',
                      color: AppColors.danger,
                      opacity: opacity,
                      angle: 0.3,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardSurface extends StatelessWidget {
  const _CardSurface({required this.child, required this.opacity});

  final Widget child;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 360,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.violet.withValues(alpha: 0.25),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Stamp extends StatelessWidget {
  const _Stamp({
    required this.label,
    required this.color,
    required this.opacity,
    required this.angle,
  });

  final String label;
  final Color color;
  final double opacity;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: GoogleFonts.quicksand(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionPad extends StatelessWidget {
  const _ActionPad({
    required this.emoji,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final Color color;
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
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                emoji,
                style: TextStyle(
                  fontSize: 18,
                  color: color,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: color,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
