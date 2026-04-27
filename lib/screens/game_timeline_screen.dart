import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/timeline_decks.dart';
import '../models/daily_quest.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import '../services/theme_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pill_button.dart';
import 'result_screen.dart';

/// Frise chronologique : 5 événements à remettre dans l'ordre par drag & drop.
class GameTimelineScreen extends StatefulWidget {
  const GameTimelineScreen({super.key});

  @override
  State<GameTimelineScreen> createState() => _GameTimelineScreenState();
}

class _GameTimelineScreenState extends State<GameTimelineScreen> {
  late TimelineDeck _deck;
  late List<TimelineEvent> _ordered;
  bool _checked = false;
  int _correctPositions = 0;

  @override
  void initState() {
    super.initState();
    _setupDeck();
  }

  void _setupDeck() {
    final Random rng = Random();
    _deck = TimelineDecks.all[rng.nextInt(TimelineDecks.all.length)];
    final List<TimelineEvent> shuffled = List<TimelineEvent>.of(_deck.events)
      ..shuffle(rng);
    _ordered = shuffled;
    _checked = false;
    _correctPositions = 0;
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (_checked) return;
    HapticFeedback.selectionClick();
    AudioService.instance.play(Sfx.tap);
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final TimelineEvent item = _ordered.removeAt(oldIndex);
      _ordered.insert(newIndex, item);
    });
  }

  Future<void> _check() async {
    final List<TimelineEvent> sorted = List<TimelineEvent>.of(_deck.events)
      ..sort((TimelineEvent a, TimelineEvent b) => a.year.compareTo(b.year));
    int correct = 0;
    for (int i = 0; i < _ordered.length; i++) {
      if (_ordered[i].year == sorted[i].year) correct++;
    }
    HapticFeedback.mediumImpact();
    AudioService.instance.play(
      correct == _ordered.length ? Sfx.correct : Sfx.wrong,
    );
    setState(() {
      _checked = true;
      _correctPositions = correct;
    });
    final SessionRecordResult record =
        await ProgressService.instance.recordSession(
      SessionResult(
        subjectId: _deck.subjectId,
        answered: _ordered.length,
        correct: correct,
        gameId: GameId.timeline.id,
      ),
    );
    if (!mounted) return;
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(
          title: 'Frise · ${_deck.title}',
          correct: correct,
          answered: _ordered.length,
          record: record,
          onReplay: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => const GameTimelineScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  bool _isInRightPosition(int i) {
    if (!_checked) return false;
    final List<TimelineEvent> sorted = List<TimelineEvent>.of(_deck.events)
      ..sort((TimelineEvent a, TimelineEvent b) => a.year.compareTo(b.year));
    return _ordered[i].year == sorted[i].year;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            _deck.emoji,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _deck.title,
                            style: GoogleFonts.quicksand(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: AppColors.violet,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text('frise chronologique ⏰', style: AppText.title),
                const SizedBox(height: 4),
                Text(
                  _checked
                      ? '$_correctPositions / ${_ordered.length} bien placés'
                      : 'glisse pour ranger du + ancien au + récent',
                  style: AppText.subtitle,
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: ReorderableListView.builder(
                    physics: const BouncingScrollPhysics(),
                    proxyDecorator: (Widget child, int idx, _) =>
                        Material(
                      color: Colors.transparent,
                      child: child,
                    ),
                    itemCount: _ordered.length,
                    onReorder: _onReorder,
                    itemBuilder: (BuildContext ctx, int i) {
                      final TimelineEvent e = _ordered[i];
                      return _TimelineTile(
                        key: ValueKey<String>(
                            '${_deck.id}-${e.year}-${e.label}'),
                        index: i,
                        event: e,
                        revealed: _checked,
                        rightPosition: _isInRightPosition(i),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: _checked ? null : _check,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _checked
                            ? AppColors.glassSoft
                            : AppColors.violet,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _checked ? 'vérification…' : 'valider la frise',
                        style: GoogleFonts.quicksand(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: _checked
                              ? AppColors.plumDark
                              : Colors.white,
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

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    super.key,
    required this.index,
    required this.event,
    required this.revealed,
    required this.rightPosition,
  });

  final int index;
  final TimelineEvent event;
  final bool revealed;
  final bool rightPosition;

  Color _bg() {
    if (!revealed) return Colors.white.withValues(alpha: 0.95);
    return rightPosition
        ? AppColors.success
        : AppColors.danger.withValues(alpha: 0.85);
  }

  Color _border() {
    if (!revealed) return AppColors.violet.withValues(alpha: 0.3);
    return rightPosition ? AppColors.successDark : AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: _bg(),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border(), width: 2),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.violet.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
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
                '${index + 1}',
                style: GoogleFonts.quicksand(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: AppColors.violetDeep,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    event.label,
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: revealed
                          ? (rightPosition
                              ? AppColors.successDark
                              : Colors.white)
                          : AppColors.plumDark,
                    ),
                  ),
                  if (revealed)
                    Text(
                      '${event.year}',
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: rightPosition
                            ? AppColors.successDark
                            : Colors.white,
                      ),
                    ),
                ],
              ),
            ),
            if (revealed)
              Text(
                rightPosition ? '✓' : '✗',
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: rightPosition
                      ? AppColors.successDark
                      : Colors.white,
                ),
              )
            else
              const Icon(Icons.drag_handle,
                  size: 20, color: AppColors.violet),
          ],
        ),
      ),
    );
  }
}
