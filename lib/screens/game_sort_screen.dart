import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/sort_decks.dart';
import '../models/daily_quest.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import '../services/theme_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pill_button.dart';
import 'result_screen.dart';

/// Tri par catégories : drag & drop des items vers les bonnes colonnes.
class GameSortScreen extends StatefulWidget {
  const GameSortScreen({super.key});

  @override
  State<GameSortScreen> createState() => _GameSortScreenState();
}

class _GameSortScreenState extends State<GameSortScreen> {
  late SortDeck _deck;
  late List<SortItem> _bank;
  late List<List<SortItem>> _columns;

  @override
  void initState() {
    super.initState();
    _setupDeck();
  }

  void _setupDeck() {
    final Random rng = Random();
    _deck = SortDecks.all[rng.nextInt(SortDecks.all.length)];
    _bank = List<SortItem>.of(_deck.items)..shuffle(rng);
    _columns = List<List<SortItem>>.generate(
      _deck.categories.length,
      (_) => <SortItem>[],
    );
  }

  void _onDropToColumn(int columnIndex, SortItem item) {
    HapticFeedback.selectionClick();
    AudioService.instance.play(Sfx.tap);
    setState(() {
      _bank.remove(item);
      for (final List<SortItem> col in _columns) {
        col.remove(item);
      }
      _columns[columnIndex].add(item);
    });
  }

  void _onDropToBank(SortItem item) {
    HapticFeedback.selectionClick();
    setState(() {
      for (final List<SortItem> col in _columns) {
        col.remove(item);
      }
      if (!_bank.contains(item)) _bank.add(item);
    });
  }

  Future<void> _validate() async {
    if (_bank.isNotEmpty) return;
    int correct = 0;
    for (int i = 0; i < _columns.length; i++) {
      for (final SortItem it in _columns[i]) {
        if (it.categoryIndex == i) correct++;
      }
    }
    HapticFeedback.mediumImpact();
    AudioService.instance.play(
      correct == _deck.items.length ? Sfx.correct : Sfx.wrong,
    );
    final SessionRecordResult record =
        await ProgressService.instance.recordSession(
      SessionResult(
        subjectId: _deck.subjectId,
        answered: _deck.items.length,
        correct: correct,
        gameId: GameId.sort.id,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext resultCtx) => ResultScreen(
          title: 'Tri · ${_deck.title}',
          correct: correct,
          answered: _deck.items.length,
          record: record,
          onReplay: () {
            Navigator.of(resultCtx).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => const GameSortScreen(),
              ),
            );
          },
        ),
      ),
    );
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
                          Text(_deck.emoji,
                              style: const TextStyle(fontSize: 14)),
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
                Text('tri par catégories 🗂️',
                    style: AppText.title.copyWith(fontSize: 20)),
                const SizedBox(height: 4),
                Text(
                  'glisse les mots dans la bonne colonne',
                  style: AppText.subtitle,
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      for (int i = 0; i < _deck.categories.length; i++) ...<Widget>[
                        Expanded(
                          child: _CategoryColumn(
                            key: ValueKey<String>('col-$i'),
                            category: _deck.categories[i],
                            items: _columns[i],
                            onAccept: (SortItem it) => _onDropToColumn(i, it),
                          ),
                        ),
                        if (i < _deck.categories.length - 1)
                          const SizedBox(width: 6),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _Bank(
                  items: _bank,
                  onAccept: _onDropToBank,
                ),
                const SizedBox(height: 10),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: _bank.isEmpty ? _validate : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _bank.isEmpty
                            ? AppColors.violet
                            : AppColors.glassSoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _bank.isEmpty
                            ? 'valider'
                            : 'glisse encore ${_bank.length} item${_bank.length > 1 ? 's' : ''}',
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: _bank.isEmpty
                              ? Colors.white
                              : AppColors.plumDark,
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

class _CategoryColumn extends StatelessWidget {
  const _CategoryColumn({
    super.key,
    required this.category,
    required this.items,
    required this.onAccept,
  });

  final SortCategory category;
  final List<SortItem> items;
  final ValueChanged<SortItem> onAccept;

  @override
  Widget build(BuildContext context) {
    return DragTarget<SortItem>(
      onAcceptWithDetails: (DragTargetDetails<SortItem> d) =>
          onAccept(d.data),
      builder: (BuildContext ctx, List<SortItem?> candidates, List<dynamic> rejects) {
        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.violet.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.violet,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: <Widget>[
                    Text(category.emoji, style: const TextStyle(fontSize: 18)),
                    Text(
                      category.label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (BuildContext ctx, int i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: _DraggableChip(
                        key: ValueKey<String>('col-${items[i].label}'),
                        item: items[i],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Bank extends StatelessWidget {
  const _Bank({required this.items, required this.onAccept});

  final List<SortItem> items;
  final ValueChanged<SortItem> onAccept;

  @override
  Widget build(BuildContext context) {
    return DragTarget<SortItem>(
      onAcceptWithDetails: (DragTargetDetails<SortItem> d) =>
          onAccept(d.data),
      builder: (BuildContext ctx, List<SortItem?> candidates, List<dynamic> rejects) {
        return Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 64),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.violet.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: items.isEmpty
              ? Center(
                  child: Text(
                    'tout est rangé ✓',
                    style: GoogleFonts.quicksand(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.violet,
                    ),
                  ),
                )
              : Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: <Widget>[
                    for (final SortItem it in items)
                      _DraggableChip(
                        key: ValueKey<String>('bank-${it.label}'),
                        item: it,
                      ),
                  ],
                ),
        );
      },
    );
  }
}

class _DraggableChip extends StatelessWidget {
  const _DraggableChip({super.key, required this.item});

  final SortItem item;

  @override
  Widget build(BuildContext context) {
    final Widget chip = _Chip(label: item.label);
    return Draggable<SortItem>(
      data: item,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.05,
          child: _Chip(label: item.label, dragging: true),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: chip),
      child: chip,
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, this.dragging = false});

  final String label;
  final bool dragging;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: dragging ? AppColors.violet : AppColors.lavender100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: dragging ? AppColors.violetDeep : AppColors.violet,
          width: 1.5,
        ),
        boxShadow: dragging
            ? <BoxShadow>[
                BoxShadow(
                  color: AppColors.violet.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Text(
        label,
        style: GoogleFonts.quicksand(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: dragging ? Colors.white : AppColors.plumDark,
        ),
      ),
    );
  }
}
