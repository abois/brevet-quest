import 'package:flutter/material.dart';

import 'chapter.dart';

/// Une matière du brevet.
class Subject {
  const Subject({
    required this.id,
    required this.name,
    required this.shortName,
    required this.emoji,
    required this.color,
    required this.gradient,
    required this.chapters,
  });

  final String id;
  final String name;
  final String shortName;
  final String emoji;
  final Color color;
  final List<Color> gradient;
  final List<Chapter> chapters;

  int get totalQuestions =>
      chapters.fold(0, (sum, c) => sum + c.questions.length);
}
