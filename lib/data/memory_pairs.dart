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
    MemoryPair(left: 'Portugal', right: 'Lisbonne', theme: 'capitales'),
    MemoryPair(left: 'Grèce', right: 'Athènes', theme: 'capitales'),
    MemoryPair(left: 'Pays-Bas', right: 'Amsterdam', theme: 'capitales'),
    MemoryPair(left: 'Belgique', right: 'Bruxelles', theme: 'capitales'),
    MemoryPair(left: 'Égypte', right: 'Le Caire', theme: 'capitales'),
    MemoryPair(left: 'Brésil', right: 'Brasilia', theme: 'capitales'),
    MemoryPair(left: 'Inde', right: 'New Delhi', theme: 'capitales'),
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
    MemoryPair(left: '1804', right: 'sacre Napoléon', theme: 'histoire'),
    MemoryPair(left: '1848', right: 'IIème République', theme: 'histoire'),
    MemoryPair(left: '1870', right: 'IIIème République', theme: 'histoire'),
    MemoryPair(left: '1936', right: 'Front populaire', theme: 'histoire'),
    MemoryPair(left: '1962', right: 'indépendance Algérie', theme: 'histoire'),
    MemoryPair(left: '1981', right: 'Mitterrand élu', theme: 'histoire'),
    MemoryPair(left: '1992', right: 'Traité de Maastricht', theme: 'histoire'),
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
    MemoryPair(left: 'Maupassant', right: 'Boule de Suif', theme: 'auteurs'),
    MemoryPair(left: 'Stendhal', right: 'Le Rouge et le Noir', theme: 'auteurs'),
    MemoryPair(left: 'Rimbaud', right: 'Le Bateau ivre', theme: 'auteurs'),
    MemoryPair(left: 'Verlaine', right: 'Romances sans paroles', theme: 'auteurs'),
    MemoryPair(left: 'Proust', right: 'Du côté de chez Swann', theme: 'auteurs'),
    MemoryPair(left: 'Sartre', right: 'La Nausée', theme: 'auteurs'),
    MemoryPair(left: 'Apollinaire', right: 'Alcools', theme: 'auteurs'),
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
    MemoryPair(left: 'beneath', right: 'en dessous', theme: 'anglais'),
    MemoryPair(left: 'whereas', right: 'tandis que', theme: 'anglais'),
    MemoryPair(left: 'awkward', right: 'gênant', theme: 'anglais'),
    MemoryPair(left: 'thoroughly', right: 'soigneusement', theme: 'anglais'),
    MemoryPair(left: 'thrive', right: 'prospérer', theme: 'anglais'),
    MemoryPair(left: 'overcome', right: 'surmonter', theme: 'anglais'),
    MemoryPair(left: 'reluctant', right: 'réticent', theme: 'anglais'),
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
    MemoryPair(left: '√144', right: '12', theme: 'maths'),
    MemoryPair(left: '6 × 9', right: '54', theme: 'maths'),
    MemoryPair(left: '2⁵', right: '32', theme: 'maths'),
    MemoryPair(left: '25 % de 60', right: '15', theme: 'maths'),
    MemoryPair(left: '13²', right: '169', theme: 'maths'),
    MemoryPair(left: '3/4 × 8', right: '6', theme: 'maths'),
    MemoryPair(left: '10⁴', right: '10000', theme: 'maths'),
  ];

  /// Scientifiques / domaines.
  static const List<MemoryPair> scientists = <MemoryPair>[
    MemoryPair(left: 'Einstein', right: 'relativité', theme: 'sciences'),
    MemoryPair(left: 'Newton', right: 'gravitation', theme: 'sciences'),
    MemoryPair(left: 'Darwin', right: 'évolution', theme: 'sciences'),
    MemoryPair(left: 'Curie', right: 'radioactivité', theme: 'sciences'),
    MemoryPair(left: 'Mendel', right: 'génétique', theme: 'sciences'),
    MemoryPair(left: 'Pasteur', right: 'vaccination', theme: 'sciences'),
    MemoryPair(left: 'Lavoisier', right: 'chimie moderne', theme: 'sciences'),
    MemoryPair(left: 'Galilée', right: 'astronomie', theme: 'sciences'),
    MemoryPair(left: 'Mendeleïev', right: 'tableau périodique', theme: 'sciences'),
    MemoryPair(left: 'Volta', right: 'pile électrique', theme: 'sciences'),
    MemoryPair(left: 'Ampère', right: 'électromagnétisme', theme: 'sciences'),
    MemoryPair(left: 'Watt', right: 'machine à vapeur', theme: 'sciences'),
  ];

  /// Symboles chimiques / éléments.
  static const List<MemoryPair> chemistry = <MemoryPair>[
    MemoryPair(left: 'H', right: 'Hydrogène', theme: 'chimie'),
    MemoryPair(left: 'O', right: 'Oxygène', theme: 'chimie'),
    MemoryPair(left: 'C', right: 'Carbone', theme: 'chimie'),
    MemoryPair(left: 'N', right: 'Azote', theme: 'chimie'),
    MemoryPair(left: 'Fe', right: 'Fer', theme: 'chimie'),
    MemoryPair(left: 'Cu', right: 'Cuivre', theme: 'chimie'),
    MemoryPair(left: 'Au', right: 'Or', theme: 'chimie'),
    MemoryPair(left: 'Ag', right: 'Argent', theme: 'chimie'),
    MemoryPair(left: 'Na', right: 'Sodium', theme: 'chimie'),
    MemoryPair(left: 'Cl', right: 'Chlore', theme: 'chimie'),
    MemoryPair(left: 'Ca', right: 'Calcium', theme: 'chimie'),
    MemoryPair(left: 'K', right: 'Potassium', theme: 'chimie'),
  ];

  static const List<List<MemoryPair>> all = <List<MemoryPair>>[
    capitals,
    history,
    authors,
    englishVocab,
    formulas,
    scientists,
    chemistry,
  ];

  static const List<String> deckNames = <String>[
    'capitales',
    'histoire',
    'auteurs',
    'anglais',
    'maths',
    'sciences',
    'chimie',
  ];

  static const List<String> deckEmojis = <String>[
    '🌍',
    '📜',
    '✍️',
    '🇬🇧',
    '🧮',
    '🔬',
    '⚗️',
  ];
}
