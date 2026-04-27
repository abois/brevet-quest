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

    // Orthographe / vocab FR (suite)
    PenduWord(
        word: 'PARAGRAPHE',
        hint: 'Bloc de texte',
        subjectId: 'francais'),
    PenduWord(
        word: 'NARRATEUR',
        hint: 'Celui qui raconte',
        subjectId: 'francais'),
    PenduWord(
        word: 'PROLOGUE',
        hint: 'Avant-propos d\'une œuvre',
        subjectId: 'francais'),
    PenduWord(
        word: 'PERSONNIFICATION',
        hint: 'Figure de style attribuant des traits humains',
        subjectId: 'francais'),
    PenduWord(
        word: 'COMPARAISON',
        hint: 'Figure de style avec « comme »',
        subjectId: 'francais'),
    PenduWord(
        word: 'OXYMORE',
        hint: 'Figure de style à termes contradictoires',
        subjectId: 'francais'),
    PenduWord(
        word: 'ANTITHESE',
        hint: 'Opposition de deux idées',
        subjectId: 'francais'),
    PenduWord(
        word: 'AUTOBIOGRAPHIE',
        hint: 'Récit de sa propre vie',
        subjectId: 'francais'),
    PenduWord(
        word: 'NOUVELLE',
        hint: 'Court récit de fiction',
        subjectId: 'francais'),
    PenduWord(
        word: 'TRAGEDIE',
        hint: 'Genre théâtral classique',
        subjectId: 'francais'),

    // Histoire-géo (suite)
    PenduWord(
        word: 'COLONISATION',
        hint: 'Domination d\'un territoire',
        subjectId: 'histoire-geo'),
    PenduWord(
        word: 'DECOLONISATION',
        hint: 'Indépendance des colonies',
        subjectId: 'histoire-geo'),
    PenduWord(
        word: 'TOTALITARISME',
        hint: 'Régime contrôlant tout',
        subjectId: 'histoire-geo'),
    PenduWord(
        word: 'GENOCIDE',
        hint: 'Extermination d\'un peuple',
        subjectId: 'histoire-geo'),
    PenduWord(
        word: 'RESISTANCE',
        hint: 'Lutte contre l\'occupant',
        subjectId: 'histoire-geo'),
    PenduWord(
        word: 'MONDIALISATION',
        hint: 'Échanges à l\'échelle mondiale',
        subjectId: 'histoire-geo'),
    PenduWord(
        word: 'CONSTITUTION',
        hint: 'Loi fondamentale',
        subjectId: 'histoire-geo'),
    PenduWord(
        word: 'METROPOLE',
        hint: 'Grande ville centrale',
        subjectId: 'histoire-geo'),
    PenduWord(
        word: 'DEMOGRAPHIE',
        hint: 'Étude des populations',
        subjectId: 'histoire-geo'),
    PenduWord(
        word: 'GUERRE',
        hint: 'Conflit armé',
        subjectId: 'histoire-geo'),

    // Sciences (suite)
    PenduWord(
        word: 'PHOTOSYNTHESE',
        hint: 'Comment les plantes fabriquent leur matière',
        subjectId: 'sciences'),
    PenduWord(
        word: 'RESPIRATION',
        hint: 'Échanges gazeux',
        subjectId: 'sciences'),
    PenduWord(
        word: 'NEURONE',
        hint: 'Cellule du cerveau',
        subjectId: 'sciences'),
    PenduWord(
        word: 'GENETIQUE',
        hint: 'Étude des gènes',
        subjectId: 'sciences'),
    PenduWord(
        word: 'MITOSE',
        hint: 'Division cellulaire',
        subjectId: 'sciences'),
    PenduWord(
        word: 'ELECTRICITE',
        hint: 'Énergie des électrons',
        subjectId: 'sciences'),
    PenduWord(
        word: 'GRAVITATION',
        hint: 'Force de Newton',
        subjectId: 'sciences'),
    PenduWord(
        word: 'ENERGIE',
        hint: 'Capacité à effectuer un travail',
        subjectId: 'sciences'),
    PenduWord(
        word: 'CARBONE',
        hint: 'Élément n°6',
        subjectId: 'sciences'),
    PenduWord(
        word: 'OZONE',
        hint: 'Couche protectrice (O₃)',
        subjectId: 'sciences'),

    // Maths (suite)
    PenduWord(
        word: 'THALES',
        hint: 'Théorème des parallèles',
        subjectId: 'maths'),
    PenduWord(
        word: 'PROBABILITE',
        hint: 'Chance qu\'un évènement se produise',
        subjectId: 'maths'),
    PenduWord(
        word: 'POURCENTAGE',
        hint: 'Proportion sur 100',
        subjectId: 'maths'),
    PenduWord(
        word: 'IDENTITE',
        hint: 'Égalité toujours vraie',
        subjectId: 'maths'),
    PenduWord(
        word: 'TRIANGLE',
        hint: 'Figure à 3 côtés',
        subjectId: 'maths'),
    PenduWord(
        word: 'HYPOTENUSE',
        hint: 'Plus grand côté du triangle rectangle',
        subjectId: 'maths'),
    PenduWord(
        word: 'PARALLELOGRAMME',
        hint: 'Quadrilatère aux côtés opposés parallèles',
        subjectId: 'maths'),
    PenduWord(
        word: 'COSINUS',
        hint: 'Trigo : adj/hyp',
        subjectId: 'maths'),
    PenduWord(
        word: 'DIVISEUR',
        hint: 'Divise un nombre',
        subjectId: 'maths'),
    PenduWord(
        word: 'PUISSANCE',
        hint: 'a^n',
        subjectId: 'maths'),

    // Anglais (suite)
    PenduWord(
        word: 'BREAKFAST',
        hint: 'EN : petit-déjeuner',
        subjectId: 'anglais'),
    PenduWord(
        word: 'WEDNESDAY',
        hint: 'EN : mercredi',
        subjectId: 'anglais'),
    PenduWord(
        word: 'NEIGHBOUR',
        hint: 'EN : voisin',
        subjectId: 'anglais'),
    PenduWord(
        word: 'BEAUTIFUL',
        hint: 'EN : beau',
        subjectId: 'anglais'),
    PenduWord(
        word: 'GOVERNMENT',
        hint: 'EN : gouvernement',
        subjectId: 'anglais'),
    PenduWord(
        word: 'WEATHER',
        hint: 'EN : météo',
        subjectId: 'anglais'),
    PenduWord(
        word: 'THROUGHOUT',
        hint: 'EN : tout au long',
        subjectId: 'anglais'),
    PenduWord(
        word: 'NEVERTHELESS',
        hint: 'EN : néanmoins',
        subjectId: 'anglais'),
    PenduWord(
        word: 'FRIENDSHIP',
        hint: 'EN : amitié',
        subjectId: 'anglais'),
    PenduWord(
        word: 'YESTERDAY',
        hint: 'EN : hier',
        subjectId: 'anglais'),
  ];
}
