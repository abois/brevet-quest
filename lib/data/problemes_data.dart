import '../models/chapter.dart';

/// Spécification d'un schéma à dessiner pour illustrer un problème.
sealed class ProblemeSchema {
  const ProblemeSchema();
}

/// Triangle rectangle pour Pythagore. Angle droit en bas-gauche.
class RightTriangleSchema extends ProblemeSchema {
  const RightTriangleSchema({this.legA, this.legB, this.hypo});
  final String? legA;
  final String? legB;
  final String? hypo;
}

/// Triangle ABC avec D sur [AB], E sur [AC], (DE) parallèle à (BC).
class ThalesSchema extends ProblemeSchema {
  const ThalesSchema({
    this.ad,
    this.ab,
    this.ae,
    this.ac,
    this.de,
    this.bc,
    this.butterfly = false,
  });
  final String? ad;
  final String? ab;
  final String? ae;
  final String? ac;
  final String? de;
  final String? bc;
  final bool butterfly;
}

/// Triangle rectangle pour trigo : un angle marqué + 3 côtés étiquetables.
class RightTriangleTrigSchema extends ProblemeSchema {
  const RightTriangleTrigSchema({
    required this.angleLabel,
    this.adjacent,
    this.opposite,
    this.hypotenuse,
  });
  final String angleLabel;
  final String? adjacent;
  final String? opposite;
  final String? hypotenuse;
}

class RectangleSchema extends ProblemeSchema {
  const RectangleSchema({this.width, this.height});
  final String? width;
  final String? height;
}

class TriangleSchema extends ProblemeSchema {
  const TriangleSchema({this.base, this.height});
  final String? base;
  final String? height;
}

class CircleSchema extends ProblemeSchema {
  const CircleSchema({this.radius});
  final String? radius;
}

class CuboidSchema extends ProblemeSchema {
  const CuboidSchema({this.length, this.width, this.height});
  final String? length;
  final String? width;
  final String? height;
}

class CylinderSchema extends ProblemeSchema {
  const CylinderSchema({this.radius, this.height});
  final String? radius;
  final String? height;
}

/// Scène illustrée (option B) — un dessin contextuel complet, par opposition
/// aux schémas géométriques génériques. `kind` désigne la scène à peindre,
/// `labels` les étiquettes à afficher dessus.
enum IllustratedKind {
  ladderWall,    // échelle contre mur — Pythagore
  pylon,         // pylône + câble hauban — Pythagore
  sail,          // voile triangulaire sur mât — Thalès
  cableCar,      // câble de télésiège incliné — Trigo
  roof,          // toit (triangle isocèle) — Trigo / Aire
  pizza,         // disque ; thème pizza — Aire
  pool,          // bassin circulaire vu de dessus — Aire
  tank,          // cuve cylindrique — Volume
  crate,         // pavé en perspective ; thème caisse — Volume
  field,         // terrain rectangulaire vu en plan — Aire / Pythagore
}

class IllustratedSchema extends ProblemeSchema {
  const IllustratedSchema({
    required this.kind,
    this.labels = const <String, String>{},
  });
  final IllustratedKind kind;
  final Map<String, String> labels;
}

class Probleme {
  const Probleme({
    required this.id,
    required this.theme,
    required this.statement,
    required this.answer,
    required this.tolerance,
    required this.unit,
    required this.explanation,
    required this.niveau,
    this.schema,
    this.emoji,
  });

  final String id;
  final String theme;
  final String statement;
  final double answer;
  final double tolerance;
  final String unit;
  final String explanation;
  final Niveau niveau;
  final ProblemeSchema? schema;

  /// Emoji décoratif affiché en coin du schéma (option A légère).
  final String? emoji;
}

class ProblemesData {
  const ProblemesData._();

  static const List<Probleme> all = <Probleme>[
    // ---------- PYTHAGORE (4e) ----------
    Probleme(
      id: 'pyt-1',
      theme: 'Pythagore',
      statement:
          'Pour fixer une bâche de chantier, un menuisier découpe un triangle rectangle dont les deux côtés perpendiculaires mesurent 3 m et 4 m. Quelle est la longueur du grand côté (en m) ?',
      answer: 5,
      tolerance: 0.01,
      unit: 'm',
      explanation: 'Hyp² = 3² + 4² = 9 + 16 = 25, donc hyp = 5 m.',
      niveau: Niveau.niveau4,
      emoji: '🪚',
      schema: RightTriangleSchema(legA: '3', legB: '4', hypo: '?'),
    ),
    Probleme(
      id: 'pyt-2',
      theme: 'Pythagore',
      statement:
          'Un poteau électrique de 12 m est soutenu par un câble fixé au sol à 5 m de son pied. Quelle est la longueur du câble ?',
      answer: 13,
      tolerance: 0.01,
      unit: 'm',
      explanation: 'L² = 12² + 5² = 144 + 25 = 169, donc L = 13 m.',
      niveau: Niveau.niveau4,
      emoji: '⚡',
      schema: IllustratedSchema(
        kind: IllustratedKind.pylon,
        labels: <String, String>{'base': '5', 'mast': '12', 'cable': '?'},
      ),
    ),
    Probleme(
      id: 'pyt-3',
      theme: 'Pythagore',
      statement:
          'Un terrain rectangulaire mesure 8 m sur 15 m. Quelle est la longueur de la diagonale (utile pour vérifier qu\'il est bien droit) ?',
      answer: 17,
      tolerance: 0.01,
      unit: 'm',
      explanation: '8² + 15² = 64 + 225 = 289 = 17². La diagonale mesure 17 m.',
      niveau: Niveau.niveau4,
      emoji: '🌳',
      schema: IllustratedSchema(
        kind: IllustratedKind.field,
        labels: <String, String>{'width': '15', 'height': '8', 'diag': '?'},
      ),
    ),
    Probleme(
      id: 'pyt-4',
      theme: 'Pythagore',
      statement:
          'Un toboggan rectiligne de 13 m descend d\'une plateforme située à une distance horizontale de 12 m du point d\'arrivée. À quelle hauteur se trouve la plateforme ?',
      answer: 5,
      tolerance: 0.01,
      unit: 'm',
      explanation: 'h² = 13² − 12² = 169 − 144 = 25, donc h = 5 m.',
      niveau: Niveau.niveau4,
      schema: RightTriangleSchema(legA: '12', legB: '?', hypo: '13'),
    ),
    Probleme(
      id: 'pyt-5',
      theme: 'Pythagore',
      statement:
          'Une échelle de 5 m est appuyée contre un mur. Le pied de l\'échelle est à 3 m du mur. À quelle hauteur l\'échelle touche-t-elle le mur ?',
      answer: 4,
      tolerance: 0.01,
      unit: 'm',
      explanation: 'h² = 5² − 3² = 25 − 9 = 16, donc h = 4 m.',
      niveau: Niveau.niveau4,
      emoji: '🪜',
      schema: IllustratedSchema(
        kind: IllustratedKind.ladderWall,
        labels: <String, String>{'base': '3', 'height': '?', 'ladder': '5'},
      ),
    ),
    Probleme(
      id: 'pyt-6',
      theme: 'Pythagore',
      statement:
          'Un écran de télévision a une largeur de 8 dm et une hauteur de 6 dm. Quelle est sa diagonale (en dm) ?',
      answer: 10,
      tolerance: 0.01,
      unit: 'dm',
      explanation: 'd² = 6² + 8² = 36 + 64 = 100, donc d = 10 dm.',
      niveau: Niveau.niveau4,
      schema: RectangleSchema(width: '8', height: '6'),
    ),
    Probleme(
      id: 'pyt-7',
      theme: 'Pythagore',
      statement:
          'Un grutier doit lever une charge à 24 m de hauteur. La grue est posée à 7 m horizontalement. Quelle est la longueur du câble tendu en diagonale ?',
      answer: 25,
      tolerance: 0.01,
      unit: 'm',
      explanation: '7² + 24² = 49 + 576 = 625 = 25². Câble = 25 m.',
      niveau: Niveau.niveau4,
      schema: RightTriangleSchema(legA: '7', legB: '24', hypo: '?'),
    ),
    Probleme(
      id: 'pyt-8',
      theme: 'Pythagore',
      statement:
          'Une plaque rectangulaire de 2 m sur 3 m doit être fixée par une cornière en diagonale. Quelle longueur de cornière (en m, au dixième) ?',
      answer: 3.6,
      tolerance: 0.05,
      unit: 'm',
      explanation: 'd² = 4 + 9 = 13, d = √13 ≈ 3,6 m.',
      niveau: Niveau.niveau4,
      schema: RightTriangleSchema(legA: '2', legB: '3', hypo: '?'),
    ),

    // ---------- THALÈS (4e/3e) ----------
    Probleme(
      id: 'tha-1',
      theme: 'Thalès',
      statement:
          'Pour stabiliser une voile de catamaran de 15 m de base (BC), un bout traverse parallèlement à 4 m du sommet A le long du mât (AD), sur un mât total AB de 10 m. Quelle longueur de bout faut-il (DE) ?',
      answer: 6,
      tolerance: 0.01,
      unit: 'm',
      explanation: 'DE/BC = AD/AB, donc DE = 15 × 4/10 = 6 m.',
      niveau: Niveau.niveau4,
      emoji: '⛵',
      schema: IllustratedSchema(
        kind: IllustratedKind.sail,
        labels: <String, String>{'ad': '4', 'ab': '10', 'bc': '15', 'de': '?'},
      ),
    ),
    Probleme(
      id: 'tha-2',
      theme: 'Thalès',
      statement:
          'Sur un plan d\'architecte, deux fils d\'aplomb partent du même point A. Le fil AB mesure 9 m et passe par D à 3 m de A. L\'autre côté AC mesure 12 m. À quelle distance du sommet A se trouve le point E correspondant sur l\'autre fil (avec DE parallèle à BC) ?',
      answer: 4,
      tolerance: 0.01,
      unit: 'm',
      explanation: 'AE/AC = AD/AB, donc AE = 12 × 3/9 = 4 m.',
      niveau: Niveau.niveau4,
      schema: ThalesSchema(ad: '3', ab: '9', ac: '12', ae: '?'),
    ),
    Probleme(
      id: 'tha-3',
      theme: 'Thalès',
      statement:
          'Un dessinateur agrandit un croquis : sur l\'original, AD = 5 cm pour AB = 8 cm. Si la base agrandie DE mesure 10 cm, combien mesurera BC sur l\'agrandissement ?',
      answer: 16,
      tolerance: 0.01,
      unit: 'cm',
      explanation: 'BC = DE × AB/AD = 10 × 8/5 = 16 cm.',
      niveau: Niveau.niveau4,
      schema: ThalesSchema(ad: '5', ab: '8', de: '10', bc: '?'),
    ),
    Probleme(
      id: 'tha-4',
      theme: 'Thalès',
      statement:
          'Un poteau de 6 m projette une ombre de 4 m. Au même instant, un arbre projette une ombre de 14 m. Quelle est la hauteur de l\'arbre ?',
      answer: 21,
      tolerance: 0.05,
      unit: 'm',
      explanation: 'h/14 = 6/4, donc h = 14 × 6/4 = 21 m.',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'tha-5',
      theme: 'Thalès',
      statement:
          'Deux haubans parallèles relient deux pylônes en se croisant en O. D\'un côté, OA = 3 m et OC = 4 m ; de l\'autre, OB = 6 m. Quelle est la longueur du segment OD ?',
      answer: 8,
      tolerance: 0.01,
      unit: 'm',
      explanation: 'OA/OB = OC/OD, donc OD = 6 × 4/3 = 8 m.',
      niveau: Niveau.niveau3,
      schema: ThalesSchema(ad: '3', ab: '6', ae: '4', ac: '?', butterfly: true),
    ),
    Probleme(
      id: 'tha-6',
      theme: 'Thalès',
      statement:
          'Sur un patron de couture, un trait parallèle à la base BC sépare la pièce. AD = 6 cm, DB = 4 cm, AE = 9 cm. Quelle est la longueur EC à découper ?',
      answer: 6,
      tolerance: 0.01,
      unit: 'cm',
      explanation: 'AB = 10, AC = AE × AB/AD = 9 × 10/6 = 15, donc EC = 15 − 9 = 6 cm.',
      niveau: Niveau.niveau4,
      schema: ThalesSchema(ad: '6', ab: '10', ae: '9', ac: '?'),
    ),

    // ---------- TRIGONOMÉTRIE (3e) ----------
    Probleme(
      id: 'trig-1',
      theme: 'Trigonométrie',
      statement:
          'Un télésiège fait un angle de 60° avec l\'horizontale au sol. La distance horizontale parcourue est de 5 m. Quelle est la longueur du câble (au dixième) ?',
      answer: 10,
      tolerance: 0.05,
      unit: 'm',
      explanation: 'cos(60°) = adj/hyp = 5/hyp = 0,5, donc hyp = 10 m.',
      niveau: Niveau.niveau3,
      emoji: '🚡',
      schema: IllustratedSchema(
        kind: IllustratedKind.cableCar,
        labels: <String, String>{'angle': '60°', 'base': '5', 'cable': '?'},
      ),
    ),
    Probleme(
      id: 'trig-2',
      theme: 'Trigonométrie',
      statement:
          'La pente d\'un toit fait 30° par rapport à l\'horizontale. Le chevron (côté oblique) mesure 12 m. À quelle hauteur arrive le faîte du toit ?',
      answer: 6,
      tolerance: 0.05,
      unit: 'm',
      explanation: 'sin(30°) = opposé/12 = 0,5, donc opp = 6 m.',
      niveau: Niveau.niveau3,
      emoji: '🏠',
      schema: IllustratedSchema(
        kind: IllustratedKind.roof,
        labels: <String, String>{'angle': '30°', 'rafter': '12', 'height': '?'},
      ),
    ),
    Probleme(
      id: 'trig-3',
      theme: 'Trigonométrie',
      statement:
          'Un escalier monte avec un angle de 45°. La longueur au sol est de 7 m. À quelle hauteur arrive-t-il ?',
      answer: 7,
      tolerance: 0.05,
      unit: 'm',
      explanation: 'tan(45°) = 1, donc hauteur = base = 7 m.',
      niveau: Niveau.niveau3,
      schema: RightTriangleTrigSchema(
        angleLabel: '45°',
        adjacent: '7',
        opposite: '?',
      ),
    ),
    Probleme(
      id: 'trig-4',
      theme: 'Trigonométrie',
      statement:
          'Un panneau solaire mesure 4 m en hauteur et 3 m à la base. Quel angle fait-il avec le sol (au degré près) ?',
      answer: 53,
      tolerance: 0.6,
      unit: '°',
      explanation: 'tan(angle) = 4/3 ≈ 1,33, donc angle ≈ arctan(1,33) ≈ 53°.',
      niveau: Niveau.niveau3,
      schema: RightTriangleTrigSchema(
        angleLabel: '?',
        adjacent: '3',
        opposite: '4',
      ),
    ),
    Probleme(
      id: 'trig-5',
      theme: 'Trigonométrie',
      statement:
          'Une rampe d\'accès fait 5 m de long et s\'élève de 1 m. Quel est l\'angle de la pente, au degré près ?',
      answer: 12,
      tolerance: 0.6,
      unit: '°',
      explanation: 'sin(angle) = 1/5 = 0,2, donc angle ≈ arcsin(0,2) ≈ 12°.',
      niveau: Niveau.niveau3,
    ),
    Probleme(
      id: 'trig-6',
      theme: 'Trigonométrie',
      statement:
          'Un téléphérique parcourt 10 m en oblique en avançant de 8 m horizontalement. Quel angle de pente fait-il avec le sol (au degré près) ?',
      answer: 37,
      tolerance: 0.6,
      unit: '°',
      explanation: 'cos(angle) = 8/10 = 0,8, donc angle ≈ arccos(0,8) ≈ 37°.',
      niveau: Niveau.niveau3,
      schema: RightTriangleTrigSchema(
        angleLabel: '?',
        adjacent: '8',
        hypotenuse: '10',
      ),
    ),

    // ---------- AIRES (4e/3e) ----------
    Probleme(
      id: 'air-1',
      theme: 'Aire',
      statement:
          'Une chambre rectangulaire mesure 8 m sur 5 m. Quelle surface de moquette faut-il acheter (en m²) ?',
      answer: 40,
      tolerance: 0.01,
      unit: 'm²',
      explanation: 'Aire = 8 × 5 = 40 m².',
      niveau: Niveau.niveau4,
      schema: RectangleSchema(width: '8', height: '5'),
    ),
    Probleme(
      id: 'air-2',
      theme: 'Aire',
      statement:
          'Un terrain triangulaire a une base de 10 m et une hauteur (perpendiculaire) de 6 m. Quelle est sa superficie ?',
      answer: 30,
      tolerance: 0.01,
      unit: 'm²',
      explanation: 'Aire = (base × hauteur) / 2 = 60 / 2 = 30 m².',
      niveau: Niveau.niveau4,
      schema: TriangleSchema(base: '10', height: '6'),
    ),
    Probleme(
      id: 'air-3',
      theme: 'Aire',
      statement:
          'Une pizza a un rayon de 5 cm dans son assiette. Quelle est l\'aire de pizza (π ≈ 3,14) ?',
      answer: 78.5,
      tolerance: 0.5,
      unit: 'cm²',
      explanation: 'Aire = π × r² = 3,14 × 25 = 78,5 cm².',
      niveau: Niveau.niveau4,
      emoji: '🍕',
      schema: IllustratedSchema(
        kind: IllustratedKind.pizza,
        labels: <String, String>{'radius': '5'},
      ),
    ),
    Probleme(
      id: 'air-4',
      theme: 'Aire',
      statement:
          'Une terrasse carrée de 7 m de côté doit être pavée. Quelle surface en m² ?',
      answer: 49,
      tolerance: 0.01,
      unit: 'm²',
      explanation: 'Aire = 7 × 7 = 49 m².',
      niveau: Niveau.niveau4,
      schema: RectangleSchema(width: '7', height: '7'),
    ),
    Probleme(
      id: 'air-5',
      theme: 'Aire',
      statement:
          'Un panneau publicitaire en forme de parallélogramme mesure 9 m de base et 4 m de hauteur. Quelle est sa surface ?',
      answer: 36,
      tolerance: 0.01,
      unit: 'm²',
      explanation: 'Aire = base × hauteur = 9 × 4 = 36 m².',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'air-6',
      theme: 'Aire',
      statement:
          'Une table ronde a un diamètre de 8 dm. Quelle est sa surface en dm² (π ≈ 3,14) ?',
      answer: 50.24,
      tolerance: 0.5,
      unit: 'dm²',
      explanation: 'r = 4 dm, Aire = 3,14 × 16 = 50,24 dm².',
      niveau: Niveau.niveau4,
      schema: CircleSchema(radius: '4'),
    ),
    Probleme(
      id: 'air-7',
      theme: 'Aire',
      statement:
          'Une voile triangulaire rectangle a deux côtés perpendiculaires de 6 m et 9 m. Quelle quantité de toile (en m²) ?',
      answer: 27,
      tolerance: 0.01,
      unit: 'm²',
      explanation: 'Aire = (6 × 9) / 2 = 27 m².',
      niveau: Niveau.niveau4,
      schema: RightTriangleSchema(legA: '6', legB: '9'),
    ),

    // ---------- VOLUMES (3e) ----------
    Probleme(
      id: 'vol-1',
      theme: 'Volume',
      statement:
          'Un cube de stockage a une arête de 4 m. Quel est son volume utile (en m³) ?',
      answer: 64,
      tolerance: 0.01,
      unit: 'm³',
      explanation: 'V = 4³ = 64 m³.',
      niveau: Niveau.niveau3,
      schema: CuboidSchema(length: '4', width: '4', height: '4'),
    ),
    Probleme(
      id: 'vol-2',
      theme: 'Volume',
      statement:
          'Un colis a pour dimensions 5 dm × 3 dm × 4 dm. Quel est son volume (en dm³, soit en litres) ?',
      answer: 60,
      tolerance: 0.01,
      unit: 'L',
      explanation: 'V = 5 × 3 × 4 = 60 dm³ = 60 L.',
      niveau: Niveau.niveau3,
      schema: CuboidSchema(length: '5', width: '3', height: '4'),
    ),
    Probleme(
      id: 'vol-3',
      theme: 'Volume',
      statement:
          'Une cuve cylindrique a un rayon intérieur de 3 dm et une hauteur de 10 dm. Combien peut-elle contenir d\'eau (en litres, π ≈ 3,14) ?',
      answer: 282.6,
      tolerance: 1,
      unit: 'L',
      explanation: 'V = π × r² × h = 3,14 × 9 × 10 = 282,6 dm³ = 282,6 L.',
      niveau: Niveau.niveau3,
      emoji: '💧',
      schema: IllustratedSchema(
        kind: IllustratedKind.tank,
        labels: <String, String>{'radius': '3', 'height': '10'},
      ),
    ),
    Probleme(
      id: 'vol-4',
      theme: 'Volume',
      statement:
          'Un entonnoir conique a un rayon de 3 cm et une hauteur de 4 cm. Quel est son volume (en cm³, π ≈ 3,14) ?',
      answer: 37.68,
      tolerance: 0.5,
      unit: 'cm³',
      explanation: 'V = π × r² × h / 3 = 3,14 × 9 × 4 / 3 ≈ 37,68 cm³.',
      niveau: Niveau.niveau3,
    ),
    Probleme(
      id: 'vol-5',
      theme: 'Volume',
      statement:
          'Un aquarium en forme de pavé droit mesure 60 cm × 30 cm × 40 cm. Quel est son volume en litres ? (1 L = 1000 cm³)',
      answer: 72,
      tolerance: 0.5,
      unit: 'L',
      explanation: 'V = 72 000 cm³ = 72 L.',
      niveau: Niveau.niveau3,
      schema: CuboidSchema(length: '60', width: '30', height: '40'),
    ),

    // ---------- POURCENTAGES (4e) ----------
    Probleme(
      id: 'pct-1',
      theme: 'Pourcentage',
      statement:
          'Un article coûte 60 €. Il bénéficie d\'une remise de 20 %. Quel est le prix après remise ?',
      answer: 48,
      tolerance: 0.01,
      unit: '€',
      explanation: 'Remise = 20 % × 60 = 12 €. Prix = 60 − 12 = 48 €.',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'pct-2',
      theme: 'Pourcentage',
      statement:
          'Un loyer de 800 € augmente de 5 %. Quel est le nouveau loyer ?',
      answer: 840,
      tolerance: 0.01,
      unit: '€',
      explanation: 'Augmentation = 5 % × 800 = 40 €. Nouveau loyer = 840 €.',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'pct-3',
      theme: 'Pourcentage',
      statement:
          'Dans une classe de 25 élèves, 18 portent des lunettes. Quel pourcentage cela représente-t-il ?',
      answer: 72,
      tolerance: 0.05,
      unit: '%',
      explanation: '18/25 = 0,72 = 72 %.',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'pct-4',
      theme: 'Pourcentage',
      statement:
          'Un prix HT de 50 € est soumis à une TVA de 20 %. Quel est le prix TTC ?',
      answer: 60,
      tolerance: 0.01,
      unit: '€',
      explanation: 'TVA = 50 × 0,20 = 10 €. TTC = 50 + 10 = 60 €.',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'pct-5',
      theme: 'Pourcentage',
      statement:
          'Un article voit son prix augmenter de 10 % puis diminuer de 10 %. Si son prix initial était 100 €, quel est son prix final ?',
      answer: 99,
      tolerance: 0.01,
      unit: '€',
      explanation: '100 × 1,1 = 110, puis 110 × 0,9 = 99 €.',
      niveau: Niveau.niveau4,
    ),

    // ---------- ÉQUATIONS 1er DEGRÉ (4e) ----------
    Probleme(
      id: 'eq-1',
      theme: 'Équation',
      statement:
          'Un taxi facture 7 € de prise en charge plus 3 € par kilomètre. Pour une course à 22 €, combien de kilomètres ont été parcourus ?',
      answer: 5,
      tolerance: 0.01,
      unit: 'km',
      explanation: '3x + 7 = 22, donc 3x = 15 et x = 5 km.',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'eq-2',
      theme: 'Équation',
      statement:
          'Une carte de fidélité a une remise fixe de 5 €. Le client paie 11 € après remise pour 2 produits identiques. Quel est le prix unitaire avant remise ?',
      answer: 8,
      tolerance: 0.01,
      unit: '€',
      explanation: '2x − 5 = 11, donc 2x = 16 et x = 8 €.',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'eq-3',
      theme: 'Équation',
      statement:
          'Un abonnement A coûte 4 €/mois + 3 € de mise en service ; un abonnement B coûte 2 €/mois + 11 € de mise en service. Au bout de combien de mois les deux factures sont-elles égales ?',
      answer: 4,
      tolerance: 0.01,
      unit: 'mois',
      explanation: '4x + 3 = 2x + 11, donc 2x = 8 et x = 4 mois.',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'eq-4',
      theme: 'Équation',
      statement:
          'Un commerçant vend 5 lots à 2 € de moins que le prix unitaire affiché. Il encaisse 20 €. Quel était le prix affiché par unité ?',
      answer: 6,
      tolerance: 0.01,
      unit: '€',
      explanation: '5(x − 2) = 20, donc x − 2 = 4 et x = 6 €.',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'eq-5',
      theme: 'Équation',
      statement:
          'Un employé met chaque mois le tiers de sa prime de côté, plus 2 € fixes. Il a économisé 5 € ce mois-ci. À combien s\'élevait la prime ?',
      answer: 9,
      tolerance: 0.01,
      unit: '€',
      explanation: 'x/3 + 2 = 5, donc x/3 = 3 et x = 9 €.',
      niveau: Niveau.niveau4,
    ),

    // ---------- FONCTIONS (3e) ----------
    Probleme(
      id: 'fct-1',
      theme: 'Fonction',
      statement:
          'Une salle de sport facture 3 € d\'entrée + 2 €/heure. Combien coûtent 5 heures ?',
      answer: 13,
      tolerance: 0.01,
      unit: '€',
      explanation: 'f(x) = 2x + 3, f(5) = 10 + 3 = 13 €.',
      niveau: Niveau.niveau3,
    ),
    Probleme(
      id: 'fct-2',
      theme: 'Fonction',
      statement:
          'Avec le tarif "3 € + 2 €/heure", un client paie 11 €. Combien d\'heures a-t-il consommé ?',
      answer: 4,
      tolerance: 0.01,
      unit: 'h',
      explanation: '2x + 3 = 11, donc x = 4 heures.',
      niveau: Niveau.niveau3,
    ),
    Probleme(
      id: 'fct-3',
      theme: 'Fonction',
      statement:
          'Un réservoir contient 7 L et perd 1 L par jour. Combien reste-t-il après 2 jours ?',
      answer: 5,
      tolerance: 0.01,
      unit: 'L',
      explanation: 'g(x) = −x + 7, g(2) = 5 L.',
      niveau: Niveau.niveau3,
    ),
    Probleme(
      id: 'fct-4',
      theme: 'Fonction',
      statement:
          'Un livreur facture 3 €/colis − 5 € de remise fidélité. Combien de colis pour une facture de 10 € ?',
      answer: 5,
      tolerance: 0.01,
      unit: 'colis',
      explanation: '3x − 5 = 10, donc x = 5 colis.',
      niveau: Niveau.niveau3,
    ),

    // ---------- ARITHMÉTIQUE (3e) ----------
    Probleme(
      id: 'arit-1',
      theme: 'PGCD',
      statement:
          'Un fleuriste a 36 roses et 48 tulipes. Il veut composer le maximum de bouquets identiques sans qu\'il reste de fleurs. Combien de bouquets pourra-t-il faire ?',
      answer: 12,
      tolerance: 0.01,
      unit: 'bouquets',
      explanation: 'PGCD(36, 48) = 12 → 12 bouquets de 3 roses et 4 tulipes.',
      niveau: Niveau.niveau3,
    ),
    Probleme(
      id: 'arit-2',
      theme: 'PGCD',
      statement:
          'Une école dispose de 45 cahiers et 75 stylos à répartir équitablement entre des classes. Combien de classes au maximum sans qu\'il en reste ?',
      answer: 15,
      tolerance: 0.01,
      unit: 'classes',
      explanation: 'PGCD(45, 75) = 15 → 15 classes (3 cahiers et 5 stylos chacune).',
      niveau: Niveau.niveau3,
    ),
    Probleme(
      id: 'arit-3',
      theme: 'PGCD',
      statement:
          'Un libraire range 56 BD et 98 romans en piles identiques (même nombre par pile, même type). Combien de piles au maximum ?',
      answer: 14,
      tolerance: 0.01,
      unit: 'piles',
      explanation: 'PGCD(56, 98) = 14 → 14 piles de 4 BD ou 7 romans.',
      niveau: Niveau.niveau3,
    ),
    Probleme(
      id: 'arit-4',
      theme: 'Identité remarquable',
      statement:
          'Pour calculer rapidement 102² (par exemple en compta), on écrit (100 + 2)². Quel est le résultat ?',
      answer: 10404,
      tolerance: 0.5,
      unit: '',
      explanation: '(100 + 2)² = 10000 + 400 + 4 = 10404.',
      niveau: Niveau.niveau3,
    ),

    // ---------- PYTHAGORE supplémentaires ----------
    Probleme(
      id: 'pyt-9',
      theme: 'Pythagore',
      statement:
          'Un drone d\'inspection survole un rectangle de 12 m sur 16 m. Quelle distance pour traverser en diagonale ?',
      answer: 20,
      tolerance: 0.01,
      unit: 'm',
      explanation: 'd² = 144 + 256 = 400, donc d = 20 m.',
      niveau: Niveau.niveau4,
      schema: RectangleSchema(width: '16', height: '12'),
    ),
    Probleme(
      id: 'pyt-10',
      theme: 'Pythagore',
      statement:
          'Un panneau de chantier rectangulaire est étayé par une diagonale. Les côtés mesurent 9 m et 12 m. Quelle longueur pour l\'étai diagonal ?',
      answer: 15,
      tolerance: 0.01,
      unit: 'm',
      explanation: 'd² = 81 + 144 = 225, donc d = 15 m.',
      niveau: Niveau.niveau4,
      schema: RightTriangleSchema(legA: '9', legB: '12', hypo: '?'),
    ),
    Probleme(
      id: 'pyt-11',
      theme: 'Pythagore',
      statement:
          'Une échelle de 6 m est posée à 4 m d\'un mur. À quelle hauteur touche-t-elle le mur, arrondi au dixième ?',
      answer: 4.5,
      tolerance: 0.05,
      unit: 'm',
      explanation: 'h² = 36 − 16 = 20, h ≈ 4,5 m.',
      niveau: Niveau.niveau4,
      schema: RightTriangleSchema(legA: '4', legB: '?', hypo: '6'),
    ),
    Probleme(
      id: 'pyt-12',
      theme: 'Pythagore',
      statement:
          'Un fil tendu de 25 m relie le sommet d\'un mât (24 m de haut) à un piquet au sol. À quelle distance du pied du mât est planté le piquet ?',
      answer: 7,
      tolerance: 0.01,
      unit: 'm',
      explanation: 'd² = 25² − 24² = 49, donc d = 7 m.',
      niveau: Niveau.niveau4,
      schema: RightTriangleSchema(legA: '?', legB: '24', hypo: '25'),
    ),
    Probleme(
      id: 'pyt-13',
      theme: 'Pythagore',
      statement:
          'Une pièce carrée de 5 m de côté. Quelle longueur de câble passe en diagonale d\'un coin à l\'autre (au dixième) ?',
      answer: 7.1,
      tolerance: 0.05,
      unit: 'm',
      explanation: 'd² = 5² + 5² = 50, d = 5√2 ≈ 7,1 m.',
      niveau: Niveau.niveau4,
      schema: RectangleSchema(width: '5', height: '5'),
    ),
    Probleme(
      id: 'pyt-14',
      theme: 'Pythagore',
      statement:
          'Un mât est haubané : un câble part du sommet du mât (de 12 m de haut) jusqu\'à un point au sol situé à 5 m du pied. Quelle est la longueur du câble ?',
      answer: 13,
      tolerance: 0.01,
      unit: 'm',
      explanation: 'Câble² = 12² + 5² = 169, câble = 13 m.',
      niveau: Niveau.niveau4,
      schema: RightTriangleSchema(legA: '5', legB: '12', hypo: '?'),
    ),

    // ---------- THALÈS supplémentaires ----------
    Probleme(
      id: 'tha-7',
      theme: 'Thalès',
      statement:
          'Sur un photomontage à l\'échelle, le bord BC mesure 12 cm. Un trait parallèle à 6 cm du sommet (sur 9 cm au total) marque la zone de cadrage. Quelle est la largeur DE de cette zone ?',
      answer: 8,
      tolerance: 0.01,
      unit: 'cm',
      explanation: 'DE = BC × AD/AB = 12 × 6/9 = 8 cm.',
      niveau: Niveau.niveau4,
      schema: ThalesSchema(ad: '6', ab: '9', bc: '12', de: '?'),
    ),
    Probleme(
      id: 'tha-8',
      theme: 'Thalès',
      statement:
          'Sur une carte au 1/25 000, deux villes sont distantes de 8 cm. Quelle est la distance réelle en km ?',
      answer: 2,
      tolerance: 0.01,
      unit: 'km',
      explanation: '8 × 25 000 = 200 000 cm = 2 km.',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'tha-9',
      theme: 'Thalès',
      statement:
          'Deux gouttières parallèles se croisent en O avec un raccord en X. D\'un côté OA = 4 m et OC = 6 m ; de l\'autre OB = 10 m. Quelle longueur OD pour finir la pose ?',
      answer: 15,
      tolerance: 0.01,
      unit: 'm',
      explanation: 'OA/OB = OC/OD, donc OD = 6 × 10/4 = 15 m.',
      niveau: Niveau.niveau3,
      schema: ThalesSchema(ad: '4', ab: '10', ae: '6', ac: '?', butterfly: true),
    ),

    // ---------- TRIGO supplémentaires ----------
    Probleme(
      id: 'trig-7',
      theme: 'Trigonométrie',
      statement:
          'Une nacelle est installée à 60° par rapport à l\'horizontale via un câble de 20 m. Quelle distance horizontale au pied (au dixième) ?',
      answer: 10,
      tolerance: 0.05,
      unit: 'm',
      explanation: 'cos(60°) = adj/20 = 0,5, donc adj = 10 m.',
      niveau: Niveau.niveau3,
      schema: RightTriangleTrigSchema(
        angleLabel: '60°',
        adjacent: '?',
        hypotenuse: '20',
      ),
    ),
    Probleme(
      id: 'trig-8',
      theme: 'Trigonométrie',
      statement:
          'Un topographe vise depuis un point une cible située à 5 m de hauteur, distant de 13 m en oblique. Quel est l\'angle de visée (au degré près) ?',
      answer: 23,
      tolerance: 0.6,
      unit: '°',
      explanation: 'sin(angle) = 5/13 ≈ 0,385, angle ≈ 23°.',
      niveau: Niveau.niveau3,
      schema: RightTriangleTrigSchema(
        angleLabel: '?',
        opposite: '5',
        hypotenuse: '13',
      ),
    ),
    Probleme(
      id: 'trig-9',
      theme: 'Trigonométrie',
      statement:
          'Une rampe d\'accès s\'élève avec un angle de 8°. Sa longueur au sol est de 10 m. Quelle hauteur atteint-elle, arrondi au dixième ?',
      answer: 1.4,
      tolerance: 0.1,
      unit: 'm',
      explanation: 'tan(8°) ≈ 0,1405, donc h ≈ 10 × 0,14 ≈ 1,4 m.',
      niveau: Niveau.niveau3,
    ),

    // ---------- AIRES supplémentaires ----------
    Probleme(
      id: 'air-8',
      theme: 'Aire',
      statement:
          'Un bassin circulaire a un rayon de 10 m. Quelle surface (en m²) faut-il bâcher (π ≈ 3,14) ?',
      answer: 314,
      tolerance: 1,
      unit: 'm²',
      explanation: 'Aire = π × 100 = 314 m².',
      niveau: Niveau.niveau4,
      emoji: '🏊',
      schema: IllustratedSchema(
        kind: IllustratedKind.pool,
        labels: <String, String>{'radius': '10'},
      ),
    ),
    Probleme(
      id: 'air-9',
      theme: 'Aire',
      statement:
          'Un jardin en trapèze a deux bases parallèles de 10 m et 6 m, distantes de 4 m. Quelle est sa superficie ?',
      answer: 32,
      tolerance: 0.01,
      unit: 'm²',
      explanation: 'Aire = (B + b) × h / 2 = (10 + 6) × 4 / 2 = 32 m².',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'air-10',
      theme: 'Aire',
      statement:
          'Un terrain rectangulaire a une clôture totale de 30 m et une largeur de 5 m. Quelle est sa longueur ?',
      answer: 10,
      tolerance: 0.01,
      unit: 'm',
      explanation: '2(L + 5) = 30, donc L + 5 = 15 et L = 10 m.',
      niveau: Niveau.niveau4,
      schema: RectangleSchema(width: '?', height: '5'),
    ),

    // ---------- VOLUMES supplémentaires ----------
    Probleme(
      id: 'vol-6',
      theme: 'Volume',
      statement:
          'Un coffre de chantier mesure 10 dm × 6 dm × 4 dm. Quelle est sa capacité (en litres) ?',
      answer: 240,
      tolerance: 0.01,
      unit: 'L',
      explanation: 'V = 10 × 6 × 4 = 240 dm³ = 240 L.',
      niveau: Niveau.niveau3,
      emoji: '📦',
      schema: IllustratedSchema(
        kind: IllustratedKind.crate,
        labels: <String, String>{'length': '10', 'width': '6', 'height': '4'},
      ),
    ),
    Probleme(
      id: 'vol-7',
      theme: 'Volume',
      statement:
          'Un fût cylindrique de fioul a un rayon de 5 dm et une hauteur de 8 dm. Combien peut-il stocker (en litres, π ≈ 3,14) ?',
      answer: 628,
      tolerance: 1,
      unit: 'L',
      explanation: 'V = 3,14 × 25 × 8 = 628 dm³ = 628 L.',
      niveau: Niveau.niveau3,
      schema: CylinderSchema(radius: '5', height: '8'),
    ),

    // ---------- POURCENTAGES supplémentaires ----------
    Probleme(
      id: 'pct-6',
      theme: 'Pourcentage',
      statement:
          'Un manteau coûtait 80 €. Il est soldé à −30 %. Quel est son prix soldé ?',
      answer: 56,
      tolerance: 0.01,
      unit: '€',
      explanation: '80 × 0,7 = 56 €.',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'pct-7',
      theme: 'Pourcentage',
      statement:
          'Un produit augmente de 25 %. Si le nouveau prix est 50 €, quel était le prix initial ?',
      answer: 40,
      tolerance: 0.01,
      unit: '€',
      explanation: 'Prix initial × 1,25 = 50, donc prix = 50 / 1,25 = 40 €.',
      niveau: Niveau.niveau4,
    ),

    // ---------- ÉQUATIONS supplémentaires ----------
    Probleme(
      id: 'eq-6',
      theme: 'Équation',
      statement:
          'Un employé A facture 7 €/heure mais doit 4 € de matériel ; un employé B facture 3 €/heure et a 12 € de fournitures. À combien d\'heures les deux factures sont-elles équivalentes ?',
      answer: 4,
      tolerance: 0.01,
      unit: 'h',
      explanation: '7x − 4 = 3x + 12, donc 4x = 16 et x = 4 heures.',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'eq-7',
      theme: 'Équation',
      statement:
          'Un fournisseur livre des packs de 2 produits + 1 emballage, pour un total de 21 € sur 3 packs identiques. Quel est le prix unitaire d\'un produit ?',
      answer: 3,
      tolerance: 0.01,
      unit: '€',
      explanation: '3(2x + 1) = 21, donc 2x + 1 = 7, 2x = 6, x = 3 €.',
      niveau: Niveau.niveau4,
    ),

    // ---------- FONCTIONS supplémentaires ----------
    Probleme(
      id: 'fct-5',
      theme: 'Fonction',
      statement:
          'Au début, le compteur de visites d\'un site indique 3. Au bout de 2 jours il est à 7. Quel est le nombre moyen de visites par jour (coefficient directeur de la droite) ?',
      answer: 2,
      tolerance: 0.01,
      unit: '/jour',
      explanation: 'a = (7 − 3) / (2 − 0) = 2 visites/jour.',
      niveau: Niveau.niveau3,
    ),
    Probleme(
      id: 'fct-6',
      theme: 'Fonction',
      statement:
          'Le bénéfice d\'une entreprise est modélisé par f(x) = x² − 4 (en milliers d\'€, x en années). Quel sera le bénéfice à 5 ans ?',
      answer: 21,
      tolerance: 0.01,
      unit: 'k€',
      explanation: 'f(5) = 25 − 4 = 21 milliers d\'€.',
      niveau: Niveau.niveau3,
    ),
  ];
}
