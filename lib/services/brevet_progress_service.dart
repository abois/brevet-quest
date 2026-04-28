import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// État sérialisable d'une session de brevet blanc en cours.
class BrevetProgress {
  const BrevetProgress({
    required this.sujetId,
    required this.exoIdx,
    required this.questIdx,
    required this.scoreByExo,
    required this.correctQuestions,
  });

  final String sujetId;
  final int exoIdx;
  final int questIdx;
  final Map<int, int> scoreByExo;
  final int correctQuestions;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'sujetId': sujetId,
        'exoIdx': exoIdx,
        'questIdx': questIdx,
        'scoreByExo': scoreByExo
            .map((int k, int v) => MapEntry<String, int>(k.toString(), v)),
        'correctQuestions': correctQuestions,
      };

  factory BrevetProgress.fromJson(Map<String, dynamic> json) {
    final Map<int, int> score = <int, int>{};
    final Map<dynamic, dynamic> raw =
        (json['scoreByExo'] as Map<dynamic, dynamic>?) ??
            const <dynamic, dynamic>{};
    raw.forEach((dynamic k, dynamic v) {
      score[int.parse(k.toString())] = (v as num).toInt();
    });
    return BrevetProgress(
      sujetId: json['sujetId'] as String,
      exoIdx: (json['exoIdx'] as num).toInt(),
      questIdx: (json['questIdx'] as num).toInt(),
      scoreByExo: score,
      correctQuestions: (json['correctQuestions'] as num).toInt(),
    );
  }
}

/// Persistance simple de la session brevet blanc en cours
/// (une seule à la fois) via SharedPreferences.
class BrevetProgressService {
  const BrevetProgressService._();

  static const String _kKey = 'brevet_progress';

  static Future<BrevetProgress?> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_kKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return BrevetProgress.fromJson(
          json.decode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> save(BrevetProgress p) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, json.encode(p.toJson()));
  }

  static Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kKey);
  }
}
