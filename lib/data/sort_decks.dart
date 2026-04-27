/// Une catégorie + ses items dans un deck de tri.
class SortCategory {
  const SortCategory({required this.label, required this.emoji});

  final String label;
  final String emoji;
}

/// Un item à classer — `categoryIndex` désigne la bonne colonne (0..2).
class SortItem {
  const SortItem({required this.label, required this.categoryIndex});

  final String label;
  final int categoryIndex;
}

class SortDeck {
  const SortDeck({
    required this.id,
    required this.title,
    required this.emoji,
    required this.subjectId,
    required this.categories,
    required this.items,
  });

  final String id;
  final String title;
  final String emoji;
  final String subjectId;
  final List<SortCategory> categories;
  final List<SortItem> items;
}

class SortDecks {
  const SortDecks._();

  static const List<SortDeck> all = <SortDeck>[
    SortDeck(
      id: 'classes-mots',
      title: 'Classes de mots',
      emoji: '🔤',
      subjectId: 'francais',
      categories: <SortCategory>[
        SortCategory(label: 'Nom', emoji: '📦'),
        SortCategory(label: 'Verbe', emoji: '🏃'),
        SortCategory(label: 'Adjectif', emoji: '✨'),
      ],
      items: <SortItem>[
        SortItem(label: 'maison', categoryIndex: 0),
        SortItem(label: 'courir', categoryIndex: 1),
        SortItem(label: 'beau', categoryIndex: 2),
        SortItem(label: 'lire', categoryIndex: 1),
        SortItem(label: 'voiture', categoryIndex: 0),
        SortItem(label: 'rapide', categoryIndex: 2),
        SortItem(label: 'manger', categoryIndex: 1),
        SortItem(label: 'rouge', categoryIndex: 2),
        SortItem(label: 'chien', categoryIndex: 0),
      ],
    ),
    SortDeck(
      id: 'figures',
      title: 'Figures de style',
      emoji: '🪞',
      subjectId: 'francais',
      categories: <SortCategory>[
        SortCategory(label: 'Métaphore', emoji: '🌊'),
        SortCategory(label: 'Comparaison', emoji: '⚖️'),
        SortCategory(label: 'Hyperbole', emoji: '💥'),
      ],
      items: <SortItem>[
        SortItem(label: 'Le temps mange la vie', categoryIndex: 0),
        SortItem(label: 'Fort comme un lion', categoryIndex: 1),
        SortItem(label: 'Mourir de rire', categoryIndex: 2),
        SortItem(label: 'Cette fille est un soleil', categoryIndex: 0),
        SortItem(label: 'Blanc comme neige', categoryIndex: 1),
        SortItem(label: 'Je te l\'ai dit mille fois', categoryIndex: 2),
        SortItem(label: 'Ses yeux sont des étoiles', categoryIndex: 0),
        SortItem(label: 'Doux comme un agneau', categoryIndex: 1),
        SortItem(label: 'Crever de chaud', categoryIndex: 2),
      ],
    ),
    SortDeck(
      id: 'periodes',
      title: 'Périodes historiques',
      emoji: '📜',
      subjectId: 'histoire-geo',
      categories: <SortCategory>[
        SortCategory(label: 'XIXème', emoji: '🏭'),
        SortCategory(label: 'XXème', emoji: '⚔️'),
        SortCategory(label: 'XXIème', emoji: '🌐'),
      ],
      items: <SortItem>[
        SortItem(label: 'Révolution industrielle', categoryIndex: 0),
        SortItem(label: '1ère Guerre mondiale', categoryIndex: 1),
        SortItem(label: 'Internet pour tous', categoryIndex: 2),
        SortItem(label: 'Loi Ferry sur l\'école', categoryIndex: 0),
        SortItem(label: 'Chute du mur de Berlin', categoryIndex: 1),
        SortItem(label: 'Smartphones', categoryIndex: 2),
        SortItem(label: 'Abolition esclavage 1848', categoryIndex: 0),
        SortItem(label: 'Vème République 1958', categoryIndex: 1),
        SortItem(label: 'Crise climatique', categoryIndex: 2),
      ],
    ),
    SortDeck(
      id: 'etats-matiere',
      title: 'États de la matière',
      emoji: '🧪',
      subjectId: 'sciences',
      categories: <SortCategory>[
        SortCategory(label: 'Solide', emoji: '🧊'),
        SortCategory(label: 'Liquide', emoji: '💧'),
        SortCategory(label: 'Gaz', emoji: '💨'),
      ],
      items: <SortItem>[
        SortItem(label: 'Glace', categoryIndex: 0),
        SortItem(label: 'Eau', categoryIndex: 1),
        SortItem(label: 'Vapeur', categoryIndex: 2),
        SortItem(label: 'Fer', categoryIndex: 0),
        SortItem(label: 'Mercure', categoryIndex: 1),
        SortItem(label: 'Oxygène', categoryIndex: 2),
        SortItem(label: 'Pierre', categoryIndex: 0),
        SortItem(label: 'Huile', categoryIndex: 1),
        SortItem(label: 'Hélium', categoryIndex: 2),
      ],
    ),
    SortDeck(
      id: 'temps-verbes',
      title: 'Temps des verbes',
      emoji: '⏳',
      subjectId: 'francais',
      categories: <SortCategory>[
        SortCategory(label: 'Présent', emoji: '🕐'),
        SortCategory(label: 'Passé', emoji: '⏪'),
        SortCategory(label: 'Futur', emoji: '⏩'),
      ],
      items: <SortItem>[
        SortItem(label: 'je mange', categoryIndex: 0),
        SortItem(label: 'j\'ai mangé', categoryIndex: 1),
        SortItem(label: 'je mangerai', categoryIndex: 2),
        SortItem(label: 'tu cours', categoryIndex: 0),
        SortItem(label: 'tu courais', categoryIndex: 1),
        SortItem(label: 'tu courras', categoryIndex: 2),
        SortItem(label: 'il finit', categoryIndex: 0),
        SortItem(label: 'il finit (passé simple)', categoryIndex: 1),
        SortItem(label: 'il finira', categoryIndex: 2),
      ],
    ),
  ];
}
