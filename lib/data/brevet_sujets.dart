import 'problemes_data.dart';

/// Type d'une question de brevet : numérique (saisie), QCM, Vrai/Faux,
/// ou ouverte (rédaction libre + auto-évaluation par le joueur).
enum BrevetQuestionKind { numerical, qcm, trueFalse, openEnded }

/// Regroupement des sujets de brevet :
/// - `officialFull` : épreuve officielle complète (annale).
/// - `extracts` : sujet original / questions extraites pour entraînement.
enum BrevetCategory { officialFull, extracts }

/// Une question d'un exercice de brevet blanc.
///
/// Pour `kind == numerical` : utiliser `answer` + `tolerance` + `unit`.
/// Pour `kind == qcm` : utiliser `choices` + `answerIndex`.
/// Pour `kind == trueFalse` : `choices = ['Vrai','Faux']`, `answerIndex` 0 ou 1.
class BrevetQuestion {
  const BrevetQuestion.numerical({
    required this.prompt,
    required double this.answer,
    required double this.tolerance,
    required String this.unit,
    required this.explanation,
    this.schema,
    this.points = 1,
  })  : kind = BrevetQuestionKind.numerical,
        choices = const <String>[],
        answerIndex = 0,
        modelAnswer = null;

  const BrevetQuestion.qcm({
    required this.prompt,
    required List<String> this.choices,
    required int this.answerIndex,
    required this.explanation,
    this.schema,
    this.points = 1,
  })  : kind = BrevetQuestionKind.qcm,
        answer = null,
        tolerance = null,
        unit = null,
        modelAnswer = null;

  const BrevetQuestion.trueFalse({
    required this.prompt,
    required bool answer,
    required this.explanation,
    this.schema,
    this.points = 1,
  })  : kind = BrevetQuestionKind.trueFalse,
        choices = const <String>['Vrai', 'Faux'],
        answerIndex = answer ? 0 : 1,
        // ignore: avoid_field_initializers_in_const_classes
        answer = null,
        tolerance = null,
        unit = null,
        modelAnswer = null;

  /// Question à réponse rédigée libre. Pas d'évaluation automatique :
  /// après avoir saisi sa réponse, le joueur voit la « réponse type »
  /// (`modelAnswer`) et s'auto-évalue (« j'avais juste » / « à revoir »).
  const BrevetQuestion.openEnded({
    required this.prompt,
    required String this.modelAnswer,
    required this.explanation,
    this.schema,
    this.points = 1,
  })  : kind = BrevetQuestionKind.openEnded,
        choices = const <String>[],
        answerIndex = 0,
        answer = null,
        tolerance = null,
        unit = null;

  final BrevetQuestionKind kind;
  final String prompt;
  final String explanation;
  final ProblemeSchema? schema;
  final int points;
  // Numerical
  final double? answer;
  final double? tolerance;
  final String? unit;
  // QCM / V-F
  final List<String> choices;
  final int answerIndex;
  // Question ouverte : réponse type affichée pour auto-évaluation.
  final String? modelAnswer;
}

/// Un exercice : un contexte commun + plusieurs questions enchaînées.
class BrevetExercise {
  const BrevetExercise({
    required this.title,
    required this.context,
    required this.questions,
    this.schema,
    this.imageUrl,
    this.imageCaption,
  });

  final String title;
  final String context;
  final List<BrevetQuestion> questions;
  final ProblemeSchema? schema;

  /// URL d'une image (ex: tableau pour analyse de texte+image).
  final String? imageUrl;
  final String? imageCaption;

  int get totalPoints => questions.fold(0, (int s, BrevetQuestion q) => s + q.points);
}

/// Un sujet de brevet blanc — composé de plusieurs exercices.
class BrevetSujet {
  const BrevetSujet({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.exercises,
    this.source,
    this.sourceUrl,
    this.category = BrevetCategory.extracts,
    this.unlockLevel = 3,
  });

  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final List<BrevetExercise> exercises;
  /// Source d'inspiration (ex: « Métropole — juin 2024 »). Affichée
  /// dans la tuile et le bilan.
  final String? source;
  final String? sourceUrl;
  final BrevetCategory category;
  final int unlockLevel;

  int get totalPoints =>
      exercises.fold(0, (int s, BrevetExercise e) => s + e.totalPoints);
  int get totalQuestions =>
      exercises.fold(0, (int s, BrevetExercise e) => s + e.questions.length);

  bool isUnlocked(int userLevel) => userLevel >= unlockLevel;
}

class BrevetSujets {
  const BrevetSujets._();

  static const List<BrevetSujet> all = <BrevetSujet>[
    // ─────────────────── Sujet 1 ───────────────────
    BrevetSujet(
      id: 'brevet-blanc-1',
      title: 'Brevet Blanc nº1',
      subtitle: 'Géométrie & vie quotidienne',
      emoji: '📐',
      source: 'Sujet original — atelier brevet',
      exercises: <BrevetExercise>[
        BrevetExercise(
          title: 'Exercice 1 — La piscine',
          context:
              'Une piscine rectangulaire mesure 8 m de long et 6 m de large. '
              'Pour la sécuriser, on installe une bâche tendue en diagonale '
              'd\'un coin à l\'autre.',
          schema: RectangleSchema(width: '8', height: '6'),
          questions: <BrevetQuestion>[
            BrevetQuestion.numerical(
              prompt: '1. Calcule la longueur de la bâche (en m).',
              answer: 10,
              tolerance: 0.01,
              unit: 'm',
              explanation: 'd² = 8² + 6² = 100, donc d = 10 m (Pythagore).',
              points: 2,
            ),
            BrevetQuestion.numerical(
              prompt: '2. Quelle est l\'aire de la piscine (en m²) ?',
              answer: 48,
              tolerance: 0.01,
              unit: 'm²',
              explanation: 'Aire = 8 × 6 = 48 m².',
              points: 1,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '3. La bâche se vend par bandes de 50 cm de large posées dans le sens de la longueur (8 m). Combien de bandes faut-il pour couvrir la largeur de 6 m ?',
              answer: 12,
              tolerance: 0.01,
              unit: 'bandes',
              explanation:
                  '6 m / 0,5 m = 12 bandes (chaque bande couvre 50 cm de largeur).',
              points: 2,
            ),
          ],
        ),
        BrevetExercise(
          title: 'Exercice 2 — Statistiques de classe',
          context:
              'Voici les notes (sur 20) obtenues par 10 élèves à un contrôle :\n'
              '8 ; 12 ; 15 ; 9 ; 11 ; 14 ; 16 ; 12 ; 10 ; 13.',
          questions: <BrevetQuestion>[
            BrevetQuestion.numerical(
              prompt: '1. Calcule la moyenne de la classe (au dixième).',
              answer: 12,
              tolerance: 0.05,
              unit: '/20',
              explanation:
                  '(8+12+15+9+11+14+16+12+10+13)/10 = 120/10 = 12.',
              points: 1,
            ),
            BrevetQuestion.numerical(
              prompt: '2. Calcule la médiane de la série (au dixième).',
              answer: 12,
              tolerance: 0.05,
              unit: '/20',
              explanation:
                  'Triée : 8,9,10,11,12,12,13,14,15,16. Médiane = (12+12)/2 = 12.',
              points: 1,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '3. Quel est le pourcentage d\'élèves qui ont eu 12 ou plus ?',
              answer: 60,
              tolerance: 0.05,
              unit: '%',
              explanation:
                  '6 élèves ≥ 12 sur 10 = 60 %.',
              points: 2,
            ),
          ],
        ),
        BrevetExercise(
          title: 'Exercice 3 — Forfait téléphone',
          context:
              'Un opérateur propose deux forfaits :\n'
              '• Forfait A : 8 €/mois, puis 0,15 €/min de communication.\n'
              '• Forfait B : 15 €/mois, communications illimitées.',
          questions: <BrevetQuestion>[
            BrevetQuestion.numerical(
              prompt:
                  '1. Combien paiera-t-on avec le forfait A pour 30 minutes de communication dans le mois ?',
              answer: 12.5,
              tolerance: 0.01,
              unit: '€',
              explanation: '8 + 30 × 0,15 = 8 + 4,5 = 12,50 €.',
              points: 1,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '2. À partir de combien de minutes le forfait B devient-il plus avantageux que le forfait A (au plus proche) ?',
              answer: 47,
              tolerance: 0.5,
              unit: 'min',
              explanation:
                  '8 + 0,15x = 15 → 0,15x = 7 → x ≈ 46,7 min, donc 47 min.',
              points: 2,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '3. Avec le forfait A et 1h20 de communication par mois, combien paie-t-on (en €, au centime) ?',
              answer: 20,
              tolerance: 0.01,
              unit: '€',
              explanation: '80 min × 0,15 = 12 €. Total = 8 + 12 = 20 €.',
              points: 2,
            ),
          ],
        ),
      ],
    ),

    // ─────────────────── Sujet 2 ───────────────────
    BrevetSujet(
      id: 'brevet-blanc-2',
      title: 'Brevet Blanc nº2',
      subtitle: 'Sciences & espace',
      emoji: '🔬',
      source: 'Sujet original — atelier brevet',
      exercises: <BrevetExercise>[
        BrevetExercise(
          title: 'Exercice 1 — La cuve à eau',
          context:
              'Une cuve cylindrique a un rayon intérieur de 5 dm et une '
              'hauteur de 12 dm. On prendra π ≈ 3,14.',
          schema: CylinderSchema(radius: '5', height: '12'),
          questions: <BrevetQuestion>[
            BrevetQuestion.numerical(
              prompt:
                  '1. Calcule le volume total de la cuve (en litres).',
              answer: 942,
              tolerance: 1,
              unit: 'L',
              explanation: 'V = π × 5² × 12 = 942 dm³ = 942 L.',
              points: 2,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '2. La cuve est remplie à 75 %. Combien de litres contient-elle (au litre) ?',
              answer: 706,
              tolerance: 1,
              unit: 'L',
              explanation: '942 × 0,75 = 706,5 ≈ 706 L (ou 707).',
              points: 2,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '3. On la vide à un débit de 20 L/min. Combien de minutes pour la vider entièrement (à la minute près) ?',
              answer: 47,
              tolerance: 1,
              unit: 'min',
              explanation: '942 / 20 = 47,1 min ≈ 47 min.',
              points: 1,
            ),
          ],
        ),
        BrevetExercise(
          title: 'Exercice 2 — La pente du toit',
          context:
              'Le toit d\'une maison a deux versants symétriques. La largeur '
              'de la maison est de 8 m. Le faîte du toit (point le plus haut) '
              'est à 3 m au-dessus du haut des murs.',
          questions: <BrevetQuestion>[
            BrevetQuestion.numerical(
              prompt:
                  '1. Calcule la longueur d\'un chevron (versant du toit) au dixième.',
              answer: 5,
              tolerance: 0.05,
              unit: 'm',
              explanation:
                  'Chevron² = 4² + 3² = 25, donc chevron = 5 m (Pythagore).',
              points: 2,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '2. Quel angle forme un chevron avec l\'horizontale (au degré près) ?',
              answer: 37,
              tolerance: 0.6,
              unit: '°',
              explanation:
                  'tan(angle) = 3/4 = 0,75 → angle ≈ arctan(0,75) ≈ 37°.',
              points: 2,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '3. La maison fait 10 m de profondeur. Quelle est la surface totale de toiture à couvrir (en m²) ?',
              answer: 100,
              tolerance: 1,
              unit: 'm²',
              explanation: '2 versants × (5 m × 10 m) = 100 m².',
              points: 1,
            ),
          ],
        ),
        BrevetExercise(
          title: 'Exercice 3 — Programme de calcul',
          context:
              'Voici un programme de calcul :\n'
              '• Choisir un nombre.\n'
              '• Lui ajouter 3.\n'
              '• Multiplier le résultat par 2.\n'
              '• Soustraire 4.',
          questions: <BrevetQuestion>[
            BrevetQuestion.numerical(
              prompt: '1. Quel résultat obtient-on en partant de 5 ?',
              answer: 12,
              tolerance: 0.01,
              unit: '',
              explanation: '5 + 3 = 8 ; 8 × 2 = 16 ; 16 − 4 = 12.',
              points: 1,
            ),
            BrevetQuestion.numerical(
              prompt: '2. Et en partant de −2 ?',
              answer: -2,
              tolerance: 0.01,
              unit: '',
              explanation: '−2 + 3 = 1 ; 1 × 2 = 2 ; 2 − 4 = −2.',
              points: 1,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '3. Quel nombre choisir pour obtenir un résultat de 16 ?',
              answer: 7,
              tolerance: 0.01,
              unit: '',
              explanation: '2(x+3) − 4 = 16 → 2x + 2 = 16 → x = 7.',
              points: 2,
            ),
          ],
        ),
      ],
    ),

    // ─────────────────── Sujet 3 ───────────────────
    BrevetSujet(
      id: 'brevet-blanc-3',
      title: 'Brevet Blanc nº3',
      subtitle: 'Thalès & proportionnalité',
      emoji: '🌍',
      source: 'Sujet original — atelier brevet',
      exercises: <BrevetExercise>[
        BrevetExercise(
          title: 'Exercice 1 — Sur la carte',
          context:
              'Sur une carte au 1/25 000, deux villes A et B sont distantes '
              'de 8 cm. Une route directe les relie.',
          questions: <BrevetQuestion>[
            BrevetQuestion.numerical(
              prompt:
                  '1. Quelle est la distance réelle entre A et B (en km) ?',
              answer: 2,
              tolerance: 0.01,
              unit: 'km',
              explanation:
                  '8 cm × 25 000 = 200 000 cm = 2 km.',
              points: 1,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '2. À 60 km/h, combien de minutes faut-il pour parcourir cette distance ?',
              answer: 2,
              tolerance: 0.05,
              unit: 'min',
              explanation:
                  '2 km à 60 km/h = 2/60 h × 60 min/h = 2 min.',
              points: 1,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '3. Sur la même carte, une zone réelle de 1 km² serait représentée par combien de cm² ?',
              answer: 16,
              tolerance: 0.05,
              unit: 'cm²',
              explanation:
                  '1 km = 100 000 cm = 4 cm sur carte. Aire = 4² = 16 cm².',
              points: 2,
            ),
          ],
        ),
        BrevetExercise(
          title: 'Exercice 2 — Ombre du lampadaire',
          context:
              'Un lampadaire de 6 m de haut projette une ombre de 4 m sur le '
              'sol. À côté, une personne de 1,80 m projette son ombre dans '
              'le même axe.',
          questions: <BrevetQuestion>[
            BrevetQuestion.numerical(
              prompt:
                  '1. Quelle est la longueur de l\'ombre de la personne (au dixième de mètre) ?',
              answer: 1.2,
              tolerance: 0.05,
              unit: 'm',
              explanation:
                  '1,80/6 = ombre/4 → ombre = 4 × 1,80/6 = 1,2 m (Thalès).',
              points: 2,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '2. À midi, l\'ombre du lampadaire mesure 1,5 m. Quelle est alors la longueur de l\'ombre de la personne (au dixième) ?',
              answer: 0.5,
              tolerance: 0.05,
              unit: 'm',
              explanation:
                  '1,80/6 = ombre/1,5 → ombre = 1,5 × 0,3 = 0,45 ≈ 0,5 m.',
              points: 2,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '3. Si l\'ombre d\'un arbre mesure 9 m au moment où celle du lampadaire mesure 4 m, quelle est la hauteur de l\'arbre (en m) ?',
              answer: 13.5,
              tolerance: 0.05,
              unit: 'm',
              explanation:
                  'h/9 = 6/4 → h = 9 × 1,5 = 13,5 m.',
              points: 2,
            ),
          ],
        ),
        BrevetExercise(
          title: 'Exercice 3 — Solde sur soldes',
          context:
              'Un blouson coûte 80 €. En première démarque, il est soldé à '
              '−25 %. En seconde démarque, on applique encore −20 % sur le '
              'prix soldé.',
          questions: <BrevetQuestion>[
            BrevetQuestion.numerical(
              prompt:
                  '1. Quel est le prix après la 1ʳᵉ démarque (en €) ?',
              answer: 60,
              tolerance: 0.01,
              unit: '€',
              explanation: '80 × 0,75 = 60 €.',
              points: 1,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '2. Quel est le prix final, après la 2ᵉ démarque (en €) ?',
              answer: 48,
              tolerance: 0.01,
              unit: '€',
              explanation: '60 × 0,80 = 48 €.',
              points: 2,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '3. Quel pourcentage de réduction globale a été appliqué (sur le prix initial) ?',
              answer: 40,
              tolerance: 0.05,
              unit: '%',
              explanation: '(80 − 48)/80 = 32/80 = 0,4 = 40 %.',
              points: 2,
            ),
          ],
        ),
      ],
    ),

    // ─────────────── Métropole — juin 2025 (français) ──────────
    BrevetSujet(
      id: 'brevet-metropole-2025-fr',
      title: 'Brevet — Métropole, juin 2025',
      subtitle: 'Français · texte de Simone de Beauvoir + grammaire',
      emoji: '📘',
      source: 'Métropole — juin 2025 (DNB français série générale)',
      sourceUrl:
          'https://eduscol.education.gouv.fr/sites/default/files/document/25genfrqgcme1v1pdf-116892.pdf',
      category: BrevetCategory.officialFull,
      unlockLevel: 5,
      exercises: <BrevetExercise>[
        BrevetExercise(
          title: 'Exercice 1 — Compréhension du texte',
          context:
              'Texte support : Simone de Beauvoir, La Force de l\'âge (1960).\n\n'
              'Mise en situation (Eduscol) : « La narratrice, Simone, a vingt-trois ans. '
              'Elle quitte sa ville natale, Paris, et arrive seule à Marseille. »\n\n'
              'Court extrait : « Je me rappelle mon arrivée à Marseille comme si '
              'elle avait marqué dans mon histoire un tournant absolument neuf. '
              '[…] J\'étais là, seule, les mains vides, séparée de mon passé et '
              'de tout ce que j\'aimais […]. Ici, je n\'existais pour personne ; '
              'quelque part, sous un de ces toits, j\'aurais à faire quatorze '
              'heures de cours chaque semaine […]. »\n\n'
              '➜ Texte intégral dans le PDF officiel (Eduscol ↗ depuis la tuile). '
              'Adaptation des questions du sujet réel ; certaines sont en QCM '
              'pour évaluation auto, d\'autres en réponse libre avec auto-évaluation.',
          questions: <BrevetQuestion>[
            BrevetQuestion.openEnded(
              prompt:
                  '1. Que vient faire la narratrice à Marseille ? Justifie ta réponse par DEUX citations du texte. (4 pts)',
              modelAnswer:
                  'La narratrice vient à Marseille pour prendre son premier poste d\'enseignante au lycée.\n\n'
                  'Citations attendues :\n'
                  '• « j\'aurais à faire quatorze heures de cours chaque semaine »\n'
                  '• « j\'avais rendu visite à la directrice du lycée, mon emploi du temps était fixé ».',
              explanation:
                  'Une réponse claire (« elle vient enseigner ») + 2 citations exactes courtes entre guillemets.',
              points: 4,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '2. (Lignes 1-4) À quoi voit-on que la narratrice vit un moment important de sa vie ? Donne DEUX éléments justifiés par des citations. (4 pts)',
              modelAnswer:
                  'Élément 1 : la narratrice présente ce moment comme un instant marquant rétrospectivement.\n'
                  '  → « certains se sont rétrospectivement chargés d\'un sens si lourd qu\'ils émergent de mon passé avec l\'éclat des grands événements »\n\n'
                  'Élément 2 : elle parle d\'un « tournant absolument neuf » dans son histoire.\n'
                  '  → « Je me rappelle mon arrivée à Marseille comme si elle avait marqué dans mon histoire un tournant absolument neuf ».',
              explanation:
                  'L\'idée est de mettre en évidence le caractère mémoriel et inaugural de l\'arrivée, avec deux citations distinctes.',
              points: 4,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '3. (Lignes 5-18) Qu\'est-ce qui permet de dire qu\'une vie nouvelle commence pour elle ? Donne TROIS éléments, chacun appuyé sur une citation. (6 pts)',
              modelAnswer:
                  'Élément 1 — solitude / rupture avec le passé : « j\'étais là, seule, les mains vides, séparée de mon passé ».\n\n'
                  'Élément 2 — rien n\'est préparé pour elle : « rien d\'autre n\'était prévu pour moi, pas même le lit où je dormirais ».\n\n'
                  'Élément 3 — il lui faut tout inventer : « mes occupations, mes habitudes, mes plaisirs, c\'était à moi de les inventer ».',
              explanation:
                  'Trois facettes du « renouveau » : isolement, absence de cadre, nécessité d\'inventer sa vie.',
              points: 6,
            ),
          ],
        ),
        BrevetExercise(
          title: 'Exercice 2 — Texte & image',
          context:
              'On compare le texte de Beauvoir et le tableau impressionniste '
              'ci-dessous. Frédéric Bazille, La Robe rose (1864, Musée d\'Orsay).',
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Fr%C3%A9d%C3%A9ric_Bazille_-_The_Pink_Dress_-_Google_Art_Project.jpg/500px-Fr%C3%A9d%C3%A9ric_Bazille_-_The_Pink_Dress_-_Google_Art_Project.jpg',
          imageCaption:
              'F. Bazille, La Robe rose, 1864 — Musée d\'Orsay, Paris',
          questions: <BrevetQuestion>[
            BrevetQuestion.openEnded(
              prompt:
                  '4. Comment l\'émerveillement de la narratrice pour Marseille se manifeste-t-il ? Donne DEUX procédés d\'écriture identifiés ET analysés. (6 pts)',
              modelAnswer:
                  'Procédé 1 — Énumération sensorielle (verbes d\'action + sensations).\n'
                  '  Citation : « je grimpai sur toutes ses rocailles, je rôdai dans toutes ses ruelles, je respirai le goudron et les oursins du Vieux-Port, je me mêlai aux foules de la Canebière ».\n'
                  '  Effet : l\'accumulation traduit une exploration totale et ardente, mobilisant tous les sens.\n\n'
                  'Procédé 2 — Hyperbole / métaphore amoureuse.\n'
                  '  Citation : « J\'eus le coup de foudre ».\n'
                  '  Effet : l\'expression empruntée au registre passionnel marque un émerveillement immédiat et puissant.',
              explanation:
                  'On attend deux procédés NOMMÉS + une CITATION + l\'EFFET produit.',
              points: 6,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '5. Quels traits de caractère prêtes-tu à la narratrice ? Donne TROIS traits, chacun appuyé sur une citation. (6 pts)',
              modelAnswer:
                  'Trait 1 — Indépendance / autonomie.\n'
                  '  Citation : « c\'était à moi de les inventer » (mes occupations, mes plaisirs).\n\n'
                  'Trait 2 — Courage face à l\'inconnu.\n'
                  '  Citation : « J\'étais là, seule, les mains vides » — pourtant elle reste, descend l\'escalier, explore.\n\n'
                  'Trait 3 — Curiosité / enthousiasme.\n'
                  '  Citation : « Je partis à sa découverte » et « J\'eus le coup de foudre ».',
              explanation:
                  'Trois traits cohérents (indépendance, courage, curiosité, optimisme…) chacun avec une citation distincte.',
              points: 6,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '6. (Image) Ce tableau pourrait-il illustrer le texte ? Donne TROIS arguments, chacun référencé au texte ET à l\'image. (6 pts)',
              modelAnswer:
                  'Argument 1 — Solitude / contemplation.\n'
                  '  Texte : « j\'étais là, seule, les mains vides ».\n'
                  '  Image : la jeune femme est seule, dos tourné, plongée dans la contemplation.\n\n'
                  'Argument 2 — Ouverture vers une ville inconnue.\n'
                  '  Texte : « je regardais la grande cité inconnue où j\'allais […] tailler ma vie ».\n'
                  '  Image : son regard se porte vers le village au loin, encadré par les arbres.\n\n'
                  'Argument 3 — Lumière et chaleur du Sud.\n'
                  '  Texte : « Sous le ciel bleu, des tuiles ensoleillées […] odeur d\'herbes brûlées ».\n'
                  '  Image : tons chauds, lumière vive, ciel clair — atmosphère méridionale.',
              explanation:
                  'Trois arguments avec à chaque fois une mise en relation texte ↔ image.',
              points: 6,
            ),
          ],
        ),
        BrevetExercise(
          title: 'Exercice 3 — Grammaire & langue (18 pts)',
          context:
              'Travail sur la langue à partir du texte de Beauvoir.',
          questions: <BrevetQuestion>[
            BrevetQuestion.qcm(
              prompt:
                  '7a. « J\'étais là, seule, les mains vides » — quelle est la classe (nature) grammaticale de « seule » ?',
              choices: <String>[
                'Adverbe',
                'Adjectif qualificatif',
                'Pronom',
                'Nom commun',
              ],
              answerIndex: 1,
              explanation:
                  '« seule » est un adjectif qualificatif (épithète détaché de la narratrice).',
              points: 1,
            ),
            BrevetQuestion.qcm(
              prompt:
                  '7b. Pourquoi « seule » prend-il un -e final ?',
              choices: <String>[
                'Parce qu\'il s\'accorde avec « mains » (féminin pluriel)',
                'Parce qu\'il s\'accorde avec la narratrice « je » (féminin singulier)',
                'Parce que c\'est un adverbe invariable mais avec un e d\'origine',
                'Parce qu\'il est attribut du COD',
              ],
              answerIndex: 1,
              explanation:
                  'L\'adjectif s\'accorde en genre et nombre avec le mot qu\'il qualifie : ici « je » (la narratrice, féminin singulier).',
              points: 1,
            ),
            BrevetQuestion.qcm(
              prompt:
                  '8b. « j\'avais rendu visite à la directrice du lycée, mon emploi du temps était fixé » — comment les deux propositions sont-elles reliées ?',
              choices: <String>[
                'Par une conjonction de coordination',
                'Par un pronom relatif',
                'Sans mot de liaison : juxtaposition (virgule)',
                'Par une conjonction de subordination',
              ],
              answerIndex: 2,
              explanation:
                  'Les deux propositions sont seulement séparées par une virgule, sans mot de liaison : elles sont juxtaposées.',
              points: 1,
            ),
            BrevetQuestion.qcm(
              prompt:
                  '9a. « je m\'immobilisai en haut du grand escalier » — analyse du verbe « m\'immobilisai » : quels sont ses 3 éléments ?',
              choices: <String>[
                'préfixe im- + radical -mobil- + désinence -isai',
                'auxiliaire + participe + adverbe',
                'pronom + préposition + verbe',
                'préfixe in- + radical -mobile- + suffixe verbal',
              ],
              answerIndex: 0,
              explanation:
                  'préfixe « im- » (négation), radical « -mobil- » (sur « mobile »), terminaison « -isai » (verbe du 1ᵉʳ groupe au passé simple).',
              points: 1,
            ),
            BrevetQuestion.qcm(
              prompt:
                  '9b. Quel mot appartient à la même famille que « immobiliser » ?',
              choices: <String>[
                'mobiliser',
                'immobile',
                'mobilité',
                'tous les précédents',
              ],
              answerIndex: 3,
              explanation:
                  'Tous ces mots partagent le radical « mobil- » (de « mouvoir »).',
              points: 1,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '10. Réécriture (10 pts). Réécris le passage en remplaçant « je » par « nous » (la narratrice et une amie) :\n\n'
                  '« J\'étais là, seule, les mains vides, séparée de mon passé '
                  'et de tout ce que j\'aimais, et je regardais la grande cité '
                  'inconnue où j\'allais sans secours tailler au jour le jour '
                  'ma vie. Jusqu\'alors, j\'avais dépendu étroitement d\'autrui ; '
                  'on m\'avait imposé des cadres et des buts. »',
              modelAnswer:
                  '« Nous étions là, seules, les mains vides, séparées de notre '
                  'passé et de tout ce que nous aimions, et nous regardions la '
                  'grande cité inconnue où nous allions sans secours tailler au '
                  'jour le jour notre vie. Jusqu\'alors, nous avions dépendu '
                  'étroitement d\'autrui ; on nous avait imposé des cadres et '
                  'des buts. »',
              explanation:
                  'Toutes les marques de la 1ʳᵉ pers du sing passent à la 1ʳᵉ pers du pluriel : « j\' / je → nous », accords en pluriel féminin (« seules », « séparées »), possessifs « mon/ma → notre », « m\' → nous », imparfait au pluriel.',
              points: 10,
            ),
          ],
        ),
      ],
    ),

    // ─────────── Métropole — juin 2025 (HG-EMC) ───────────
    BrevetSujet(
      id: 'brevet-metropole-2025-hg',
      title: 'Brevet — Métropole, juin 2025',
      subtitle:
          'Hist-Géo-EMC · vallée de la batterie + décolonisation + égalité',
      emoji: '🏛️',
      source: 'Métropole — juin 2025 (DNB HG-EMC série générale)',
      sourceUrl:
          'https://eduscol.education.gouv.fr/sites/default/files/document/25genhgemcme1v3pdf-116931.pdf',
      category: BrevetCategory.officialFull,
      unlockLevel: 5,
      exercises: <BrevetExercise>[
        BrevetExercise(
          title: 'Exercice 1 — Géographie · Espaces productifs (20 pts)',
          context:
              'Thème : « Les espaces productifs et leurs évolutions ».\n\n'
              'Document 1 — Article La Voix du Nord, 3 février 2022 : la '
              'région Hauts-de-France devient la « vallée de la batterie ». '
              'Trois gigafactorys s\'y implantent (Dunkerque, Douai, Douvrin). '
              'Verkor à Dunkerque représente 2,5 milliards € d\'investissement, '
              '~2 000 emplois directs et ~5 000 indirects.\n\n'
              'Document 2 — Carte de la « vallée de la batterie » dans les '
              'Hauts-de-France (cf. PDF officiel pour la carte).',
          questions: <BrevetQuestion>[
            BrevetQuestion.openEnded(
              prompt:
                  '1. (Doc 1) Relève un extrait du texte qui définit la « gigafactory ».',
              modelAnswer:
                  '« Ces usines de fabrication de batteries et de leurs '
                  'composants ». (On accepte aussi : « la première gigafactory '
                  'de cellules de batteries bas carbone en France ».)',
              explanation:
                  'Une définition courte tirée du document 1, citée entre guillemets.',
              points: 2,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '2. (Doc 1) Identifie DEUX types d\'acteurs qui participent au développement de la « vallée de la batterie ».',
              modelAnswer:
                  '• L\'État (le président E. Macron annonce l\'implantation).\n'
                  '• La Région Hauts-de-France (60 millions € d\'aide).\n'
                  '• Les entreprises privées / industriels (Verkor, '
                  'constructeurs auto, ARIA).\n\n'
                  'Deux types parmi ces trois sont attendus.',
              explanation:
                  'On distingue acteurs publics (État, Région) et privés (entreprises).',
              points: 4,
            ),
            BrevetQuestion.qcm(
              prompt:
                  '3. (Doc 2) Où se situe la « vallée de la batterie » ?',
              choices: <String>[
                'Dans le Sud-Ouest',
                'Dans la région Hauts-de-France (Nord)',
                'En Auvergne-Rhône-Alpes',
                'En Île-de-France',
              ],
              answerIndex: 1,
              explanation:
                  'Dunkerque, Douai, Douvrin : tous situés dans les Hauts-de-France.',
              points: 2,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '4. (Doc 2) Caractérise le type d\'espace productif auquel la « vallée de la batterie » appartient.',
              modelAnswer:
                  'Espace productif INDUSTRIEL, plus précisément un '
                  'technopôle / pôle de compétitivité spécialisé dans la '
                  'mobilité électrique (filière batterie + automobile). '
                  'Logique de cluster : concentration d\'entreprises d\'un '
                  'même secteur sur un territoire.',
              explanation:
                  'Mots-clés : industriel, automobile, cluster, pôle de compétitivité.',
              points: 4,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '5. (Doc 1 + 2) Montre que la « vallée de la batterie » a des atouts qui favorisent l\'implantation des gigafactorys ET qu\'elle est un espace productif important pour la région.',
              modelAnswer:
                  'Atouts :\n'
                  '• Grand port maritime de Dunkerque (ouverture mer du Nord).\n'
                  '• Tradition industrielle automobile (main d\'œuvre qualifiée).\n'
                  '• Réseau de transports denses (autoroutes, fret).\n'
                  '• Soutien des pouvoirs publics (État + Région).\n\n'
                  'Importance pour la région :\n'
                  '• Investissement de 2,5 milliards € (Verkor).\n'
                  '• 2 000 emplois directs + 5 000 indirects.\n'
                  '• Renouveau industriel via l\'électrique.',
              explanation:
                  '2-3 atouts + 2-3 éléments d\'importance économique.',
              points: 8,
            ),
          ],
        ),
        BrevetExercise(
          title: 'Exercice 2 — Histoire · Le monde depuis 1945 (20 pts)',
          context:
              'Thème : « Le monde depuis 1945 ». Cet exercice combine un '
              'développement construit (~20 lignes) sur l\'accès à '
              'l\'indépendance d\'une colonie, et un travail sur des repères '
              'historiques (frise chronologique).',
          questions: <BrevetQuestion>[
            BrevetQuestion.openEnded(
              prompt:
                  '1. Développement construit (~20 lignes) : explique l\'accès à l\'indépendance d\'une colonie de ton choix. Précise les principaux acteurs, les étapes et les conséquences.',
              modelAnswer:
                  'Exemple — INDÉPENDANCE DE L\'ALGÉRIE (1962)\n\n'
                  'Acteurs :\n'
                  '• Le FLN (Front de Libération Nationale) côté algérien.\n'
                  '• La France (gouvernement, IVe puis Vᵉ Rép. de De Gaulle), '
                  'l\'armée, les pieds-noirs.\n\n'
                  'Étapes :\n'
                  '• 1ᵉʳ nov 1954 : « Toussaint rouge » → début de la guerre.\n'
                  '• 1956 : intensification, bataille d\'Alger (1957).\n'
                  '• 1958 : crise du 13 mai, retour de De Gaulle.\n'
                  '• 1961 : putsch des généraux à Alger.\n'
                  '• 18 mars 1962 : accords d\'Évian.\n'
                  '• 5 juillet 1962 : indépendance proclamée.\n\n'
                  'Conséquences :\n'
                  '• Exode des pieds-noirs (~1 M).\n'
                  '• Drame des harkis.\n'
                  '• Pertes humaines lourdes.\n'
                  '• Naissance de la République algérienne.\n'
                  '• En France : Vᵉ Rép. consolidée, traumatisme durable.\n\n'
                  '(Autres exemples acceptés : Inde 1947, Vietnam 1954, '
                  'Maroc/Tunisie 1956…)',
              explanation:
                  'Acteurs (≥2), étapes datées (≥3), conséquences (≥2). ~20 lignes.',
              points: 12,
            ),
            BrevetQuestion.qcm(
              prompt: '2a. (Repère) Année de la chute du mur de Berlin ?',
              choices: <String>['1985', '1989', '1991', '1995'],
              answerIndex: 1,
              explanation: '9 novembre 1989.',
              points: 2,
            ),
            BrevetQuestion.qcm(
              prompt: '2b. (Repère) Année de la naissance de l\'ONU ?',
              choices: <String>['1919', '1945', '1947', '1948'],
              answerIndex: 1,
              explanation: 'Charte de San Francisco signée le 26 juin 1945.',
              points: 2,
            ),
            BrevetQuestion.qcm(
              prompt:
                  '2c. (Repère) Année de la signature du traité de Rome ?',
              choices: <String>['1948', '1951', '1957', '1992'],
              answerIndex: 2,
              explanation:
                  'Traité de Rome signé le 25 mars 1957 (création de la CEE).',
              points: 2,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '2d. (Repère) Cite un AUTRE événement historique majeur depuis 1945 (avec son année) à placer sur la frise.',
              modelAnswer:
                  'Exemples acceptés (un seul) :\n'
                  '• 1962 : indépendance de l\'Algérie.\n'
                  '• 1968 : Mai 68 en France.\n'
                  '• 1981 : élection de F. Mitterrand.\n'
                  '• 2002 : passage à l\'euro fiduciaire.\n'
                  '• 2001 : attentats du 11 septembre.\n'
                  '• 2020 : Brexit effectif.',
              explanation:
                  'Un événement post-1945 + son année correctement datée.',
              points: 2,
            ),
          ],
        ),
        BrevetExercise(
          title: 'Exercice 3 — EMC · Égalité femmes-hommes (10 pts)',
          context:
              'Doc 1 — Affiche « L\'égalité professionnelle, ça se travaille ! » '
              'du Centre Hubertine Auclert, mettant en avant la mathématicienne '
              'Ada Lovelace.\n\n'
              'Doc 2 — Article 1ᵉʳ de la Constitution de la Vᵉ République : '
              'la France assure l\'égalité devant la loi de tous les citoyens. '
              'La loi favorise l\'égal accès des femmes et des hommes aux '
              'mandats électoraux et fonctions électives, ainsi qu\'aux '
              'responsabilités professionnelles et sociales.',
          questions: <BrevetQuestion>[
            BrevetQuestion.qcm(
              prompt:
                  '1. (Doc 1) Quelle inégalité l\'affiche met-elle en avant ?',
              choices: <String>[
                'Inégalité d\'âge à l\'embauche',
                'Inégalité femmes-hommes (sous-représentation des femmes dans les sciences/métiers)',
                'Inégalité de revenus régionaux',
                'Inégalité d\'accès aux études supérieures',
              ],
              answerIndex: 1,
              explanation:
                  'L\'affiche cible l\'inégalité de genre dans le monde pro et scientifique.',
              points: 2,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '2. (Doc 2) Relève un extrait de la Constitution qui montre que l\'égalité est une valeur de la République.',
              modelAnswer:
                  '« Elle assure l\'égalité devant la loi de tous les citoyens '
                  'sans distinction d\'origine, de race ou de religion » OU '
                  '« La loi favorise l\'égal accès des femmes et des hommes '
                  'aux mandats électoraux et fonctions électives ».',
              explanation:
                  'Une citation tirée de l\'article 1ᵉʳ mentionnant explicitement l\'égalité.',
              points: 2,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '3. L\'affiche met en avant Ada Lovelace, mathématicienne pionnière. Explique l\'intérêt de recourir à cette figure pour corriger une inégalité.',
              modelAnswer:
                  'Ada Lovelace (1815-1852) est considérée comme la 1ʳᵉ '
                  'programmeuse informatique. La mettre en avant permet :\n'
                  '• De rappeler que les femmes ont contribué très tôt aux '
                  'sciences, alors qu\'on les en a souvent invisibilisées.\n'
                  '• De proposer un modèle inspirant aux jeunes filles.\n'
                  '• De déconstruire l\'idée que les sciences seraient un '
                  'domaine « masculin par nature ».',
              explanation:
                  'Idée de modèle / représentation positive + déconstruction des stéréotypes.',
              points: 2,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '4. Tu dois rédiger un discours pour le 8 mars (Journée internationale des droits des femmes). Montre que les inégalités femmes-hommes existent encore et propose DEUX idées concrètes pour sensibiliser les élèves de ton collège.',
              modelAnswer:
                  'Constat : malgré l\'article 1ᵉʳ de la Constitution, les '
                  'inégalités persistent — écart salarial (~15 %), '
                  'sous-représentation dans les filières scientifiques et '
                  'politiques, violences faites aux femmes, partage inégal '
                  'des tâches domestiques.\n\n'
                  'Idées concrètes pour le collège :\n'
                  '• Exposition « femmes pionnières » au CDI.\n'
                  '• Atelier débat « stéréotypes de genre » en EMC.\n'
                  '• Inviter une chercheuse / ingénieure à témoigner.\n'
                  '• Concours d\'affiches sur l\'égalité.',
              explanation:
                  'Constat (chiffre / fait) + 2 idées concrètes différentes pour le collège.',
              points: 4,
            ),
          ],
        ),
      ],
    ),

    // ─────────── Métropole — juin 2025 (Maths) ──────────
    BrevetSujet(
      id: 'brevet-metropole-2025-maths',
      title: 'Brevet — Métropole, juin 2025',
      subtitle: 'Maths · probas, Pythagore, fonctions, programme de calcul',
      emoji: '🧮',
      source: 'Métropole — juin 2025 (DNB maths série générale)',
      sourceUrl:
          'https://eduscol.education.gouv.fr/sites/default/files/document/25genmatmeag1pdf-125624.pdf',
      category: BrevetCategory.officialFull,
      unlockLevel: 5,
      exercises: <BrevetExercise>[
        BrevetExercise(
          title: 'Exercice 1 — Probabilités (20 pts)',
          context:
              'On dispose de deux urnes (boules indiscernables au toucher) :\n'
              '• Urne A : 6 boules numérotées 7 ; 10 ; 12 ; 15 ; 24 ; 30.\n'
              '• Urne B : 9 boules numérotées 2 ; 5 ; 6 ; 8 ; 17 ; 18 ; 21 ; 22 ; 25.',
          questions: <BrevetQuestion>[
            BrevetQuestion.numerical(
              prompt:
                  '1. On tire une boule dans l\'urne A. Probabilité d\'obtenir un nombre PAIR ? (Donne sous forme décimale au centième.)',
              answer: 0.67,
              tolerance: 0.01,
              unit: '',
              explanation:
                  'Pairs dans A : 10, 12, 24, 30 → 4/6 = 2/3 ≈ 0,67.',
              points: 4,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '2. Justifie que la probabilité d\'obtenir un nombre premier en tirant dans l\'urne B est de 1/3.',
              modelAnswer:
                  'Nombres premiers dans B : 2, 5, 17 (3 valeurs).\n'
                  'P(premier) = 3/9 = 1/3. ✓',
              explanation:
                  'Identifier les premiers (2, 5, 17) puis simplifier 3/9 = 1/3.',
              points: 4,
            ),
            BrevetQuestion.qcm(
              prompt:
                  '3. Quelle urne contient le plus grand nombre de boules dont le numéro est un multiple de 6 ?',
              choices: <String>[
                'Urne A (3 multiples : 12, 24, 30)',
                'Urne B (2 multiples : 6, 18)',
                'Elles en ont autant',
                'Aucune des deux',
              ],
              answerIndex: 0,
              explanation:
                  'A : 12, 24, 30 (3). B : 6, 18 (2). A en a plus.',
              points: 3,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '4. Démontre que la probabilité d\'obtenir un nombre supérieur ou égal à 20 est la même quelle que soit l\'urne choisie.',
              modelAnswer:
                  'Urne A : nombres ≥ 20 → 24 ; 30 → 2 cas. P_A = 2/6 = 1/3.\n'
                  'Urne B : nombres ≥ 20 → 21 ; 22 ; 25 → 3 cas. P_B = 3/9 = 1/3.\n'
                  'Donc P_A = P_B = 1/3 : les probabilités sont égales.',
              explanation:
                  'Compter les cas favorables dans chaque urne, simplifier 2/6 et 3/9.',
              points: 4,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '5. On ajoute une boule numérotée 50 dans CHAQUE urne. La probabilité d\'obtenir un résultat ≥ 20 est-elle toujours égale quelle que soit l\'urne ?',
              modelAnswer:
                  'Urne A (7 boules) : ≥ 20 → 24, 30, 50 → 3 cas. P_A = 3/7 ≈ 0,429.\n'
                  'Urne B (10 boules) : ≥ 20 → 21, 22, 25, 50 → 4 cas. P_B = 4/10 = 2/5 = 0,4.\n'
                  '3/7 ≠ 2/5 → les probabilités NE SONT PLUS égales.',
              explanation:
                  'Comparer 3/7 et 4/10 (passer en décimal ou même dénominateur).',
              points: 5,
            ),
          ],
        ),
        BrevetExercise(
          title: 'Exercice 2 — Aquathlon, Pythagore & Thalès (23 pts)',
          context:
              'Aquathlon : course à pied + natation.\n\n'
              'Course à pied (parcours ACDEB) :\n'
              '• A, C, B alignés ; A, D, E alignés.\n'
              '• ADC est rectangle en A.\n'
              '• AC = 480 m ; CB = 120 m ; AE = 250 m ; DE = 50 m.\n\n'
              'Natation (200 m). Temps des 9 élèves :\n'
              '5 min 30 s ; 5 min 45 s ; 5 min 49 s ; 5 min 50 s ;\n'
              '6 min 00 s ; 6 min 11 s ; 6 min 12 s ; 6 min 20 s ; 6 min 40 s.',
          questions: <BrevetQuestion>[
            BrevetQuestion.openEnded(
              prompt:
                  '1. Justifie que AD = 200 m.',
              modelAnswer:
                  'D est sur [AE], donc AD = AE − DE = 250 − 50 = 200 m.',
              explanation:
                  'D est entre A et E sur une même droite.',
              points: 2,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '2. Calcule la longueur CD (en m). [Triangle ACD rectangle en A, AC = 480, AD = 200]',
              answer: 520,
              tolerance: 0.5,
              unit: 'm',
              explanation:
                  'CD² = AC² + AD² = 480² + 200² = 230 400 + 40 000 = 270 400 ; CD = √270 400 = 520 m.',
              points: 5,
              schema: RightTriangleSchema(legA: '480', legB: '200', hypo: '?'),
            ),
            BrevetQuestion.qcm(
              prompt:
                  '3a. Les droites (CD) et (BE) sont-elles parallèles ?',
              choices: <String>[
                'Oui (Thalès réciproque : AC/AB = AD/AE)',
                'Non',
                'On ne peut pas conclure',
                'Seulement si CB = DE',
              ],
              answerIndex: 0,
              explanation:
                  'AC/AB = 480/600 = 4/5 et AD/AE = 200/250 = 4/5. Les rapports sont égaux et les points sont alignés dans le même ordre → (CD)//(BE).',
              points: 4,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '3b. Calcule la mesure de l\'angle ACD au degré près.',
              answer: 23,
              tolerance: 0.6,
              unit: '°',
              explanation:
                  'tan(ACD) = AD/AC = 200/480 ≈ 0,417 ; ACD ≈ arctan(0,417) ≈ 22,6° ≈ 23°.',
              points: 4,
              schema: RightTriangleTrigSchema(
                angleLabel: '?',
                adjacent: '480',
                opposite: '200',
              ),
            ),
            BrevetQuestion.qcm(
              prompt:
                  '3c. Le parcours est validé si (CD)//(BE) ET angle ACD > 20°. Le parcours est-il validé ?',
              choices: <String>[
                'Oui, les deux conditions sont remplies',
                'Non, les droites ne sont pas parallèles',
                'Non, l\'angle est inférieur à 20°',
                'Non, aucune condition n\'est remplie',
              ],
              answerIndex: 0,
              explanation:
                  '(CD)//(BE) ✓ et angle ACD ≈ 22,6° > 20° ✓. Parcours validé.',
              points: 2,
            ),
            BrevetQuestion.qcm(
              prompt:
                  '4. Temps médian de la série natation ?',
              choices: <String>[
                '5 min 50 s',
                '6 min 00 s',
                '6 min 11 s',
                '6 min 12 s',
              ],
              answerIndex: 1,
              explanation:
                  'Série triée à 9 termes ; médiane = 5ᵉ valeur = 6 min 00 s.',
              points: 3,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '5. Un poisson rouge nage à 5 km/h. Nage-t-il plus vite que l\'élève le plus rapide ?',
              modelAnswer:
                  'Élève le plus rapide : 200 m en 5 min 30 s = 330 s.\n'
                  'Vitesse = 200 / 330 ≈ 0,606 m/s ≈ 0,606 × 3,6 ≈ 2,18 km/h.\n'
                  'Le poisson rouge (5 km/h) nage plus vite que l\'élève le plus rapide.',
              explanation:
                  'Conversion m/s → km/h : multiplier par 3,6. Comparer à 5 km/h.',
              points: 3,
            ),
          ],
        ),
        BrevetExercise(
          title: 'Exercice 3 — QCM (18 pts)',
          context:
              'Questionnaire à choix multiples, 6 questions, 3 pts chacune. '
              'Pour les questions avec figures (Q2, Q4, Q6), consulte le PDF '
              'officiel pour les schémas.',
          questions: <BrevetQuestion>[
            BrevetQuestion.qcm(
              prompt:
                  'Q1. 3 melons coûtent 8,40 €. Combien coûtent 5 melons ?',
              choices: <String>['16,40 €', '42 €', '14 €', '10,40 €'],
              answerIndex: 2,
              explanation:
                  '1 melon = 8,40/3 = 2,80 € ; 5 melons = 14 €.',
              points: 3,
            ),
            BrevetQuestion.qcm(
              prompt:
                  'Q3. Un article coûte 350 €. Son prix augmente de 20 %. Nouveau prix ?',
              choices: <String>['420 €', '330 €', '370 €', '280 €'],
              answerIndex: 0,
              explanation: '350 × 1,20 = 420 €.',
              points: 3,
            ),
            BrevetQuestion.qcm(
              prompt:
                  'Q5. Forme développée et réduite de (2x + 3)(x − 4) ?',
              choices: <String>[
                '2x² − 5x − 12',
                '2x² − 11x − 12',
                '2x² − 12',
                '3x − 1',
              ],
              answerIndex: 0,
              explanation:
                  '(2x + 3)(x − 4) = 2x² − 8x + 3x − 12 = 2x² − 5x − 12.',
              points: 3,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  'Q2 (avec figure). Quelle transformation permet de passer de la figure 1 à la figure 2 (cf. PDF) ?',
              modelAnswer:
                  'Réponse type : une rotation. (Voir le sujet officiel pour la figure et confirmer.)',
              explanation:
                  'À déterminer en visualisant les deux figures.',
              points: 3,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  'Q4 (avec figure). Aire du triangle rectangle ABC ? (Cf. dimensions sur le PDF.)',
              modelAnswer:
                  'Aire = (base × hauteur) / 2 — relève les deux côtés de l\'angle droit dans le PDF.',
              explanation:
                  'Sans la figure, à compléter en consultant le PDF.',
              points: 3,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  'Q6 (avec figure). Volume de la pyramide à base rectangulaire ? (Cf. dimensions sur le PDF.)',
              modelAnswer:
                  'V = (Aire de base × hauteur) / 3.',
              explanation:
                  'Sans la figure, à compléter en consultant le PDF.',
              points: 3,
            ),
          ],
        ),
        BrevetExercise(
          title: 'Exercice 4 — Programmes de calcul (20 pts)',
          context:
              'Programme de Zoé :\n'
              '• Choisir un nombre.\n'
              '• Soustraire 4.\n'
              '• Multiplier par 2.\n'
              '• Ajouter 8.\n\n'
              'Programme de Fred (Scratch) — équivalent à f(x) = 20x + 50.',
          questions: <BrevetQuestion>[
            BrevetQuestion.numerical(
              prompt:
                  '1. Vérifie : si on choisit 10, le programme de Zoé donne ?',
              answer: 20,
              tolerance: 0.01,
              unit: '',
              explanation: '10 − 4 = 6 ; 6 × 2 = 12 ; 12 + 8 = 20.',
              points: 2,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '2. Avec le programme de Zoé, en partant de −7, on obtient ?',
              answer: -14,
              tolerance: 0.01,
              unit: '',
              explanation: '−7 − 4 = −11 ; −11 × 2 = −22 ; −22 + 8 = −14.',
              points: 3,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '3. Zoé prétend que son programme est « magique » : le résultat est toujours le DOUBLE du nombre de départ. A-t-elle raison ?',
              modelAnswer:
                  'Soit x le nombre de départ.\n'
                  '(x − 4) × 2 + 8 = 2x − 8 + 8 = 2x.\n'
                  'Le résultat vaut bien 2x = double du nombre de départ. Zoé a raison.',
              explanation:
                  'Calcul algébrique avec x : développer puis simplifier.',
              points: 4,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '4. Démontre que le programme de Fred avec x donne 20x + 50. (Voir le programme Scratch sur le PDF.)',
              modelAnswer:
                  'Sans le détail Scratch, l\'idée : remplacer chaque opération '
                  'du programme par son effet sur x, puis développer.\n'
                  'Si Fred fait par exemple : x → x×4 → +10 → ×5, alors '
                  '(4x + 10) × 5 = 20x + 50. ✓',
              explanation:
                  'À détailler avec le programme Scratch exact (cf. PDF).',
              points: 4,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '5. Quel nombre faut-il choisir pour que le programme de Fred renvoie 75 ?',
              answer: 1.25,
              tolerance: 0.01,
              unit: '',
              explanation: '20x + 50 = 75 → 20x = 25 → x = 25/20 = 1,25.',
              points: 3,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '6. Modifie la 6ᵉ ligne du programme de Fred pour que le résultat soit toujours 20× le nombre de départ.',
              modelAnswer:
                  'Il faut retirer le terme « + 50 » du résultat final. Sur Scratch, '
                  'remplacer la ligne qui ajoute 50 par « ajouter 0 » (ou la '
                  'supprimer / soustraire 50 selon la structure du programme). '
                  'Le résultat devient alors 20x.',
              explanation:
                  'L\'idée : annuler le terme constant + 50.',
              points: 4,
            ),
          ],
        ),
        BrevetExercise(
          title: 'Exercice 5 — Achat ou Location ? (19 pts)',
          context:
              'Un garage propose 2 options :\n'
              '• Achat : 22 400 € + assurance 75 €/mois.\n'
              '• Location : 425 €/mois (assurance comprise).',
          questions: <BrevetQuestion>[
            BrevetQuestion.openEnded(
              prompt:
                  '1. Montre qu\'avec l\'option Achat, la dépense à la fin de la 1ʳᵉ année est de 23 300 €.',
              modelAnswer:
                  'Dépense = prix d\'achat + assurance × 12 mois\n'
                  '= 22 400 + 75 × 12 = 22 400 + 900 = 23 300 €. ✓',
              explanation:
                  'Prix d\'achat fixe + 12 mois d\'assurance.',
              points: 3,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '2. Après 36 mois, économie réalisée si le client choisit la Location plutôt que l\'Achat (en €) ?',
              answer: 9800,
              tolerance: 1,
              unit: '€',
              explanation:
                  'Achat sur 36 mois : 22 400 + 75 × 36 = 25 100 €.\n'
                  'Location sur 36 mois : 425 × 36 = 15 300 €.\n'
                  'Économie = 25 100 − 15 300 = 9 800 €.',
              points: 5,
            ),
            BrevetQuestion.qcm(
              prompt:
                  '3. Formule à saisir dans la cellule B3 (durée en mois en B2) pour calculer la dépense Location, étendue de B3 à F3 ?',
              choices: <String>[
                '=425*B2',
                '=B2*425+22400',
                '=B2+425',
                '=425/B2',
              ],
              answerIndex: 0,
              explanation:
                  'Location = 425 € × nombre de mois ; la formule recopiée fera B3=425*B2, C3=425*C2, etc.',
              points: 3,
            ),
            BrevetQuestion.openEnded(
              prompt:
                  '4. Donne l\'expression de f(x) qui calcule la dépense correspondant à l\'option Achat (x = nombre de mois).',
              modelAnswer:
                  'f(x) = 22 400 + 75x.\n'
                  '(Coût fixe d\'achat + 75 € d\'assurance par mois.)',
              explanation:
                  'Modèle affine : ordonnée à l\'origine (achat) + pente (assurance/mois).',
              points: 3,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '5. À partir de combien de mois l\'option Achat devient-elle plus avantageuse que la Location ? (Au mois près.)',
              answer: 64,
              tolerance: 1,
              unit: 'mois',
              explanation:
                  '22 400 + 75x = 425x → 22 400 = 350x → x = 64 mois.',
              points: 5,
            ),
          ],
        ),
      ],
    ),

    // ─────────────── Sujet 4 — Multi-disciplines ───────────────
    BrevetSujet(
      id: 'brevet-multi-2024',
      title: 'Brevet — Multi-disciplines',
      subtitle: 'Maths + Français + Hist-Géo + Sciences',
      emoji: '🎓',
      source: 'Inspiré des annales DNB — Métropole, juin 2024',
      sourceUrl:
          'https://eduscol.education.gouv.fr/5202/preparer-le-diplome-national-du-brevet-dnb-avec-les-sujets-des-annales',
      unlockLevel: 5,
      exercises: <BrevetExercise>[
        BrevetExercise(
          title: 'Exercice 1 — Maths · Géométrie',
          context:
              'Une barrière en triangle rectangle est posée à l\'angle d\'un '
              'champ pour empêcher les bêtes d\'entrer. Les deux côtés de '
              'l\'angle droit mesurent 60 cm et 80 cm.',
          schema: RightTriangleSchema(legA: '60', legB: '80', hypo: '?'),
          questions: <BrevetQuestion>[
            BrevetQuestion.numerical(
              prompt:
                  '1. Calcule la longueur de l\'hypoténuse (en cm).',
              answer: 100,
              tolerance: 0.01,
              unit: 'cm',
              explanation: '60² + 80² = 3600 + 6400 = 10 000 = 100².',
              points: 2,
            ),
            BrevetQuestion.qcm(
              prompt:
                  '2. Le triangle 60-80-100 vérifie-t-il le théorème de Pythagore ?',
              choices: <String>[
                'Oui, donc il est rectangle',
                'Oui, mais ça ne prouve rien',
                'Non',
                'On ne peut pas conclure',
              ],
              answerIndex: 0,
              explanation:
                  'La réciproque de Pythagore : si a² + b² = c², le triangle est rectangle en l\'angle opposé à c.',
              points: 2,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '3. Une barrière de même forme mais 50 % plus grande aurait quelle longueur d\'hypoténuse (en cm) ?',
              answer: 150,
              tolerance: 0.01,
              unit: 'cm',
              explanation:
                  '100 cm × 1,5 = 150 cm (les longueurs sont proportionnelles).',
              points: 1,
            ),
          ],
        ),
        BrevetExercise(
          title: 'Exercice 2 — Français · Grammaire',
          context:
              'Lis cette phrase :\n'
              '« Bien que la pluie tombât sans cesse, les enfants jouaient '
              'joyeusement dans le jardin. »',
          questions: <BrevetQuestion>[
            BrevetQuestion.qcm(
              prompt:
                  '1. Quelle est la fonction de la subordonnée « Bien que la pluie tombât sans cesse » ?',
              choices: <String>[
                'Cause',
                'Concession',
                'Conséquence',
                'Condition',
              ],
              answerIndex: 1,
              explanation:
                  '« Bien que » introduit une concession (action contraire malgré l\'opposition).',
              points: 2,
            ),
            BrevetQuestion.qcm(
              prompt: '2. À quel mode est conjugué le verbe « tombât » ?',
              choices: <String>[
                'Indicatif imparfait',
                'Subjonctif imparfait',
                'Conditionnel présent',
                'Subjonctif présent',
              ],
              answerIndex: 1,
              explanation:
                  '« Bien que » impose le subjonctif. La forme « tombât » est le subjonctif imparfait.',
              points: 2,
            ),
            BrevetQuestion.trueFalse(
              prompt:
                  '3. « joyeusement » est un adverbe qui modifie le verbe « jouaient ».',
              answer: true,
              explanation:
                  'Vrai : un adverbe modifie le sens d\'un verbe (ou d\'un adjectif/autre adverbe).',
              points: 1,
            ),
          ],
        ),
        BrevetExercise(
          title: 'Exercice 3 — Histoire · Vᵉ République',
          context:
              'La Cinquième République est née en 1958 dans le contexte de la '
              'guerre d\'Algérie. Elle a connu plusieurs alternances et '
              'révisions constitutionnelles.',
          questions: <BrevetQuestion>[
            BrevetQuestion.qcm(
              prompt:
                  '1. Qui est le fondateur de la Vᵉ République ?',
              choices: <String>[
                'Georges Pompidou',
                'Charles de Gaulle',
                'François Mitterrand',
                'Vincent Auriol',
              ],
              answerIndex: 1,
              explanation: 'Charles de Gaulle, élu en 1958.',
              points: 1,
            ),
            BrevetQuestion.qcm(
              prompt:
                  '2. En quelle année est instauré le quinquennat (mandat présidentiel de 5 ans) ?',
              choices: <String>['1958', '1981', '2000', '2007'],
              answerIndex: 2,
              explanation:
                  'Référendum du 24 septembre 2000, première application en 2002.',
              points: 1,
            ),
            BrevetQuestion.trueFalse(
              prompt:
                  '3. Le Premier ministre est élu au suffrage universel direct.',
              answer: false,
              explanation:
                  'Faux : le Premier ministre est nommé par le Président de la République.',
              points: 1,
            ),
          ],
        ),
        BrevetExercise(
          title: 'Exercice 4 — Sciences · Énergie',
          context:
              'Une famille équipe son toit avec des panneaux solaires. La '
              'puissance installée est de 3 kW. En moyenne, les panneaux '
              'produisent 4 heures par jour.',
          questions: <BrevetQuestion>[
            BrevetQuestion.numerical(
              prompt:
                  '1. Quelle énergie est produite chaque jour (en kWh) ?',
              answer: 12,
              tolerance: 0.01,
              unit: 'kWh',
              explanation: 'E = P × t = 3 × 4 = 12 kWh.',
              points: 1,
            ),
            BrevetQuestion.numerical(
              prompt:
                  '2. Sur 365 jours, combien de kWh la famille produit-elle ?',
              answer: 4380,
              tolerance: 1,
              unit: 'kWh',
              explanation: '12 × 365 = 4 380 kWh.',
              points: 1,
            ),
            BrevetQuestion.qcm(
              prompt:
                  '3. Parmi ces sources, laquelle n\'est pas renouvelable ?',
              choices: <String>['Solaire', 'Éolien', 'Charbon', 'Hydraulique'],
              answerIndex: 2,
              explanation:
                  'Le charbon est une énergie fossile, finie à l\'échelle humaine.',
              points: 1,
            ),
          ],
        ),
      ],
    ),
  ];
}
