import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/intrus_data.dart';
import '../models/daily_quest.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import '../services/theme_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pill_button.dart';
import 'result_screen.dart';

/// L'intrus : 4 items, trouve celui qui ne va pas. 8 rounds.
class GameIntrusScreen extends StatefulWidget {
  const GameIntrusScreen({super.key, this.rounds = 8});

  final int rounds;

  @override
  State<GameIntrusScreen> createState() => _GameIntrusScreenState();
}

class _GameIntrusScreenState extends State<GameIntrusScreen> {
  late List<IntrusSet> _sets;
  int _idx = 0;
  int _correct = 0;
  int? _selected;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    final List<IntrusSet> shuffled = List<IntrusSet>.of(IntrusData.all)
      ..shuffle(Random());
    _sets = shuffled.take(widget.rounds).toList();
  }

  void _onPick(int i) {
    if (_locked) return;
    HapticFeedback.selectionClick();
    final IntrusSet s = _sets[_idx];
    final bool ok = i == s.intruderIndex;
    AudioService.instance.play(ok ? Sfx.correct : Sfx.wrong);
    setState(() {
      _selected = i;
      _locked = true;
      if (ok) _correct++;
    });
    Future<void>.delayed(const Duration(milliseconds: 1300), _next);
  }

  void _next() {
    if (!mounted) return;
    if (_idx + 1 >= _sets.length) {
      _finish();
      return;
    }
    setState(() {
      _idx++;
      _selected = null;
      _locked = false;
    });
  }

  Future<void> _finish() async {
    final SessionRecordResult record =
        await ProgressService.instance.recordSession(
      SessionResult(
        subjectId: null,
        answered: _sets.length,
        correct: _correct,
        gameId: GameId.intrus.id,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(
          title: 'L\'intrus',
          correct: _correct,
          answered: _sets.length,
          record: record,
          onReplay: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => const GameIntrusScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final IntrusSet s = _sets[_idx];
    return Scaffold(
      body: Container(
        decoration:
            BoxDecoration(gradient: ThemeService.instance.preset.bgGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    PillButton(
                      label: '←',
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${_idx + 1} / ${_sets.length}',
                        style: GoogleFonts.quicksand(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: AppColors.violet,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text('l\'intrus 🎭', style: AppText.title),
                const SizedBox(height: 4),
                Text(
                  'thème : ${s.theme}',
                  style: AppText.subtitle,
                ),
                const SizedBox(height: 22),
                Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: 4,
                    itemBuilder: (BuildContext ctx, int i) {
                      return _IntrusCard(
                        key: ValueKey<String>('intrus-$_idx-$i'),
                        label: s.items[i],
                        isIntruder: i == s.intruderIndex,
                        isSelected: _selected == i,
                        revealed: _locked,
                        onTap: () => _onPick(i),
                      );
                    },
                  ),
                ),
                if (_locked && s.explanation != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 8),
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
                        const Text('💡', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            s.explanation!,
                            style: GoogleFonts.quicksand(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.plumDark,
                            ),
                          ),
                        ),
                      ],
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

class _IntrusCard extends StatelessWidget {
  const _IntrusCard({
    super.key,
    required this.label,
    required this.isIntruder,
    required this.isSelected,
    required this.revealed,
    required this.onTap,
  });

  final String label;
  final bool isIntruder;
  final bool isSelected;
  final bool revealed;
  final VoidCallback onTap;

  Color _bg() {
    if (!revealed) {
      return isSelected
          ? AppColors.lavender200
          : Colors.white.withValues(alpha: 0.95);
    }
    if (isIntruder) return AppColors.success;
    if (isSelected) return AppColors.danger.withValues(alpha: 0.85);
    return Colors.white.withValues(alpha: 0.6);
  }

  Color _border() {
    if (!revealed) {
      return isSelected
          ? AppColors.violet
          : AppColors.violet.withValues(alpha: 0.3);
    }
    if (isIntruder) return AppColors.successDark;
    if (isSelected) return AppColors.danger;
    return Colors.white;
  }

  Color _fg() {
    if (!revealed) return AppColors.plumDark;
    if (isIntruder) return AppColors.successDark;
    if (isSelected) return Colors.white;
    return AppColors.plumDark.withValues(alpha: 0.6);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: revealed ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _bg(),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _border(), width: 2),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.violet.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: _fg(),
                ),
              ),
              if (revealed && isIntruder) ...<Widget>[
                const SizedBox(height: 4),
                const Text('🎯', style: TextStyle(fontSize: 18)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
