import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/problemes_data.dart';
import '../models/chapter.dart';
import '../models/daily_quest.dart';
import '../services/audio_service.dart';
import '../services/preferences_service.dart';
import '../services/progress_service.dart';
import '../services/theme_service.dart';
import '../theme/app_theme.dart';
import '../theme/bq_colors.dart';
import '../theme/theme_scope.dart';
import '../widgets/pill_button.dart';
import '../widgets/probleme_schema_view.dart';
import 'result_screen.dart';

/// Mini-jeu "Problèmes" : 10 problèmes (Pythagore, Thalès, aires, etc.)
/// avec saisie numérique et schéma quand pertinent.
class GameProblemesScreen extends StatefulWidget {
  const GameProblemesScreen({super.key, this.rounds = 10});

  final int rounds;

  @override
  State<GameProblemesScreen> createState() => _GameProblemesScreenState();
}

class _GameProblemesScreenState extends State<GameProblemesScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focus = FocusNode();

  List<Probleme>? _problems;
  int _idx = 0;
  int _correct = 0;
  bool _locked = false;
  bool? _wasCorrect;
  double? _userAnswer;

  @override
  void initState() {
    super.initState();
    _initPool();
  }

  Future<void> _initPool() async {
    final Niveau pref = PreferencesService.instance.niveau;
    final List<Probleme> base = ProblemesData.all.where((Probleme p) {
      if (pref == Niveau.all) return true;
      return p.niveau == Niveau.all || p.niveau == pref;
    }).toList();

    // Pool ID dépend du niveau pour ne pas mélanger les piochages.
    final String poolId = 'problemes-${pref.id}';
    final List<Probleme> picked = await ProgressService.instance
        .pickUnseen<Probleme>(
      poolId: poolId,
      pool: base,
      idOf: (Probleme p) => p.id,
      count: widget.rounds.clamp(1, base.length),
    );
    if (!mounted) return;
    setState(() => _problems = picked);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  double? _parse(String s) {
    final String t = s.trim().replaceAll(',', '.');
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  void _submit() {
    if (_locked || _problems == null) return;
    final double? v = _parse(_ctrl.text);
    if (v == null) return;
    final Probleme p = _problems![_idx];
    final bool ok = (v - p.answer).abs() <= p.tolerance;
    HapticFeedback.lightImpact();
    AudioService.instance.play(ok ? Sfx.correct : Sfx.wrong);
    setState(() {
      _locked = true;
      _wasCorrect = ok;
      _userAnswer = v;
      if (ok) _correct++;
    });
  }

  void _next() {
    if (_problems == null) return;
    if (_idx + 1 >= _problems!.length) {
      _finish();
      return;
    }
    setState(() {
      _idx++;
      _locked = false;
      _wasCorrect = null;
      _userAnswer = null;
      _ctrl.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focus.requestFocus();
    });
  }

  Future<void> _finish() async {
    final SessionRecordResult record =
        await ProgressService.instance.recordSession(
      SessionResult(
        subjectId: 'maths',
        answered: _problems!.length,
        correct: _correct,
        gameId: GameId.problemes.id,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext resultCtx) => ResultScreen(
          title: 'Problèmes',
          correct: _correct,
          answered: _problems!.length,
          record: record,
          onReplay: () {
            Navigator.of(resultCtx).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => const GameProblemesScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatAnswer(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(2).replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    ThemeScope.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration:
            BoxDecoration(gradient: ThemeService.instance.preset.bgGradient),
        child: SafeArea(
          child: _problems == null
              ? const Center(child: CircularProgressIndicator())
              : _problems!.isEmpty
                  ? _buildEmpty(context)
                  : _buildGame(context),
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              PillButton(
                label: '←',
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Spacer(),
          Text(
            'Aucun problème pour ce niveau.',
            textAlign: TextAlign.center,
            style: AppText.title,
          ),
          const SizedBox(height: 8),
          Text(
            'Change le filtre niveau dans le profil.',
            textAlign: TextAlign.center,
            style: AppText.subtitle,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildGame(BuildContext context) {
    final Probleme p = _problems![_idx];
    return Padding(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Bq.cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${_idx + 1} / ${_problems!.length}',
                  style: GoogleFonts.quicksand(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Bq.accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('problèmes 📐', style: AppText.title),
          const SizedBox(height: 2),
          Text('thème : ${p.theme}', style: AppText.subtitle),
          const SizedBox(height: 14),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (p.schema != null) ...<Widget>[
                    ProblemeSchemaView(schema: p.schema!, emoji: p.emoji),
                    const SizedBox(height: 14),
                  ],
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Bq.accent.withValues(alpha: 0.25),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      p.statement,
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Bq.textOnBg,
                        height: 1.4,
                      ),
                    ),
                  ),
                  if (_locked) ...<Widget>[
                    const SizedBox(height: 12),
                    _ResultBanner(
                      ok: _wasCorrect ?? false,
                      userAnswer: _userAnswer == null
                          ? '?'
                          : _formatAnswer(_userAnswer!),
                      expected: _formatAnswer(p.answer),
                      unit: p.unit,
                      explanation: p.explanation,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  focusNode: _focus,
                  enabled: !_locked,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[\-0-9.,]')),
                  ],
                  style: GoogleFonts.quicksand(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Bq.accentDeep,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.85),
                    hintText: 'réponse${p.unit.isEmpty ? '' : ' (${p.unit})'}',
                    hintStyle: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Bq.textOnBg.withValues(alpha: 0.35),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _ActionBtn(
                label: _locked ? 'suivant →' : 'valider',
                primary: true,
                onTap: () {
                  if (_locked) {
                    _next();
                  } else {
                    _submit();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResultBanner extends StatelessWidget {
  const _ResultBanner({
    required this.ok,
    required this.userAnswer,
    required this.expected,
    required this.unit,
    required this.explanation,
  });

  final bool ok;
  final String userAnswer;
  final String expected;
  final String unit;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    final Color bg = ok ? AppColors.success : AppColors.danger;
    final Color fg = ok ? AppColors.successDark : Colors.white;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                ok ? '✓ bravo' : '✗ raté',
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: fg,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                ok
                    ? 'ta réponse : $userAnswer ${unit.isNotEmpty ? unit : ''}'
                    : 'attendu : $expected ${unit.isNotEmpty ? unit : ''}',
                style: GoogleFonts.quicksand(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            explanation,
            style: GoogleFonts.quicksand(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fg,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
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
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          decoration: BoxDecoration(
            color: primary ? AppColors.violet : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: primary ? AppColors.violet : AppColors.violet,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: primary ? Colors.white : AppColors.violet,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}
