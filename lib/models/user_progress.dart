/// Progression de l'utilisateur — XP, niveau, streak, badges, quêtes, freezes.
class UserProgress {
  UserProgress({
    this.xp = 0,
    this.totalAnswered = 0,
    this.totalCorrect = 0,
    this.streakDays = 0,
    this.streakFreezes = 0,
    this.lastPlayedIso,
    this.dailyQuestsDate,
    Set<String>? badges,
    Map<String, int>? xpBySubject,
    Map<String, int>? questsProgress,
    Set<String>? questsCompleted,
    Set<String>? questsClaimed,
    Map<String, Set<String>>? seenItems,
  })  : badges = badges ?? <String>{},
        xpBySubject = xpBySubject ?? <String, int>{},
        questsProgress = questsProgress ?? <String, int>{},
        questsCompleted = questsCompleted ?? <String>{},
        questsClaimed = questsClaimed ?? <String>{},
        seenItems = seenItems ?? <String, Set<String>>{};

  int xp;
  int totalAnswered;
  int totalCorrect;
  int streakDays;

  /// Jetons "freeze" qui consomment automatiquement quand on rate un jour.
  int streakFreezes;

  /// Date ISO yyyy-MM-dd de la dernière session.
  String? lastPlayedIso;

  /// Date des quêtes en cours (yyyy-MM-dd) — sert au reset quotidien.
  String? dailyQuestsDate;

  Set<String> badges;
  Map<String, int> xpBySubject;

  /// Progression par quête (id → valeur courante).
  Map<String, int> questsProgress;

  /// Quêtes du jour qui ont atteint leur objectif.
  Set<String> questsCompleted;

  /// Quêtes dont la récompense a été récupérée par le joueur.
  Set<String> questsClaimed;

  /// IDs des items déjà servis par pool (poolId -> set d'IDs).
  /// Permet de ne pas re-servir une question vue tant que la progression
  /// n'a pas été réinitialisée.
  Map<String, Set<String>> seenItems;

  /// Niveau dérivé de l'XP — palier doux : niveau N requiert N*100 XP.
  int get level {
    var n = 1;
    var threshold = 100;
    var remaining = xp;
    while (remaining >= threshold) {
      remaining -= threshold;
      n++;
      threshold = n * 100;
    }
    return n;
  }

  int get xpInLevel {
    var n = 1;
    var threshold = 100;
    var remaining = xp;
    while (remaining >= threshold) {
      remaining -= threshold;
      n++;
      threshold = n * 100;
    }
    return remaining;
  }

  int get xpForNextLevel => level * 100;

  double get levelProgress =>
      xpForNextLevel == 0 ? 0 : xpInLevel / xpForNextLevel;

  double get accuracy =>
      totalAnswered == 0 ? 0 : totalCorrect / totalAnswered;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'xp': xp,
        'totalAnswered': totalAnswered,
        'totalCorrect': totalCorrect,
        'streakDays': streakDays,
        'streakFreezes': streakFreezes,
        'lastPlayedIso': lastPlayedIso,
        'dailyQuestsDate': dailyQuestsDate,
        'badges': badges.toList(),
        'xpBySubject': xpBySubject,
        'questsProgress': questsProgress,
        'questsCompleted': questsCompleted.toList(),
        'questsClaimed': questsClaimed.toList(),
        'seenItems': seenItems.map(
          (String k, Set<String> v) =>
              MapEntry<String, List<String>>(k, v.toList()),
        ),
      };

  factory UserProgress.fromJson(Map<String, dynamic> json) => UserProgress(
        xp: (json['xp'] as int?) ?? 0,
        totalAnswered: (json['totalAnswered'] as int?) ?? 0,
        totalCorrect: (json['totalCorrect'] as int?) ?? 0,
        streakDays: (json['streakDays'] as int?) ?? 0,
        streakFreezes: (json['streakFreezes'] as int?) ?? 0,
        lastPlayedIso: json['lastPlayedIso'] as String?,
        dailyQuestsDate: json['dailyQuestsDate'] as String?,
        badges: ((json['badges'] as List?) ?? const <dynamic>[])
            .map((dynamic e) => e.toString())
            .toSet(),
        xpBySubject: ((json['xpBySubject'] as Map?) ?? const <dynamic, dynamic>{})
            .map((dynamic k, dynamic v) =>
                MapEntry<String, int>(k.toString(), (v as num).toInt())),
        questsProgress:
            ((json['questsProgress'] as Map?) ?? const <dynamic, dynamic>{})
                .map((dynamic k, dynamic v) =>
                    MapEntry<String, int>(k.toString(), (v as num).toInt())),
        questsCompleted:
            ((json['questsCompleted'] as List?) ?? const <dynamic>[])
                .map((dynamic e) => e.toString())
                .toSet(),
        questsClaimed:
            ((json['questsClaimed'] as List?) ?? const <dynamic>[])
                .map((dynamic e) => e.toString())
                .toSet(),
        seenItems: ((json['seenItems'] as Map?) ?? const <dynamic, dynamic>{})
            .map((dynamic k, dynamic v) => MapEntry<String, Set<String>>(
                  k.toString(),
                  ((v as List?) ?? const <dynamic>[])
                      .map((dynamic e) => e.toString())
                      .toSet(),
                )),
      );
}
