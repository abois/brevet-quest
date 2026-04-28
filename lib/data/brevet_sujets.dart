import 'problemes_data.dart';

/// Type d'une question de brevet : numérique (saisie), QCM ou Vrai/Faux.
enum BrevetQuestionKind { numerical, qcm, trueFalse }

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
        answerIndex = 0;

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
        unit = null;

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
}

/// Un exercice : un contexte commun + plusieurs questions enchaînées.
class BrevetExercise {
  const BrevetExercise({
    required this.title,
    required this.context,
    required this.questions,
    this.schema,
  });

  final String title;
  final String context;
  final List<BrevetQuestion> questions;
  final ProblemeSchema? schema;

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
