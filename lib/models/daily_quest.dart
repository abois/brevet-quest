import 'dart:math';

import '../data/subjects_data.dart';

enum QuestKind {
  answerCorrect,
  answerSubject,
  playGame,
}

enum GameId {
  qcm,
  trueFalse,
  calc,
  memory,
  survival,
  timeline,
  dictee,
  sort,
  intrus,
  pendu,
}

extension GameIdX on GameId {
  String get id => switch (this) {
        GameId.qcm => 'qcm',
        GameId.trueFalse => 'true-false',
        GameId.calc => 'calc',
        GameId.memory => 'memory',
        GameId.survival => 'survival',
        GameId.timeline => 'timeline',
        GameId.dictee => 'dictee',
        GameId.sort => 'sort',
        GameId.intrus => 'intrus',
        GameId.pendu => 'pendu',
      };

  String get label => switch (this) {
        GameId.qcm => 'QCM Flash',
        GameId.trueFalse => 'Vrai / Faux',
        GameId.calc => 'Calcul Mental',
        GameId.memory => 'Memory',
        GameId.survival => 'Élimination',
        GameId.timeline => 'Frise',
        GameId.dictee => 'Dictée',
        GameId.sort => 'Tri',
        GameId.intrus => 'L\'intrus',
        GameId.pendu => 'Pendu',
      };

  String get emoji => switch (this) {
        GameId.qcm => '⚡',
        GameId.trueFalse => '👉',
        GameId.calc => '🧮',
        GameId.memory => '🎴',
        GameId.survival => '💀',
        GameId.timeline => '⏰',
        GameId.dictee => '🎧',
        GameId.sort => '🗂️',
        GameId.intrus => '🎭',
        GameId.pendu => '🪢',
      };
}

class DailyQuest {
  const DailyQuest({
    required this.id,
    required this.kind,
    required this.label,
    required this.target,
    required this.emoji,
    required this.xpReward,
    this.subjectId,
    this.gameId,
  });

  final String id;
  final QuestKind kind;
  final String label;
  final int target;
  final String emoji;
  final int xpReward;
  final String? subjectId;
  final String? gameId;
}

/// Génération déterministe des 3 quêtes du jour à partir de la date.
List<DailyQuest> generateDailyQuests(DateTime day) {
  final int seed = day.year * 10000 + day.month * 100 + day.day;
  final Random rng = Random(seed);

  // 1) Quête "X bonnes réponses au total"
  final int targetTotal = <int>[10, 15, 20, 25][rng.nextInt(4)];
  final DailyQuest q1 = DailyQuest(
    id: 'qd-total-$seed',
    kind: QuestKind.answerCorrect,
    label: '$targetTotal bonnes réponses',
    target: targetTotal,
    emoji: '🎯',
    xpReward: 40,
  );

  // 2) Quête matière au hasard
  final subject = SubjectsData.all[rng.nextInt(SubjectsData.all.length)];
  final int targetSubject = <int>[5, 8, 10][rng.nextInt(3)];
  final DailyQuest q2 = DailyQuest(
    id: 'qd-subj-${subject.id}-$seed',
    kind: QuestKind.answerSubject,
    label: '$targetSubject bonnes en ${subject.shortName}',
    target: targetSubject,
    emoji: subject.emoji,
    xpReward: 50,
    subjectId: subject.id,
  );

  // 3) Quête mini-jeu
  final List<GameId> games = GameId.values;
  final GameId game = games[rng.nextInt(games.length)];
  final DailyQuest q3 = DailyQuest(
    id: 'qd-game-${game.id}-$seed',
    kind: QuestKind.playGame,
    label: '1 partie de ${game.label}',
    target: 1,
    emoji: game.emoji,
    xpReward: 30,
    gameId: game.id,
  );

  return <DailyQuest>[q1, q2, q3];
}
