import 'question.dart';

/// Niveau de programme — 4e, 3e, ou les deux (par défaut).
enum Niveau { all, niveau4, niveau3 }

extension NiveauX on Niveau {
  String get label => switch (this) {
        Niveau.all => 'Tous',
        Niveau.niveau4 => '4ème',
        Niveau.niveau3 => '3ème',
      };

  String get short => switch (this) {
        Niveau.all => 'tous',
        Niveau.niveau4 => '4e',
        Niveau.niveau3 => '3e',
      };

  String get id => switch (this) {
        Niveau.all => 'all',
        Niveau.niveau4 => '4e',
        Niveau.niveau3 => '3e',
      };

  static Niveau fromId(String id) => switch (id) {
        '4e' => Niveau.niveau4,
        '3e' => Niveau.niveau3,
        _ => Niveau.all,
      };
}

/// Un chapitre regroupe des questions au sein d'une matière.
class Chapter {
  const Chapter({
    required this.id,
    required this.name,
    required this.emoji,
    required this.questions,
    this.niveau = Niveau.all,
  });

  final String id;
  final String name;
  final String emoji;
  final List<Question> questions;
  final Niveau niveau;

  /// Le chapitre est-il accessible pour le niveau sélectionné par l'utilisateur ?
  bool matchesUserNiveau(Niveau selected) {
    if (selected == Niveau.all || niveau == Niveau.all) return true;
    return niveau == selected;
  }
}
