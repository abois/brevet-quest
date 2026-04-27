import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/memory_pairs.dart';
import '../models/daily_quest.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import '../services/theme_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pill_button.dart';
import 'result_screen.dart';

/// Memory : 8 paires (16 cartes), trouve toutes les paires.
class GameMemoryScreen extends StatefulWidget {
  const GameMemoryScreen({super.key});

  @override
  State<GameMemoryScreen> createState() => _GameMemoryScreenState();
}

class _Card {
  _Card({required this.id, required this.text, required this.pairId});
  final int id;
  final String text;
  final int pairId;
  bool revealed = false;
  bool matched = false;
}

class _GameMemoryScreenState extends State<GameMemoryScreen> {
  List<_Card>? _cards;
  String? _deckName;
  String? _deckEmoji;
  String? _subjectId;

  int _attempts = 0;
  int _matches = 0;
  int? _firstFlipped;
  bool _busy = false;
  Timer? _flipBack;
  late DateTime _start;

  @override
  void initState() {
    super.initState();
    _start = DateTime.now();
    _setupDeck();
  }

  @override
  void dispose() {
    _flipBack?.cancel();
    super.dispose();
  }

  Future<void> _setupDeck() async {
    final Random rng = Random();
    final int idx = rng.nextInt(MemoryDecks.all.length);
    final String deckName = MemoryDecks.deckNames[idx];
    final List<MemoryPair> selected =
        await ProgressService.instance.pickUnseen<MemoryPair>(
      poolId: 'memory-$deckName',
      pool: MemoryDecks.all[idx],
      idOf: (MemoryPair p) => p.id,
      count: 8.clamp(1, MemoryDecks.all[idx].length),
    );
    if (!mounted) return;
    final List<_Card> cards = <_Card>[];
    for (int i = 0; i < selected.length; i++) {
      cards.add(_Card(id: i * 2, text: selected[i].left, pairId: i));
      cards.add(_Card(id: i * 2 + 1, text: selected[i].right, pairId: i));
    }
    cards.shuffle(rng);
    setState(() {
      _deckName = deckName;
      _deckEmoji = MemoryDecks.deckEmojis[idx];
      _subjectId = switch (deckName) {
        'capitales' || 'histoire' => 'histoire-geo',
        'auteurs' => 'francais',
        'anglais' => 'anglais',
        'maths' => 'maths',
        _ => 'histoire-geo',
      };
      _cards = cards;
    });
  }

  void _onTap(int index) {
    if (_busy || _cards == null) return;
    final _Card c = _cards![index];
    if (c.revealed || c.matched) return;
    HapticFeedback.selectionClick();
    AudioService.instance.play(Sfx.tap);
    setState(() => c.revealed = true);

    if (_firstFlipped == null) {
      _firstFlipped = index;
      return;
    }

    final _Card a = _cards![_firstFlipped!];
    final _Card b = c;
    _attempts++;
    if (a.pairId == b.pairId) {
      setState(() {
        a.matched = true;
        b.matched = true;
        _matches++;
        _firstFlipped = null;
      });
      HapticFeedback.lightImpact();
      AudioService.instance.play(Sfx.correct);
      final int pairsCount = (_cards!.length / 2).floor();
      if (_matches >= pairsCount) _finish();
    } else {
      _busy = true;
      _flipBack = Timer(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() {
          a.revealed = false;
          b.revealed = false;
          _firstFlipped = null;
          _busy = false;
        });
      });
    }
  }

  Future<void> _finish() async {
    final Duration elapsed = DateTime.now().difference(_start);
    final SessionRecordResult record =
        await ProgressService.instance.recordSession(
      SessionResult(
        subjectId: _subjectId,
        answered: _attempts,
        correct: _matches,
        gameId: GameId.memory.id,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext resultCtx) => ResultScreen(
          title: 'Memory · $_deckName ${_elapsedLabel(elapsed)}',
          correct: _matches,
          answered: _attempts,
          record: record,
          onReplay: () {
            Navigator.of(resultCtx).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => const GameMemoryScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  String _elapsedLabel(Duration d) {
    final int s = d.inSeconds;
    return '· ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    if (_cards == null) {
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
    return Scaffold(
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
                        color: Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(_deckEmoji ?? '',
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            _deckName ?? '',
                            style: GoogleFonts.quicksand(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: AppColors.violet,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '$_matches / ${(_cards!.length / 2).floor()}',
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
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: _cards!.length,
                    itemBuilder: (BuildContext ctx, int i) {
                      return _MemoryTile(
                        key: ValueKey<int>(_cards![i].id),
                        card: _cards![i],
                        onTap: () => _onTap(i),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$_attempts essais',
                  style: AppText.subtitle.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MemoryTile extends StatelessWidget {
  const _MemoryTile({super.key, required this.card, required this.onTap});

  final _Card card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool front = card.revealed || card.matched;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: card.matched ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: front
                  ? <Color>[
                      Colors.white,
                      card.matched
                          ? AppColors.success
                          : AppColors.lavender100,
                    ]
                  : const <Color>[
                      AppColors.lavender300,
                      AppColors.lavender400,
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: card.matched
                  ? AppColors.successDark
                  : Colors.white.withValues(alpha: 0.85),
              width: 2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.violet.withValues(alpha: 0.18),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(6),
          child: front
              ? Text(
                  card.text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: AppColors.plumDark,
                  ),
                )
              : const Text(
                  '✦',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
        ),
      ),
    );
  }
}
