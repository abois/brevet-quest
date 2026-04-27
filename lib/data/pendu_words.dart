/// Mot du Pendu avec son thème et un indice optionnel.
class PenduWord {
  const PenduWord({
    required this.word,
    required this.hint,
    this.subjectId,
  });

  final String word;
  final String hint;
  final String? subjectId;

  String get id => word;
}

class PenduWords {
  const PenduWords._();

  /// Liste de mots brevet (orthographe FR + vocab EN + termes scolaires).
  /// Tous en majuscules pour matcher le clavier.
  static const List<PenduWord> all = <PenduWord>[
    // Orthographe / vocab FR
    PenduWord(
        word: 'MILLENAIRE',
        hint: 'Période de mille ans',
        subjectId: 'francais'),
    PenduWord(
        word: 'PHILOSOPHE',
        hint: 'Penseur du XVIIIème',
        subjectId: 'francais'),
    PenduWord(
        word: 'METAPHORE',
        hint: 'Figure de style sans « comme »',
        subjectId: 'francais'),
    PenduWord(
        word: 'CONJUGAISON',
        hint: 'Variation des verbes',
        subjectId: 'francais'),
    PenduWord(
        word: 'ORTHOGRAPHE',
        hint: 'Bien écrire',
        subjectId: 'francais'),
    PenduWord(
        word: 'GRAMMAIRE',
        hint: 'Règles de la langue',
        subjectId: 'francais'),
    PenduWord(
        word: 'LITTERATURE',
        hint: 'Œuvres écrites',
        subjectId: 'francais'),
    PenduWord(
        word: 'POESIE',
        hint: 'Genre en vers',
        subjectId: 'francais'),
    PenduWord(
        word: 'BIBLIOTHEQUE',
        hint: 'Lieu de livres',
        subjectId: 'francais'),
    PenduWord(
        word: 'EVENEMENT',
        hint: 'Fait marquant',
        subjectId: 'francais'),

    // Histoire-géo
    PenduWord(
        word: 'REVOLUTION',
        hint: '1789 en France',
        subjectId: 'histoire-geo'),
    PenduWord(
        word: 'DEMOCRATIE',
        hint: 'Pouvoir au peuple',
        subjectId: 'histoire-geo'),
    PenduWord(
        word: 'INDUSTRIE',
        hint: 'XIXème siècle',
        subjectId: 'histoire-geo'),
    PenduWord(
        word: 'EUROPE',
        hint: 'Continent',
        subjectId: 'histoire-geo'),
    PenduWord(
        word: 'ARMISTICE',
        hint: '11 novembre 1918',
        subjectId: 'histoire-geo'),

    // Sciences
    PenduWord(
        word: 'CHROMOSOME',
        hint: 'Porteur de gènes',
        subjectId: 'sciences'),
    PenduWord(
        word: 'MOLECULE',
        hint: 'Assemblage d\'atomes',
        subjectId: 'sciences'),
    PenduWord(
        word: 'OXYGENE',
        hint: 'Gaz qu\'on respire',
        subjectId: 'sciences'),
    PenduWord(
        word: 'CELLULE',
        hint: 'Unité du vivant',
        subjectId: 'sciences'),
    PenduWord(
        word: 'ATMOSPHERE',
        hint: 'Couche gazeuse',
        subjectId: 'sciences'),

    // Maths
    PenduWord(
        word: 'PYTHAGORE',
        hint: 'Théorème du triangle rectangle',
        subjectId: 'maths'),
    PenduWord(
        word: 'GEOMETRIE',
        hint: 'Étude des figures',
        subjectId: 'maths'),
    PenduWord(
        word: 'FRACTION',
        hint: 'Partie d\'un tout',
        subjectId: 'maths'),
    PenduWord(
        word: 'STATISTIQUE',
        hint: 'Étude des données',
        subjectId: 'maths'),
    PenduWord(
        word: 'EQUATION',
        hint: 'Avec un = et des inconnues',
        subjectId: 'maths'),

    // Anglais (en majuscules sans accent)
    PenduWord(
        word: 'LIBRARY',
        hint: 'EN : bibliothèque',
        subjectId: 'anglais'),
    PenduWord(
        word: 'CURRENTLY',
        hint: 'EN : actuellement',
        subjectId: 'anglais'),
    PenduWord(
        word: 'EVENTUALLY',
        hint: 'EN : finalement',
        subjectId: 'anglais'),
    PenduWord(
        word: 'EXPERIENCE',
        hint: 'EN : expérience',
        subjectId: 'anglais'),
    PenduWord(
        word: 'KNOWLEDGE',
        hint: 'EN : savoir',
        subjectId: 'anglais'),
  ];
}
