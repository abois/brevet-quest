/// Paires pour le mini-jeu Memory.
class MemoryPair {
  const MemoryPair({
    required this.left,
    required this.right,
    required this.theme,
  });

  final String left;
  final String right;
  final String theme;

  String get id => '$theme|$left|$right';
}

class MemoryDecks {
  const MemoryDecks._();

  /// Pays / capitales — géo brevet.
  static const List<MemoryPair> capitals = <MemoryPair>[
    MemoryPair(left: 'France', right: 'Paris', theme: 'capitales'),
    MemoryPair(left: 'Espagne', right: 'Madrid', theme: 'capitales'),
    MemoryPair(left: 'Italie', right: 'Rome', theme: 'capitales'),
    MemoryPair(left: 'Allemagne', right: 'Berlin', theme: 'capitales'),
    MemoryPair(left: 'Royaume-Uni', right: 'Londres', theme: 'capitales'),
    MemoryPair(left: 'Russie', right: 'Moscou', theme: 'capitales'),
    MemoryPair(left: 'Chine', right: 'Pékin', theme: 'capitales'),
    MemoryPair(left: 'Japon', right: 'Tokyo', theme: 'capitales'),
  ];

  /// Date / événement — histoire.
  static const List<MemoryPair> history = <MemoryPair>[
    MemoryPair(left: '1789', right: 'Révolution française', theme: 'histoire'),
    MemoryPair(left: '1914', right: 'début 1ère G.M.', theme: 'histoire'),
    MemoryPair(left: '1944', right: 'Débarquement', theme: 'histoire'),
    MemoryPair(left: '1945', right: 'fin 2nde G.M.', theme: 'histoire'),
    MemoryPair(left: '1958', right: 'Vème République', theme: 'histoire'),
    MemoryPair(left: '1989', right: 'chute mur Berlin', theme: 'histoire'),
    MemoryPair(left: '1957', right: 'Traité de Rome', theme: 'histoire'),
    MemoryPair(left: '2000', right: 'quinquennat', theme: 'histoire'),
  ];

  /// Auteur / œuvre — français.
  static const List<MemoryPair> authors = <MemoryPair>[
    MemoryPair(left: 'Hugo', right: 'Les Misérables', theme: 'auteurs'),
    MemoryPair(left: 'Voltaire', right: 'Candide', theme: 'auteurs'),
    MemoryPair(left: 'Zola', right: 'Germinal', theme: 'auteurs'),
    MemoryPair(left: 'Flaubert', right: 'Mme Bovary', theme: 'auteurs'),
    MemoryPair(left: 'Camus', right: 'L\'Étranger', theme: 'auteurs'),
    MemoryPair(left: 'Molière', right: 'L\'Avare', theme: 'auteurs'),
    MemoryPair(left: 'Baudelaire', right: 'Les Fleurs du Mal', theme: 'auteurs'),
    MemoryPair(left: 'Saint-Exupéry', right: 'Le Petit Prince', theme: 'auteurs'),
  ];

  /// Vocabulaire anglais — traduction.
  static const List<MemoryPair> englishVocab = <MemoryPair>[
    MemoryPair(left: 'currently', right: 'actuellement', theme: 'anglais'),
    MemoryPair(left: 'eventually', right: 'finalement', theme: 'anglais'),
    MemoryPair(left: 'library', right: 'bibliothèque', theme: 'anglais'),
    MemoryPair(left: 'achieve', right: 'réussir', theme: 'anglais'),
    MemoryPair(left: 'borrow', right: 'emprunter', theme: 'anglais'),
    MemoryPair(left: 'rather', right: 'plutôt', theme: 'anglais'),
    MemoryPair(left: 'although', right: 'bien que', theme: 'anglais'),
    MemoryPair(left: 'however', right: 'cependant', theme: 'anglais'),
  ];

  /// Formules / résultats — maths.
  static const List<MemoryPair> formulas = <MemoryPair>[
    MemoryPair(left: '7 × 8', right: '56', theme: 'maths'),
    MemoryPair(left: '12 × 12', right: '144', theme: 'maths'),
    MemoryPair(left: '√81', right: '9', theme: 'maths'),
    MemoryPair(left: '2³', right: '8', theme: 'maths'),
    MemoryPair(left: '3 × 17', right: '51', theme: 'maths'),
    MemoryPair(left: '15²', right: '225', theme: 'maths'),
    MemoryPair(left: '20 % de 80', right: '16', theme: 'maths'),
    MemoryPair(left: '1/4 + 1/4', right: '1/2', theme: 'maths'),
  ];

  static const List<List<MemoryPair>> all = <List<MemoryPair>>[
    capitals,
    history,
    authors,
    englishVocab,
    formulas,
  ];

  static const List<String> deckNames = <String>[
    'capitales',
    'histoire',
    'auteurs',
    'anglais',
    'maths',
  ];

  static const List<String> deckEmojis = <String>[
    '🌍',
    '📜',
    '✍️',
    '🇬🇧',
    '🧮',
  ];
}
