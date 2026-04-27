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
  ];
}
