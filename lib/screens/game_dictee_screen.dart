import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/dictee_data.dart';
import '../models/daily_quest.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import '../services/theme_service.dart';
import '../theme/app_theme.dart';
import '../theme/bq_colors.dart';
import '../widgets/pill_button.dart';
import 'result_screen.dart';

/// Dictée : 6 phrases tirées au hasard, 2 écoutes max par phrase,
/// validation stricte (espaces normalisés mais accents/ponctuation respectés).
class GameDicteeScreen extends StatefulWidget {
  const GameDicteeScreen({
    super.key,
    this.itemCount = 6,
    this.maxPlays = 2,
  });

  final int itemCount;
  final int maxPlays;

  @override
  State<GameDicteeScreen> createState() => _GameDicteeScreenState();
}

class _GameDicteeScreenState extends State<GameDicteeScreen> {
  List<DicteeItem>? _items;
  int _idx = 0;
  int _correct = 0;
  int _playsLeft = 0;
  bool _isPlaying = false;
  bool _audioMissing = false;
  bool _checked = false;
  bool _wasCorrect = false;
  String _typed = '';

  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focus = FocusNode();
  final AudioPlayer _player = AudioPlayer(playerId: 'dictee-player');

  StreamSubscription<void>? _completeSub;

  @override
  void initState() {
    super.initState();
    _setupItems();
    _playsLeft = widget.maxPlays;
    _completeSub = _player.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() => _isPlaying = false);
      AudioService.instance.resumeMusic();
      _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _completeSub?.cancel();
    _player.dispose();
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _setupItems() async {
    final List<DicteeItem> picked =
        await ProgressService.instance.pickUnseen<DicteeItem>(
      poolId: 'dictee',
      pool: DicteeData.all,
      idOf: (DicteeItem it) => it.id,
      count: widget.itemCount.clamp(1, DicteeData.all.length),
    );
    if (!mounted) return;
    setState(() => _items = picked);
  }

  Future<void> _play() async {
    if (_items == null || _isPlaying || _playsLeft <= 0 || _checked) return;
    HapticFeedback.selectionClick();
    AudioService.instance.play(Sfx.tap);
    final DicteeItem item = _items![_idx];
    try {
      await AudioService.instance.pauseMusic();
      await _player.stop();
      await _player.play(AssetSource(item.assetPath), volume: 1.0);
      setState(() {
        _isPlaying = true;
        _playsLeft -= 1;
        _audioMissing = false;
      });
    } catch (e) {
      setState(() => _audioMissing = true);
    }
  }

  bool _isExactMatch(String typed, String correct) {
    final RegExp ws = RegExp(r'\s+');
    final String t = typed.replaceAll(ws, ' ').trim();
    final String c = correct.replaceAll(ws, ' ').trim();
    return t == c;
  }

  void _validate() {
    if (_items == null) return;
    if (_checked) {
      _next();
      return;
    }
    final DicteeItem item = _items![_idx];
    final bool ok = _isExactMatch(_ctrl.text, item.text);
    HapticFeedback.lightImpact();
    AudioService.instance.play(ok ? Sfx.correct : Sfx.wrong);
    setState(() {
      _typed = _ctrl.text;
      _wasCorrect = ok;
      _checked = true;
      if (ok) _correct++;
    });
  }

  void _next() {
    if (_items == null) return;
    if (_idx + 1 >= _items!.length) {
      _finish();
      return;
    }
    setState(() {
      _idx++;
      _playsLeft = widget.maxPlays;
      _checked = false;
      _wasCorrect = false;
      _typed = '';
      _audioMissing = false;
      _ctrl.clear();
    });
  }

  Future<void> _finish() async {
    await _player.stop();
    final int answered = _items?.length ?? 0;
    final SessionRecordResult record =
        await ProgressService.instance.recordSession(
      SessionResult(
        subjectId: 'francais',
        answered: answered,
        correct: _correct,
        gameId: GameId.dictee.id,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext resultCtx) => ResultScreen(
          title: 'Dictée',
          correct: _correct,
          answered: answered,
          record: record,
          onReplay: () {
            Navigator.of(resultCtx).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => const GameDicteeScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_items == null) {
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
    final DicteeItem item = _items![_idx];
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration:
            BoxDecoration(gradient: ThemeService.instance.preset.bgGradient),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${_idx + 1} / ${_items!.length}',
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
                Text('dictée 🎧', style: AppText.title),
                const SizedBox(height: 4),
                Text(
                  _checked
                      ? (_wasCorrect ? 'sans faute ✓' : 'compare bien…')
                      : 'écoute attentivement et tape ce que tu entends',
                  style: AppText.subtitle,
                ),
                const SizedBox(height: 18),
                _PlayBox(
                  isPlaying: _isPlaying,
                  playsLeft: _playsLeft,
                  maxPlays: widget.maxPlays,
                  audioMissing: _audioMissing,
                  disabled: _checked,
                  onTap: _play,
                ),
                const SizedBox(height: 16),
                if (_checked)
                  _DiffBlock(
                    typed: _typed,
                    correct: item.text,
                    wasCorrect: _wasCorrect,
                  )
                else
                  _Input(controller: _ctrl, focus: _focus),
                const Spacer(),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: _validate,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Bq.accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _checked
                            ? (_idx + 1 >= _items!.length
                                ? 'voir le résultat →'
                                : 'phrase suivante →')
                            : 'valider',
                        style: GoogleFonts.quicksand(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
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

class _PlayBox extends StatelessWidget {
  const _PlayBox({
    required this.isPlaying,
    required this.playsLeft,
    required this.maxPlays,
    required this.audioMissing,
    required this.disabled,
    required this.onTap,
  });

  final bool isPlaying;
  final int playsLeft;
  final int maxPlays;
  final bool audioMissing;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool canPlay = !disabled && playsLeft > 0 && !isPlaying;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: canPlay ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: canPlay
                  ? AppColors.violet
                  : Bq.accent.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Bq.accent.withValues(alpha: 0.18),
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
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: canPlay
                      ? AppColors.violet
                      : Bq.accent.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPlaying ? Icons.volume_up : Icons.play_arrow,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      isPlaying
                          ? 'en cours…'
                          : (audioMissing
                              ? 'audio non disponible'
                              : (playsLeft > 0
                                  ? 'écouter la phrase'
                                  : 'plus d\'écoutes')),
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Bq.textOnBg,
                      ),
                    ),
                    Text(
                      audioMissing
                          ? 'lance generate_dictee.py pour générer les MP3'
                          : '$playsLeft / $maxPlays écoutes restantes',
                      style: GoogleFonts.quicksand(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Bq.textOnBg.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              for (int i = 0; i < maxPlays; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i < playsLeft
                          ? AppColors.violet
                          : Bq.accent.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
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

class _Input extends StatelessWidget {
  const _Input({required this.controller, required this.focus});

  final TextEditingController controller;
  final FocusNode focus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focus,
      autofocus: true,
      maxLines: 3,
      textInputAction: TextInputAction.done,
      style: GoogleFonts.quicksand(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Bq.textOnBg,
        height: 1.4,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.95),
        hintText: 'tape la phrase ici…',
        hintStyle: GoogleFonts.quicksand(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Bq.textOnBg.withValues(alpha: 0.4),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(14),
      ),
    );
  }
}

class _DiffBlock extends StatelessWidget {
  const _DiffBlock({
    required this.typed,
    required this.correct,
    required this.wasCorrect,
  });

  final String typed;
  final String correct;
  final bool wasCorrect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _DiffCard(
          label: 'tu as écrit',
          text: typed.isEmpty ? '(vide)' : typed,
          good: wasCorrect,
        ),
        const SizedBox(height: 10),
        _DiffCard(
          label: 'phrase correcte',
          text: correct,
          good: true,
          highlight: true,
        ),
      ],
    );
  }
}

class _DiffCard extends StatelessWidget {
  const _DiffCard({
    required this.label,
    required this.text,
    required this.good,
    this.highlight = false,
  });

  final String label;
  final String text;
  final bool good;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final Color bg = highlight
        ? AppColors.success
        : (good ? AppColors.success : AppColors.danger.withValues(alpha: 0.85));
    final Color fg = highlight
        ? AppColors.successDark
        : (good ? AppColors.successDark : Colors.white);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlight ? AppColors.successDark : Colors.white,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: GoogleFonts.quicksand(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: fg.withValues(alpha: 0.8),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: fg,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
