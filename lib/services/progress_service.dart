import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/daily_quest.dart';
import '../models/user_progress.dart';

/// Définition d'un badge déblocable.
class BadgeDef {
  const BadgeDef({
    required this.id,
    required this.label,
    required this.emoji,
    required this.condition,
  });

  final String id;
  final String label;
  final String emoji;
  final bool Function(UserProgress) condition;
}

/// Résultat d'une session de mini-jeu — entrée du service.
class SessionResult {
  const SessionResult({
    required this.subjectId,
    required this.answered,
    required this.correct,
    required this.gameId,
    this.xpMultiplier = 1,
  });

  final String? subjectId;
  final int answered;
  final int correct;

  /// Identifiant du mini-jeu (ex. 'qcm', 'memory'…).
  final String gameId;

  /// Multiplicateur XP appliqué au gain de base (1 par défaut, 3 pour boss).
  final int xpMultiplier;
}

/// Service singleton de progression utilisateur.
class ProgressService extends ChangeNotifier {
  ProgressService._();

  static final ProgressService instance = ProgressService._();

  static const String _kKey = 'user_progress_v1';

  static const int xpPerCorrect = 10;
  static const int xpStreakBonus = 2;

  /// Un jeton freeze offert tous les N jours de streak atteints.
  static const int freezeEveryNDays = 7;

  UserProgress _progress = UserProgress();
  bool _loaded = false;

  UserProgress get progress => _progress;
  bool get isLoaded => _loaded;

  /// Quêtes du jour courant — recalculées si la date a changé.
  List<DailyQuest> get todaysQuests => generateDailyQuests(DateTime.now());

  static final List<BadgeDef> badgeDefs = <BadgeDef>[
    BadgeDef(
      id: 'first-steps',
      label: 'Premiers pas',
      emoji: '🌱',
      condition: (UserProgress p) => p.totalAnswered >= 1,
    ),
    BadgeDef(
      id: 'curious',
      label: 'Curieux',
      emoji: '🔎',
      condition: (UserProgress p) => p.totalAnswered >= 25,
    ),
    BadgeDef(
      id: 'studious',
      label: 'Studieux',
      emoji: '📚',
      condition: (UserProgress p) => p.totalAnswered >= 100,
    ),
    BadgeDef(
      id: 'sharp',
      label: 'Affûté',
      emoji: '⚡',
      condition: (UserProgress p) => p.totalCorrect >= 50,
    ),
    BadgeDef(
      id: 'streak-3',
      label: '3 jours d\'affilée',
      emoji: '🔥',
      condition: (UserProgress p) => p.streakDays >= 3,
    ),
    BadgeDef(
      id: 'streak-7',
      label: '7 jours d\'affilée',
      emoji: '✨',
      condition: (UserProgress p) => p.streakDays >= 7,
    ),
    BadgeDef(
      id: 'level-5',
      label: 'Niveau 5',
      emoji: '🏆',
      condition: (UserProgress p) => p.level >= 5,
    ),
    BadgeDef(
      id: 'level-10',
      label: 'Niveau 10',
      emoji: '💎',
      condition: (UserProgress p) => p.level >= 10,
    ),
  ];

  static BadgeDef? badgeById(String id) {
    for (final BadgeDef b in badgeDefs) {
      if (b.id == id) return b;
    }
    return null;
  }

  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_kKey);
    if (raw != null) {
      try {
        _progress = UserProgress.fromJson(
          json.decode(raw) as Map<String, dynamic>,
        );
      } catch (_) {
        _progress = UserProgress();
      }
    }
    _ensureFreshDailyQuests();
    _loaded = true;
    notifyListeners();
  }

  /// Reset les quêtes si la date a changé depuis la dernière session.
  void _ensureFreshDailyQuests() {
    final String today = _today();
    if (_progress.dailyQuestsDate != today) {
      _progress.dailyQuestsDate = today;
      _progress.questsProgress.clear();
      _progress.questsCompleted.clear();
      _progress.questsClaimed.clear();
    }
  }

  Future<void> _save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, json.encode(_progress.toJson()));
  }

  /// Enregistre le résultat d'une session : XP + streak + badges + quêtes.
  Future<SessionRecordResult> recordSession(SessionResult r) async {
    final UserProgress p = _progress;
    _ensureFreshDailyQuests();

    p.totalAnswered += r.answered;
    p.totalCorrect += r.correct;

    // XP de base (avec multiplicateur — boss = ×3)
    final int rawXp = r.correct * xpPerCorrect +
        (r.correct >= 5 ? xpStreakBonus * r.correct : 0);
    final int baseXp = rawXp * r.xpMultiplier;
    p.xp += baseXp;
    if (r.subjectId != null) {
      p.xpBySubject[r.subjectId!] =
          (p.xpBySubject[r.subjectId!] ?? 0) + baseXp;
    }

    // Streak quotidien (avec freezes)
    final int levelBefore = p.level;
    final int streakBefore = p.streakDays;
    final String today = _today();
    final String? last = p.lastPlayedIso;
    if (last == null) {
      p.streakDays = 1;
    } else if (last == today) {
      // déjà joué aujourd'hui — streak inchangé
    } else if (last == _yesterday()) {
      p.streakDays += 1;
    } else if (p.streakFreezes > 0) {
      // Trou de plusieurs jours — on consomme un freeze pour ne pas tout perdre
      p.streakFreezes -= 1;
      p.streakDays += 1;
    } else {
      p.streakDays = 1;
    }
    p.lastPlayedIso = today;

    // Bonus freeze tous les N jours franchis
    if (p.streakDays > streakBefore &&
        p.streakDays % freezeEveryNDays == 0) {
      p.streakFreezes += 1;
    }

    // Quêtes journalières — progression
    final int questBonus = _updateQuests(r);
    p.xp += questBonus;

    // Badges
    final List<BadgeDef> newlyUnlocked = <BadgeDef>[];
    for (final BadgeDef b in badgeDefs) {
      if (!p.badges.contains(b.id) && b.condition(p)) {
        p.badges.add(b.id);
        newlyUnlocked.add(b);
      }
    }

    final int levelAfter = p.level;
    final bool leveledUp = levelAfter > levelBefore;

    await _save();
    notifyListeners();

    return SessionRecordResult(
      xpGained: baseXp + questBonus,
      questXpBonus: questBonus,
      leveledUp: leveledUp,
      newLevel: levelAfter,
      newBadges: newlyUnlocked,
      newlyCompletedQuests: _justCompleted,
    );
  }

  List<DailyQuest> _justCompleted = <DailyQuest>[];

  /// Met à jour la progression des quêtes du jour, retourne l'XP bonus
  /// gagnée par les quêtes nouvellement complétées.
  int _updateQuests(SessionResult r) {
    final UserProgress p = _progress;
    final List<DailyQuest> quests = todaysQuests;
    int bonus = 0;
    final List<DailyQuest> justDone = <DailyQuest>[];

    for (final DailyQuest q in quests) {
      if (p.questsClaimed.contains(q.id)) continue;
      final int before = p.questsProgress[q.id] ?? 0;
      int delta = 0;
      switch (q.kind) {
        case QuestKind.answerCorrect:
          delta = r.correct;
          break;
        case QuestKind.answerSubject:
          if (r.subjectId == q.subjectId) delta = r.correct;
          break;
        case QuestKind.playGame:
          if (r.gameId == q.gameId && r.answered > 0) delta = 1;
          break;
      }
      if (delta == 0) continue;
      final int after = before + delta;
      p.questsProgress[q.id] = after;
      if (before < q.target && after >= q.target) {
        p.questsCompleted.add(q.id);
        p.questsClaimed.add(q.id);
        bonus += q.xpReward;
        justDone.add(q);
      }
    }

    _justCompleted = justDone;
    return bonus;
  }

  Future<void> reset() async {
    _progress = UserProgress();
    _ensureFreshDailyQuests();
    await _save();
    notifyListeners();
  }

  /// IDs des items déjà servis pour un pool (mini-jeu) donné.
  Set<String> seenItems(String poolId) =>
      _progress.seenItems[poolId] ?? <String>{};

  /// Pioche `count` items du pool en évitant ceux déjà vus.
  /// Recycle (réinitialise le tracking de ce pool) si le pool est épuisé.
  /// Retourne la liste tirée (et marque les items comme vus en SharedPrefs).
  Future<List<T>> pickUnseen<T>({
    required String poolId,
    required List<T> pool,
    required String Function(T) idOf,
    required int count,
  }) async {
    final Set<String> seen = Set<String>.of(seenItems(poolId));
    List<T> remaining = pool.where((T it) => !seen.contains(idOf(it))).toList();
    if (remaining.length < count) {
      // Pool épuisé pour ce niveau de difficulté → on recycle.
      seen.clear();
      remaining = List<T>.of(pool);
    }
    remaining.shuffle();
    final List<T> picked = remaining.take(count).toList();
    seen.addAll(picked.map(idOf));
    _progress.seenItems[poolId] = seen;
    await _save();
    return picked;
  }

  static String _today() {
    final DateTime n = DateTime.now();
    return _iso(n);
  }

  static String _yesterday() {
    final DateTime n = DateTime.now().subtract(const Duration(days: 1));
    return _iso(n);
  }

  static String _iso(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }
}

class SessionRecordResult {
  const SessionRecordResult({
    required this.xpGained,
    required this.questXpBonus,
    required this.leveledUp,
    required this.newLevel,
    required this.newBadges,
    required this.newlyCompletedQuests,
  });

  final int xpGained;
  final int questXpBonus;
  final bool leveledUp;
  final int newLevel;
  final List<BadgeDef> newBadges;
  final List<DailyQuest> newlyCompletedQuests;
}
