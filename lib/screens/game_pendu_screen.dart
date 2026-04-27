import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/pendu_words.dart';
import '../models/daily_quest.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import '../services/theme_service.dart';
import '../theme/app_theme.dart';
import '../theme/bq_colors.dart';
import '../widgets/pill_button.dart';
import 'result_screen.dart';

/// Pendu : 3 mots, 6 erreurs max chacun, clavier AZERTY.
class GamePenduScreen extends StatefulWidget {
  const GamePenduScreen({super.key, this.wordCount = 3, this.maxErrors = 6});

  final int wordCount;
  final int maxErrors;

  @override
  State<GamePenduScreen> createState() => _GamePenduScreenState();
}

class _GamePenduScreenState extends State<GamePenduScreen> {
  List<PenduWord>? _words;
  int _idx = 0;
  int _correct = 0;
  final Set<String> _guessed = <String>{};
  int _errors = 0;
  bool _gameOver = false;

  static const List<List<String>> _azerty = <List<String>>[
    <String>['A', 'Z', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    <String>['Q', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'M'],
    <String>['W', 'X', 'C', 'V', 'B', 'N'],
  ];

  @override
  void initState() {
    super.initState();
    _setupWords();
  }

  Future<void> _setupWords() async {
    final List<PenduWord> picked =
        await ProgressService.instance.pickUnseen<PenduWord>(
      poolId: 'pendu',
      pool: PenduWords.all,
      idOf: (PenduWord w) => w.id,
      count: widget.wordCount.clamp(1, PenduWords.all.length),
    );
    if (!mounted) return;
    setState(() => _words = picked);
  }

  PenduWord get _current => _words![_idx];
  Set<String> get _wordLetters => _current.word.split('').toSet();
  bool get _isWon =>
      _wordLetters.every((String l) => _guessed.contains(l));

  void _onLetter(String letter) {
    if (_words == null || _gameOver || _guessed.contains(letter)) return;
    HapticFeedback.selectionClick();
    final bool inWord = _current.word.contains(letter);
    AudioService.instance.play(inWord ? Sfx.tap : Sfx.wrong);
    setState(() {
      _guessed.add(letter);
      if (!inWord) _errors++;
    });
    if (_isWon) {
      AudioService.instance.play(Sfx.correct);
      _correct++;
      _gameOver = true;
      Future<void>.delayed(const Duration(milliseconds: 1100), _next);
    } else if (_errors >= widget.maxErrors) {
      _gameOver = true;
      Future<void>.delayed(const Duration(milliseconds: 1300), _next);
    }
  }

  void _next() {
    if (!mounted || _words == null) return;
    if (_idx + 1 >= _words!.length) {
      _finish();
      return;
    }
    setState(() {
      _idx++;
      _guessed.clear();
      _errors = 0;
      _gameOver = false;
    });
  }

  Future<void> _finish() async {
    final int answered = _words?.length ?? 0;
    final SessionRecordResult record =
        await ProgressService.instance.recordSession(
      SessionResult(
        subjectId: null,
        answered: answered,
        correct: _correct,
        gameId: GameId.pendu.id,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext resultCtx) => ResultScreen(
          title: 'Pendu',
          correct: _correct,
          answered: answered,
          record: record,
          onReplay: () {
            Navigator.of(resultCtx).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => const GamePenduScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_words == null) {
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
    final PenduWord w = _current;
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
                        '${_idx + 1} / ${_words!.length}  ·  $_correct ✓',
                        style: GoogleFonts.quicksand(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Bq.accent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text('pendu 🪢', style: AppText.title),
                const SizedBox(height: 4),
                Text(w.hint, style: AppText.subtitle),
                const SizedBox(height: 18),
                _ErrorsBar(
                  errors: _errors,
                  max: widget.maxErrors,
                ),
                const SizedBox(height: 12),
                _WordDisplay(
                  word: w.word,
                  guessed: _guessed,
                  reveal: _gameOver && !_isWon,
                ),
                if (_gameOver) ...<Widget>[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: _isWon
                          ? AppColors.success
                          : AppColors.danger.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      _isWon ? '✓ trouvé !' : '✗ raté · le mot était ${w.word}',
                      style: GoogleFonts.quicksand(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: _isWon
                            ? AppColors.successDark
                            : Colors.white,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                _Keyboard(
                  guessed: _guessed,
                  word: w.word,
                  enabled: !_gameOver,
                  onLetter: _onLetter,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorsBar extends StatelessWidget {
  const _ErrorsBar({required this.errors, required this.max});

  final int errors;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < max; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: i < errors
                    ? AppColors.danger
                    : Colors.white.withValues(alpha: 0.6),
                shape: BoxShape.circle,
                border: Border.all(
                  color: i < errors ? AppColors.danger : AppColors.violet,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: i < errors
                  ? const Text('×',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))
                  : null,
            ),
          ),
      ],
    );
  }
}

class _WordDisplay extends StatelessWidget {
  const _WordDisplay({
    required this.word,
    required this.guessed,
    required this.reveal,
  });

  final String word;
  final Set<String> guessed;
  final bool reveal;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: <Widget>[
        for (final String letter in word.split(''))
          Container(
            width: 32,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Bq.accent.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Text(
              guessed.contains(letter) || reveal ? letter : '_',
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: reveal && !guessed.contains(letter)
                    ? AppColors.danger
                    : Bq.textOnBg,
              ),
            ),
          ),
      ],
    );
  }
}

class _Keyboard extends StatelessWidget {
  const _Keyboard({
    required this.guessed,
    required this.word,
    required this.enabled,
    required this.onLetter,
  });

  final Set<String> guessed;
  final String word;
  final bool enabled;
  final ValueChanged<String> onLetter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (final List<String> row in _GamePenduScreenState._azerty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (final String letter in row)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: _Key(
                      letter: letter,
                      state: _stateOf(letter),
                      enabled: enabled && !guessed.contains(letter),
                      onTap: () => onLetter(letter),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  _KeyState _stateOf(String letter) {
    if (!guessed.contains(letter)) return _KeyState.idle;
    return word.contains(letter) ? _KeyState.hit : _KeyState.miss;
  }
}

enum _KeyState { idle, hit, miss }

class _Key extends StatelessWidget {
  const _Key({
    required this.letter,
    required this.state,
    required this.enabled,
    required this.onTap,
  });

  final String letter;
  final _KeyState state;
  final bool enabled;
  final VoidCallback onTap;

  Color _bg() {
    switch (state) {
      case _KeyState.idle:
        return Colors.white.withValues(alpha: 0.95);
      case _KeyState.hit:
        return AppColors.success;
      case _KeyState.miss:
        return AppColors.danger.withValues(alpha: 0.85);
    }
  }

  Color _fg() {
    switch (state) {
      case _KeyState.idle:
        return Bq.textOnBg;
      case _KeyState.hit:
        return AppColors.successDark;
      case _KeyState.miss:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: enabled ? onTap : null,
        child: Container(
          width: 30,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _bg(),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Bq.accent.withValues(alpha: 0.25),
              width: 1.2,
            ),
          ),
          child: Text(
            letter,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: _fg(),
            ),
          ),
        ),
      ),
    );
  }
}
