/// Événement daté pour le jeu Frise chronologique.
class TimelineEvent {
  const TimelineEvent({required this.year, required this.label});

  final int year;
  final String label;
}

/// Un deck = un set d'événements à remettre dans l'ordre.
class TimelineDeck {
  const TimelineDeck({
    required this.id,
    required this.title,
    required this.emoji,
    required this.subjectId,
    required this.events,
  });

  final String id;
  final String title;
  final String emoji;
  final String subjectId;
  final List<TimelineEvent> events;
}

/// Decks pré-conçus pour le brevet — chaque deck contient 5 événements.
class TimelineDecks {
  const TimelineDecks._();

  static const List<TimelineDeck> all = <TimelineDeck>[
    TimelineDeck(
      id: 'guerres',
      title: 'Guerres mondiales',
      emoji: '⚔️',
      subjectId: 'histoire-geo',
      events: <TimelineEvent>[
        TimelineEvent(year: 1914, label: 'Début 1ère G.M.'),
        TimelineEvent(year: 1918, label: 'Armistice 1ère G.M.'),
        TimelineEvent(year: 1939, label: 'Début 2nde G.M.'),
        TimelineEvent(year: 1944, label: 'Débarquement Normandie'),
        TimelineEvent(year: 1945, label: 'Fin 2nde G.M.'),
      ],
    ),
    TimelineDeck(
      id: 'france',
      title: 'France moderne',
      emoji: '🇫🇷',
      subjectId: 'histoire-geo',
      events: <TimelineEvent>[
        TimelineEvent(year: 1789, label: 'Révolution française'),
        TimelineEvent(year: 1804, label: 'Napoléon empereur'),
        TimelineEvent(year: 1848, label: 'Abolition esclavage'),
        TimelineEvent(year: 1905, label: 'Loi de séparation Église-État'),
        TimelineEvent(year: 1958, label: 'Vème République'),
      ],
    ),
    TimelineDeck(
      id: 'xxe',
      title: 'XXème siècle',
      emoji: '🌍',
      subjectId: 'histoire-geo',
      events: <TimelineEvent>[
        TimelineEvent(year: 1929, label: 'Krach de Wall Street'),
        TimelineEvent(year: 1933, label: 'Hitler au pouvoir'),
        TimelineEvent(year: 1944, label: 'Droit de vote des femmes'),
        TimelineEvent(year: 1957, label: 'Traité de Rome'),
        TimelineEvent(year: 1989, label: 'Chute du mur de Berlin'),
      ],
    ),
    TimelineDeck(
      id: 'litterature',
      title: 'Auteurs français',
      emoji: '✍️',
      subjectId: 'francais',
      events: <TimelineEvent>[
        TimelineEvent(year: 1759, label: 'Candide (Voltaire)'),
        TimelineEvent(year: 1862, label: 'Les Misérables (Hugo)'),
        TimelineEvent(year: 1857, label: 'Mme Bovary (Flaubert)'),
        TimelineEvent(year: 1885, label: 'Germinal (Zola)'),
        TimelineEvent(year: 1942, label: 'L\'Étranger (Camus)'),
      ],
    ),
    TimelineDeck(
      id: 'sciences',
      title: 'Sciences & inventions',
      emoji: '🔬',
      subjectId: 'sciences',
      events: <TimelineEvent>[
        TimelineEvent(year: 1687, label: 'Lois de Newton'),
        TimelineEvent(year: 1859, label: 'Origine des espèces (Darwin)'),
        TimelineEvent(year: 1905, label: 'Relativité (Einstein)'),
        TimelineEvent(year: 1953, label: 'Structure de l\'ADN'),
        TimelineEvent(year: 1969, label: 'Premier homme sur la Lune'),
      ],
    ),
    TimelineDeck(
      id: 'republiques',
      title: 'Républiques françaises',
      emoji: '🏛️',
      subjectId: 'histoire-geo',
      events: <TimelineEvent>[
        TimelineEvent(year: 1792, label: 'Iʳᵉ République'),
        TimelineEvent(year: 1848, label: 'IIᵉ République'),
        TimelineEvent(year: 1870, label: 'IIIᵉ République'),
        TimelineEvent(year: 1946, label: 'IVᵉ République'),
        TimelineEvent(year: 1958, label: 'Vᵉ République'),
      ],
    ),
    TimelineDeck(
      id: 'colonisation',
      title: 'Colonisation & décolonisation',
      emoji: '🌐',
      subjectId: 'histoire-geo',
      events: <TimelineEvent>[
        TimelineEvent(year: 1830, label: 'Conquête d\'Alger'),
        TimelineEvent(year: 1885, label: 'Conférence de Berlin'),
        TimelineEvent(year: 1947, label: 'Indépendance de l\'Inde'),
        TimelineEvent(year: 1954, label: 'Début guerre d\'Algérie'),
        TimelineEvent(year: 1962, label: 'Indépendance de l\'Algérie'),
      ],
    ),
    TimelineDeck(
      id: 'europe',
      title: 'Construction européenne',
      emoji: '🇪🇺',
      subjectId: 'histoire-geo',
      events: <TimelineEvent>[
        TimelineEvent(year: 1951, label: 'CECA (charbon-acier)'),
        TimelineEvent(year: 1957, label: 'Traité de Rome (CEE)'),
        TimelineEvent(year: 1992, label: 'Traité de Maastricht (UE)'),
        TimelineEvent(year: 2002, label: 'Mise en circulation de l\'euro'),
        TimelineEvent(year: 2020, label: 'Brexit effectif'),
      ],
    ),
    TimelineDeck(
      id: 'rev-industrielle',
      title: 'Révolution industrielle',
      emoji: '🏭',
      subjectId: 'histoire-geo',
      events: <TimelineEvent>[
        TimelineEvent(year: 1769, label: 'Machine à vapeur (Watt)'),
        TimelineEvent(year: 1825, label: 'Premier train à vapeur'),
        TimelineEvent(year: 1870, label: '2ᵉ révolution industrielle'),
        TimelineEvent(year: 1879, label: 'Lampe d\'Edison'),
        TimelineEvent(year: 1903, label: 'Premier vol des frères Wright'),
      ],
    ),
    TimelineDeck(
      id: 'numerique',
      title: 'Ère numérique',
      emoji: '💻',
      subjectId: 'sciences',
      events: <TimelineEvent>[
        TimelineEvent(year: 1969, label: 'ARPANET (ancêtre Internet)'),
        TimelineEvent(year: 1989, label: 'World Wide Web'),
        TimelineEvent(year: 2007, label: 'Premier iPhone'),
        TimelineEvent(year: 2010, label: 'Démocratisation des réseaux sociaux'),
        TimelineEvent(year: 2022, label: 'ChatGPT grand public'),
      ],
    ),
  ];
}
