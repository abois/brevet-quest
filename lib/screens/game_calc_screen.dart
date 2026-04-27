import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/daily_quest.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import '../services/theme_service.dart';
import '../theme/app_theme.dart';
import '../theme/bq_colors.dart';
import '../theme/theme_scope.dart';
import '../widgets/pill_button.dart';
import 'result_screen.dart';

/// Calcul mental — 60 s, génération à la volée.
/// Types : tables (×, +, −), pourcentages, puissances de 2/10.
class GameCalcScreen extends StatefulWidget {
  const GameCalcScreen({
    super.key,
    this.totalSeconds = 60,
  });

  final int totalSeconds;

  @override
  State<GameCalcScreen> createState() => _GameCalcScreenState();
}

class _CalcOp {
  const _CalcOp({required this.prompt, required this.answer});
  final String prompt;
  final int answer;
}

class _GameCalcScreenState extends State<GameCalcScreen> {
  final Random _rng = Random();
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focus = FocusNode();

  late _CalcOp _current;
  int _correct = 0;
  int _answered = 0;
  Timer? _ticker;
  late int _remaining;
  String? _flash;

  @override
  void initState() {
    super.initState();
    _current = _generate();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  _CalcOp _generate() {
    final int kind = _rng.nextInt(5);
    switch (kind) {
      case 0:
        // table de multiplication
        final int a = _rng.nextInt(10) + 2;
        final int b = _rng.nextInt(10) + 2;
        return _CalcOp(prompt: '$a × $b', answer: a * b);
      case 1:
        // somme
        final int a = _rng.nextInt(80) + 10;
        final int b = _rng.nextInt(80) + 10;
        return _CalcOp(prompt: '$a + $b', answer: a + b);
      case 2:
        // soustraction (positive)
        final int a = _rng.nextInt(80) + 30;
        final int b = _rng.nextInt(a - 1) + 1;
        return _CalcOp(prompt: '$a − $b', answer: a - b);
      case 3:
        // pourcentage simple : 10/20/25/50% d'un nombre rond
        final List<int> pcts = <int>[10, 20, 25, 50];
        final int p = pcts[_rng.nextInt(pcts.length)];
        final int n = (_rng.nextInt(20) + 1) * 10;
        return _CalcOp(prompt: '$p % de $n', answer: (n * p) ~/ 100);
      case 4:
      default:
        // puissance de 2 ou 10
        final bool ten = _rng.nextBool();
        final int e = _rng.nextInt(ten ? 4 : 7) + 2;
        final int base = ten ? 10 : 2;
        return _CalcOp(
          prompt: '$base${_sup(e)}',
          answer: pow(base, e).toInt(),
        );
    }
  }

  String _sup(int n) {
    const Map<int, String> map = <int, String>{
      0: '⁰',
      1: '¹',
      2: '²',
      3: '³',
      4: '⁴',
      5: '⁵',
      6: '⁶',
      7: '⁷',
      8: '⁸',
      9: '⁹',
    };
    return n.toString().split('').map((c) => map[int.parse(c)]!).join();
  }

  void _submit() {
    final String raw = _ctrl.text.trim();
    if (raw.isEmpty) return;
    final int? parsed = int.tryParse(raw);
    if (parsed == null) return;
    final bool ok = parsed == _current.answer;
    HapticFeedback.lightImpact();
    AudioService.instance.play(ok ? Sfx.correct : Sfx.wrong);
    setState(() {
      _answered++;
      if (ok) _correct++;
      _flash = ok ? '✓' : '✗ ${_current.answer}';
      _current = _generate();
      _ctrl.clear();
    });
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _flash = null);
    });
  }

  Future<void> _finish() async {
    final SessionRecordResult record =
        await ProgressService.instance.recordSession(
      SessionResult(
        subjectId: 'maths',
        answered: _answered,
        correct: _correct,
        gameId: GameId.calc.id,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext resultCtx) => ResultScreen(
          title: 'Calcul Mental',
          correct: _correct,
          answered: _answered,
          record: record,
          onReplay: () {
            Navigator.of(resultCtx).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => GameCalcScreen(
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
    ThemeScope.of(context);
    final double pct = _remaining / widget.totalSeconds;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(gradient: ThemeService.instance.preset.bgGradient),
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
                        color: Bq.cardBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '$_correct ✓ · $_answered total',
                        style: GoogleFonts.quicksand(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Bq.accent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _remaining <= 10
                            ? AppColors.danger
                            : Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '⏱ ${_remaining}s',
                        style: GoogleFonts.quicksand(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: _remaining <= 10
                              ? Colors.white
                              : AppColors.violet,
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
                      _remaining <= 10
                          ? AppColors.danger
                          : AppColors.violet,
                    ),
                  ),
                ),
                const Spacer(),
                if (_flash != null)
                  _FlashBadge(
                    key: ValueKey<String>('flash-$_answered'),
                    label: _flash!,
                  ),
                if (_flash != null) const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 28),
                  decoration: BoxDecoration(
                    color: Bq.cardBg,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Bq.accent.withValues(alpha: 0.22),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${_current.prompt} = ?',
                    style: GoogleFonts.quicksand(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: Bq.textOnBg,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _ctrl,
                  focusNode: _focus,
                  autofocus: true,
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: true),
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    _submit();
                    _focus.requestFocus();
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[\-0-9]')),
                  ],
                  style: GoogleFonts.quicksand(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Bq.accentDeep,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.85),
                    hintText: 'réponse',
                    hintStyle: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color:
                          Bq.textOnBg.withValues(alpha: 0.35),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 14),
                  ),
                ),
                const SizedBox(height: 14),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      _submit();
                      _focus.requestFocus();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Bq.accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'valider',
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FlashBadge extends StatelessWidget {
  const _FlashBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final bool good = label.startsWith('✓');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: good ? AppColors.success : AppColors.danger,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: good ? AppColors.successDark : Colors.white,
        ),
      ),
    );
  }
}
