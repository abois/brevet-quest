import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/brevet_sujets.dart';
import '../models/daily_quest.dart';
import '../services/audio_service.dart';
import '../services/brevet_progress_service.dart';
import '../services/progress_service.dart';
import '../services/theme_service.dart';
import '../theme/app_theme.dart';
import '../theme/bq_colors.dart';
import '../theme/theme_scope.dart';
import '../widgets/pill_button.dart';
import '../widgets/probleme_schema_view.dart';

/// Mini-jeu "Brevet Blanc" — un sujet composé de plusieurs exercices,
/// chaque exercice ayant un contexte commun et plusieurs questions liées.
class GameBrevetScreen extends StatefulWidget {
  const GameBrevetScreen({super.key});

  @override
  State<GameBrevetScreen> createState() => _GameBrevetScreenState();
}

enum _Phase { picking, choosingMode, playing, finished }

class _GameBrevetScreenState extends State<GameBrevetScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focus = FocusNode();

  _Phase _phase = _Phase.picking;
  BrevetSujet? _sujet;
  int _exoIdx = 0;
  int _questIdx = 0;

  /// Si non-null : on joue UN seul exercice (à cet index), pas l'épreuve.
  int? _singleExoIdx;

  /// Points obtenus, par index d'exercice.
  final Map<int, int> _scoreByExo = <int, int>{};

  /// Nombre de questions correctement répondues (pour XP via SessionResult).
  int _correctQuestions = 0;

  bool _locked = false;
  bool? _wasCorrect;
  double? _userAnswer;
  int? _userChoiceIdx;

  /// Progression chargée depuis le disque, proposée à la reprise.
  BrevetProgress? _resumable;

  @override
  void initState() {
    super.initState();
    _loadResumable();
  }

  Future<void> _loadResumable() async {
    final BrevetProgress? p = await BrevetProgressService.load();
    if (!mounted || p == null) return;
    setState(() => _resumable = p);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _saveProgress() async {
    if (_sujet == null || _singleExoIdx != null) return;
    await BrevetProgressService.save(BrevetProgress(
      sujetId: _sujet!.id,
      exoIdx: _exoIdx,
      questIdx: _questIdx,
      scoreByExo: Map<int, int>.of(_scoreByExo),
      correctQuestions: _correctQuestions,
    ));
  }

  Future<void> _clearProgress() async {
    await BrevetProgressService.clear();
    if (mounted) setState(() => _resumable = null);
  }

  // ── helpers ────────────────────────────────────────────────────────

  double? _parse(String s) {
    final String t = s.trim().replaceAll(',', '.');
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  String _formatAnswer(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(2).replaceAll('.', ',');
  }

  int get _totalScore =>
      _scoreByExo.values.fold(0, (int s, int v) => s + v);

  // ── flow ───────────────────────────────────────────────────────────

  void _openModeChoice(BrevetSujet sujet) {
    setState(() {
      _sujet = sujet;
      _phase = _Phase.choosingMode;
    });
  }

  void _start(BrevetSujet sujet, {int? singleExoIdx}) {
    setState(() {
      _sujet = sujet;
      _exoIdx = singleExoIdx ?? 0;
      _questIdx = 0;
      _singleExoIdx = singleExoIdx;
      _scoreByExo.clear();
      _correctQuestions = 0;
      _phase = _Phase.playing;
      _resetQuestion();
    });
  }

  void _resume(BrevetProgress p) {
    final BrevetSujet sujet = BrevetSujets.all.firstWhere(
      (BrevetSujet s) => s.id == p.sujetId,
      orElse: () => BrevetSujets.all.first,
    );
    if (sujet.id != p.sujetId) return;
    setState(() {
      _sujet = sujet;
      _exoIdx = p.exoIdx;
      _questIdx = p.questIdx;
      _singleExoIdx = null;
      _scoreByExo
        ..clear()
        ..addAll(p.scoreByExo);
      _correctQuestions = p.correctQuestions;
      _phase = _Phase.playing;
      _resetQuestion();
    });
  }

  void _resetQuestion() {
    _locked = false;
    _wasCorrect = null;
    _userAnswer = null;
    _userChoiceIdx = null;
    _ctrl.clear();
  }

  /// Validation pour les questions numériques.
  void _submitNumeric() {
    if (_locked || _sujet == null) return;
    final double? v = _parse(_ctrl.text);
    if (v == null) return;
    final BrevetQuestion q =
        _sujet!.exercises[_exoIdx].questions[_questIdx];
    final bool ok = (v - q.answer!).abs() <= q.tolerance!;
    _registerAnswer(ok, q, userAnswerNum: v);
  }

  /// Validation pour QCM / Vrai-Faux.
  void _submitChoice(int idx) {
    if (_locked || _sujet == null) return;
    final BrevetQuestion q =
        _sujet!.exercises[_exoIdx].questions[_questIdx];
    final bool ok = idx == q.answerIndex;
    _registerAnswer(ok, q, userChoiceIdx: idx);
  }

  void _registerAnswer(bool ok, BrevetQuestion q,
      {double? userAnswerNum, int? userChoiceIdx}) {
    HapticFeedback.lightImpact();
    AudioService.instance.play(ok ? Sfx.correct : Sfx.wrong);
    setState(() {
      _locked = true;
      _wasCorrect = ok;
      _userAnswer = userAnswerNum;
      _userChoiceIdx = userChoiceIdx;
      if (ok) {
        _scoreByExo[_exoIdx] = (_scoreByExo[_exoIdx] ?? 0) + q.points;
        _correctQuestions++;
      }
    });
    _saveProgress();
  }

  void _next() {
    if (_sujet == null) return;
    final BrevetExercise exo = _sujet!.exercises[_exoIdx];
    if (_questIdx + 1 < exo.questions.length) {
      setState(() {
        _questIdx++;
        _resetQuestion();
      });
    } else if (_singleExoIdx == null &&
        _exoIdx + 1 < _sujet!.exercises.length) {
      // En mode épreuve complète : on passe à l'exercice suivant.
      setState(() {
        _exoIdx++;
        _questIdx = 0;
        _resetQuestion();
      });
    } else {
      // Fin (épreuve ou exercice unique terminé).
      _finish();
    }
    _saveProgress();
  }

  Future<void> _finish() async {
    if (_sujet == null) return;
    final SessionRecordResult record =
        await ProgressService.instance.recordSession(
      SessionResult(
        subjectId: 'maths',
        answered: _sujet!.totalQuestions,
        correct: _correctQuestions,
        gameId: GameId.brevet.id,
        xpMultiplier: 2,
      ),
    );
    if (!mounted) return;
    setState(() => _phase = _Phase.finished);
    // Une épreuve terminée → on efface la progression sauvegardée.
    if (_singleExoIdx == null) {
      await _clearProgress();
    }
    if (record.leveledUp) AudioService.instance.play(Sfx.levelUp);
  }

  // ── builds ─────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    ThemeScope.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration:
            BoxDecoration(gradient: ThemeService.instance.preset.bgGradient),
        child: SafeArea(
          child: switch (_phase) {
            _Phase.picking => _buildPicker(),
            _Phase.choosingMode => _buildModeChoice(),
            _Phase.playing => _buildPlaying(),
            _Phase.finished => _buildFinished(),
          },
        ),
      ),
    );
  }

  Widget _buildPicker() {
    final int level = ProgressService.instance.progress.level;
    return Padding(
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
            ],
          ),
          const SizedBox(height: 14),
          Text('brevet blanc 📜', style: AppText.title),
          const SizedBox(height: 4),
          Text(
            '${BrevetSujets.all.length} sujets · note /20 · XP ×2',
            style: AppText.subtitle,
          ),
          const SizedBox(height: 12),
          if (_resumable != null) _buildResumeBanner(_resumable!),
          if (_resumable != null) const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: BrevetSujets.all.length,
              separatorBuilder: (BuildContext _, int _) =>
                  const SizedBox(height: 10),
              itemBuilder: (BuildContext ctx, int i) {
                final BrevetSujet s = BrevetSujets.all[i];
                final bool unlocked = s.isUnlocked(level);
                return _SujetTile(
                  sujet: s,
                  unlocked: unlocked,
                  userLevel: level,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    if (unlocked) {
                      _openModeChoice(s);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Bq.accentDeep,
                          duration: const Duration(seconds: 2),
                          content: Text(
                            '${s.emoji} ${s.title} se débloque au niveau ${s.unlockLevel} '
                            '(tu es niveau $level).',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumeBanner(BrevetProgress p) {
    final BrevetSujet? sujet = BrevetSujets.all
        .where((BrevetSujet s) => s.id == p.sujetId)
        .firstOrNull;
    if (sujet == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: ThemeService.instance.preset.statsGradient),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          const Text('⏸', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Reprendre ${sujet.title} ?',
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Exo ${p.exoIdx + 1} · question ${p.questIdx + 1} · '
                  '${p.correctQuestions} bonnes',
                  style: GoogleFonts.quicksand(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              _resume(p);
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'reprendre →',
                style: GoogleFonts.quicksand(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Bq.accentDeep,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () async {
              HapticFeedback.selectionClick();
              await _clearProgress();
            },
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.close, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeChoice() {
    final BrevetSujet sujet = _sujet!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              PillButton(
                label: '←',
                onTap: () => setState(() => _phase = _Phase.picking),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(sujet.title, style: AppText.title),
          const SizedBox(height: 2),
          Text(sujet.subtitle, style: AppText.subtitle),
          if (sujet.source != null) ...<Widget>[
            const SizedBox(height: 4),
            Text('📎 ${sujet.source}',
                style: GoogleFonts.quicksand(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Bq.textOnBg.withValues(alpha: 0.7),
                )),
          ],
          const SizedBox(height: 18),
          _ModeButton(
            emoji: '📜',
            title: 'Épreuve complète',
            subtitle:
                '${sujet.exercises.length} exercices · ${sujet.totalQuestions} questions · ${sujet.totalPoints} pts · note /20',
            onTap: () => _start(sujet),
          ),
          const SizedBox(height: 12),
          Text('— ou un seul exercice —',
              style: AppText.subtitle.copyWith(fontSize: 12)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: sujet.exercises.length,
              separatorBuilder: (BuildContext _, int _) =>
                  const SizedBox(height: 8),
              itemBuilder: (BuildContext ctx, int i) {
                final BrevetExercise exo = sujet.exercises[i];
                return _ModeButton(
                  emoji: '✏️',
                  title: exo.title,
                  subtitle:
                      '${exo.questions.length} questions · ${exo.totalPoints} pts',
                  onTap: () => _start(sujet, singleExoIdx: i),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaying() {
    final BrevetSujet sujet = _sujet!;
    final BrevetExercise exo = sujet.exercises[_exoIdx];
    final BrevetQuestion q = exo.questions[_questIdx];
    final int totalQ = sujet.totalQuestions;
    int globalIdx = 0;
    for (int i = 0; i < _exoIdx; i++) {
      globalIdx += sujet.exercises[i].questions.length;
    }
    globalIdx += _questIdx + 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              PillButton(
                label: '←',
                onTap: () =>
                    setState(() => _phase = _Phase.picking),
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
                  '$globalIdx / $totalQ',
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
          Text(sujet.title, style: AppText.title),
          const SizedBox(height: 2),
          Text(exo.title, style: AppText.subtitle),
          const SizedBox(height: 14),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (exo.schema != null) ...<Widget>[
                    ProblemeSchemaView(schema: exo.schema!),
                    const SizedBox(height: 12),
                  ],
                  if (exo.imageUrl != null) ...<Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        exo.imageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext _, Widget child,
                            ImageChunkEvent? prog) {
                          if (prog == null) return child;
                          return AspectRatio(
                            aspectRatio: 1.2,
                            child: Container(
                              color: Bq.cardBg,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                        },
                        errorBuilder:
                            (BuildContext _, Object _, StackTrace? _) =>
                                const SizedBox.shrink(),
                      ),
                    ),
                    if (exo.imageCaption != null) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        exo.imageCaption!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          color: Bq.textOnBg.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                  ],
                  // Contexte de l'exercice (sélectionnable pour faciliter
                  // le copier-coller en réponse).
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Bq.cardBg.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Bq.accent.withValues(alpha: 0.25),
                        width: 1.5,
                      ),
                    ),
                    child: SelectableText(
                      exo.context,
                      style: GoogleFonts.quicksand(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Bq.textOnBg,
                        height: 1.4,
                      ),
                    ),
                  ),
                  if (sujet.sourceUrl != null) ...<Widget>[
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () async {
                          final Uri uri = Uri.parse(sujet.sourceUrl!);
                          await launchUrl(uri,
                              mode: LaunchMode.inAppBrowserView);
                        },
                        icon: const Icon(Icons.picture_as_pdf, size: 16),
                        label: Text(
                          'ouvrir le sujet officiel',
                          style: GoogleFonts.quicksand(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Bq.accent,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  if (q.schema != null) ...<Widget>[
                    ProblemeSchemaView(schema: q.schema!),
                    const SizedBox(height: 12),
                  ],
                  // Énoncé de la question
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Bq.cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Bq.accent.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            q.prompt,
                            style: GoogleFonts.quicksand(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Bq.textOnBg,
                              height: 1.4,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Bq.accent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${q.points} pt${q.points > 1 ? 's' : ''}',
                            style: GoogleFonts.quicksand(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_locked) ...<Widget>[
                    const SizedBox(height: 12),
                    _ResultBanner(
                      ok: _wasCorrect ?? false,
                      userAnswer: _formatUserAnswer(q),
                      expected: _formatExpected(q),
                      unit: q.unit ?? '',
                      explanation: q.explanation,
                    ),
                  ],
                  const SizedBox(height: 10),
                  _buildAnswerArea(q),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatUserAnswer(BrevetQuestion q) {
    if (q.kind == BrevetQuestionKind.numerical) {
      return _userAnswer == null ? '?' : _formatAnswer(_userAnswer!);
    }
    if (_userChoiceIdx == null) return '?';
    return q.choices[_userChoiceIdx!];
  }

  String _formatExpected(BrevetQuestion q) {
    if (q.kind == BrevetQuestionKind.numerical) {
      return _formatAnswer(q.answer!);
    }
    return q.choices[q.answerIndex];
  }

  Widget _buildAnswerArea(BrevetQuestion q) {
    if (q.kind == BrevetQuestionKind.numerical) {
      return Row(
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
              onSubmitted: (_) => _submitNumeric(),
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
                fillColor: Bq.cardBg,
                hintText:
                    'réponse${q.unit == null || q.unit!.isEmpty ? '' : ' (${q.unit})'}',
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
                    horizontal: 14, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _ActionBtn(
            label: _locked ? 'suivante →' : 'valider',
            primary: true,
            onTap: () {
              if (_locked) {
                _next();
              } else {
                _submitNumeric();
              }
            },
          ),
        ],
      );
    }
    if (q.kind == BrevetQuestionKind.openEnded) {
      return _buildOpenEnded(q);
    }
    // QCM ou Vrai/Faux : boutons de choix
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int i = 0; i < q.choices.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ChoiceButton(
              label: q.choices[i],
              selected: _userChoiceIdx == i,
              correct: _locked && i == q.answerIndex,
              wrong: _locked && _userChoiceIdx == i && i != q.answerIndex,
              onTap: _locked ? null : () => _submitChoice(i),
            ),
          ),
        if (_locked)
          _ActionBtn(
            label: 'suivante →',
            primary: true,
            onTap: _next,
          ),
      ],
    );
  }

  Widget _buildOpenEnded(BrevetQuestion q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextField(
          controller: _ctrl,
          focusNode: _focus,
          enabled: !_locked,
          maxLines: 5,
          minLines: 3,
          textInputAction: TextInputAction.newline,
          style: GoogleFonts.quicksand(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Bq.textOnBg,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Bq.cardBg,
            hintText: 'Rédige ta réponse…',
            hintStyle: GoogleFonts.quicksand(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Bq.textOnBg.withValues(alpha: 0.4),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 8),
        if (!_locked)
          _ActionBtn(
            label: 'voir la réponse type',
            primary: true,
            onTap: _revealModelAnswer,
          )
        else ...<Widget>[
          // Affichage de la modelAnswer
          if (q.modelAnswer != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.successDark, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('réponse type',
                      style: GoogleFonts.quicksand(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: AppColors.successDark.withValues(alpha: 0.8),
                        letterSpacing: 1.5,
                      )),
                  const SizedBox(height: 4),
                  Text(q.modelAnswer!,
                      style: GoogleFonts.quicksand(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.successDark,
                        height: 1.4,
                      )),
                ],
              ),
            ),
          // Auto-évaluation seulement si pas encore évalué
          if (_wasCorrect == null) ...<Widget>[
            const SizedBox(height: 10),
            Text('— ta réponse était… —',
                textAlign: TextAlign.center,
                style: AppText.subtitle.copyWith(fontSize: 12)),
            const SizedBox(height: 6),
            Row(
              children: <Widget>[
                Expanded(
                  child: _ActionBtn(
                    label: '✗ à revoir',
                    primary: false,
                    onTap: () => _selfMark(false),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ActionBtn(
                    label: '✓ j\'avais juste',
                    primary: true,
                    onTap: () => _selfMark(true),
                  ),
                ),
              ],
            ),
          ] else ...<Widget>[
            const SizedBox(height: 10),
            _ActionBtn(
              label: 'suivante →',
              primary: true,
              onTap: _next,
            ),
          ],
        ],
      ],
    );
  }

  /// Pour les questions ouvertes : verrouille et affiche la réponse type.
  /// L'évaluation (juste/à revoir) se fait par tap manuel ensuite.
  void _revealModelAnswer() {
    if (_locked || _sujet == null) return;
    HapticFeedback.lightImpact();
    setState(() {
      _locked = true;
      _wasCorrect = null; // sera défini par _selfMark
    });
  }

  void _selfMark(bool right) {
    if (_sujet == null) return;
    final BrevetQuestion q =
        _sujet!.exercises[_exoIdx].questions[_questIdx];
    HapticFeedback.lightImpact();
    AudioService.instance.play(right ? Sfx.correct : Sfx.wrong);
    setState(() {
      _wasCorrect = right;
      if (right) {
        _scoreByExo[_exoIdx] = (_scoreByExo[_exoIdx] ?? 0) + q.points;
        _correctQuestions++;
      }
    });
    _saveProgress();
  }

  Widget _buildFinished() {
    final BrevetSujet sujet = _sujet!;
    final int totalPts = sujet.totalPoints;
    final int score = _totalScore;
    final double note20 =
        totalPts == 0 ? 0 : (score / totalPts) * 20;
    final String mood = switch (note20) {
      >= 18 => '🏆 sans faute (ou presque) !',
      >= 14 => '✨ bien joué !',
      >= 10 => '🌷 admis',
      _ => '🌱 à retravailler',
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              PillButton(
                label: '← accueil',
                onTap: () =>
                    Navigator.of(context).popUntil((Route<dynamic> r) => r.isFirst),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(sujet.title, style: AppText.title),
          const SizedBox(height: 2),
          Text(mood, style: AppText.subtitle),
          const SizedBox(height: 22),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: ThemeService.instance.preset.statsGradient,
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  '${note20.toStringAsFixed(1)} / 20',
                  style: GoogleFonts.quicksand(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$score / $totalPts points',
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: sujet.exercises.length,
              separatorBuilder: (BuildContext _, int _) =>
                  const SizedBox(height: 8),
              itemBuilder: (BuildContext ctx, int i) {
                final BrevetExercise exo = sujet.exercises[i];
                final int got = _scoreByExo[i] ?? 0;
                final int max = exo.totalPoints;
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Bq.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Bq.accent.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          exo.title,
                          style: GoogleFonts.quicksand(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Bq.textOnBg,
                          ),
                        ),
                      ),
                      Text(
                        '$got / $max',
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: got == max
                              ? AppColors.successDark
                              : Bq.accent,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _ActionBtn(
                  label: '↻ rejouer',
                  primary: false,
                  onTap: () => setState(() => _phase = _Phase.picking),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionBtn(
                  label: 'accueil →',
                  primary: true,
                  onTap: () => Navigator.of(context)
                      .popUntil((Route<dynamic> r) => r.isFirst),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SujetTile extends StatelessWidget {
  const _SujetTile({
    required this.sujet,
    required this.unlocked,
    required this.userLevel,
    required this.onTap,
  });

  final BrevetSujet sujet;
  final bool unlocked;
  final int userLevel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: unlocked ? 1 : 0.55,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: ThemeService.instance.preset.cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Bq.cardBorder.withValues(alpha: 0.85),
                width: 2,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Bq.accent.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Bq.cardBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(sujet.emoji,
                      style: const TextStyle(fontSize: 28)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        sujet.title,
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Bq.textOnBg,
                        ),
                      ),
                      Text(
                        sujet.subtitle,
                        style: GoogleFonts.quicksand(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Bq.textOnBg.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${sujet.exercises.length} exercices · ${sujet.totalQuestions} questions · ${sujet.totalPoints} pts',
                        style: GoogleFonts.quicksand(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Bq.accent,
                        ),
                      ),
                      if (sujet.source != null) ...<Widget>[
                        const SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                '📎 ${sujet.source}',
                                style: GoogleFonts.quicksand(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Bq.textOnBg.withValues(alpha: 0.65),
                                ),
                              ),
                            ),
                            if (sujet.sourceUrl != null) ...<Widget>[
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () async {
                                  final Uri uri = Uri.parse(sujet.sourceUrl!);
                                  await launchUrl(uri,
                                      mode: LaunchMode.inAppBrowserView);
                                },
                                child: Text(
                                  '↗',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: Bq.accent,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (!unlocked)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Bq.cardBg,
                        shape: BoxShape.circle,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(Icons.lock, size: 14),
                          Text(
                            'N${sujet.unlockLevel}',
                            style: GoogleFonts.quicksand(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: Bq.textOnBg,
                            ),
                          ),
                        ],
                      ),
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
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
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
              Expanded(
                child: Text(
                  ok
                      ? 'ta réponse : $userAnswer ${unit.isNotEmpty ? unit : ''}'
                      : 'attendu : $expected ${unit.isNotEmpty ? unit : ''}',
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
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
            color: primary ? Bq.accent : Bq.cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Bq.accent, width: 1.5),
          ),
          child: Text(
            label,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: primary ? Colors.white : Bq.accent,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.selected,
    required this.correct,
    required this.wrong,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool correct;
  final bool wrong;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    Color border = Bq.accent.withValues(alpha: 0.4);
    if (correct) {
      bg = AppColors.success;
      fg = AppColors.successDark;
      border = AppColors.successDark;
    } else if (wrong) {
      bg = AppColors.danger;
      fg = Colors.white;
      border = AppColors.danger;
    } else if (selected) {
      bg = Bq.accent;
      fg = Colors.white;
      border = Bq.accent;
    } else {
      bg = Bq.cardBg;
      fg = Bq.textOnBg;
    }
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border, width: 1.5),
          ),
          child: Text(
            label,
            style: GoogleFonts.quicksand(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: fg,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
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
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Bq.cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Bq.accent.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Row(
            children: <Widget>[
              Text(emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title,
                        style: GoogleFonts.quicksand(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Bq.textOnBg,
                        )),
                    Text(subtitle,
                        style: GoogleFonts.quicksand(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Bq.textOnBg.withValues(alpha: 0.7),
                        )),
                  ],
                ),
              ),
              Text('→',
                  style: GoogleFonts.quicksand(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Bq.accent,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
