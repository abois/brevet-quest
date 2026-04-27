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
}

class ProblemesData {
  const ProblemesData._();

  static const List<Probleme> all = <Probleme>[
    // ---------- PYTHAGORE (4e) ----------
    Probleme(
      id: 'pyt-1',
      theme: 'Pythagore',
      statement:
          'ABC est un triangle rectangle en A. AB = 3 cm et AC = 4 cm. Calcule BC.',
      answer: 5,
      tolerance: 0.01,
      unit: 'cm',
      explanation: 'BC² = AB² + AC² = 9 + 16 = 25, donc BC = 5 cm.',
      niveau: Niveau.niveau4,
      schema: RightTriangleSchema(legA: '3', legB: '4', hypo: '?'),
    ),
    Probleme(
      id: 'pyt-2',
      theme: 'Pythagore',
      statement:
          'ABC est rectangle en A. AB = 5 cm et AC = 12 cm. Quelle est la longueur BC ?',
      answer: 13,
      tolerance: 0.01,
      unit: 'cm',
      explanation: 'BC² = 25 + 144 = 169, donc BC = 13 cm.',
      niveau: Niveau.niveau4,
      schema: RightTriangleSchema(legA: '5', legB: '12', hypo: '?'),
    ),
    Probleme(
      id: 'pyt-3',
      theme: 'Pythagore',
      statement:
          'Un triangle est rectangle. Ses deux côtés de l\'angle droit mesurent 8 cm et 15 cm. Calcule l\'hypoténuse.',
      answer: 17,
      tolerance: 0.01,
      unit: 'cm',
      explanation: '64 + 225 = 289 = 17². L\'hypoténuse mesure 17 cm.',
      niveau: Niveau.niveau4,
      schema: RightTriangleSchema(legA: '8', legB: '15', hypo: '?'),
    ),
    Probleme(
      id: 'pyt-4',
      theme: 'Pythagore',
      statement:
          'ABC est rectangle en A. BC = 13 cm et AB = 5 cm. Calcule AC.',
      answer: 12,
      tolerance: 0.01,
      unit: 'cm',
      explanation: 'AC² = BC² − AB² = 169 − 25 = 144, donc AC = 12 cm.',
      niveau: Niveau.niveau4,
      schema: RightTriangleSchema(legA: '5', legB: '?', hypo: '13'),
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
      schema: RightTriangleSchema(legA: '3', legB: '?', hypo: '5'),
    ),
    Probleme(
      id: 'pyt-6',
      theme: 'Pythagore',
      statement:
          'Un rectangle a pour dimensions 6 cm sur 8 cm. Calcule la longueur de sa diagonale.',
      answer: 10,
      tolerance: 0.01,
      unit: 'cm',
      explanation: 'd² = 6² + 8² = 36 + 64 = 100, donc d = 10 cm.',
      niveau: Niveau.niveau4,
      schema: RectangleSchema(width: '8', height: '6'),
    ),
    Probleme(
      id: 'pyt-7',
      theme: 'Pythagore',
      statement:
          'ABC est rectangle en A avec AB = 7 cm et AC = 24 cm. Calcule BC.',
      answer: 25,
      tolerance: 0.01,
      unit: 'cm',
      explanation: '7² + 24² = 49 + 576 = 625 = 25².',
      niveau: Niveau.niveau4,
      schema: RightTriangleSchema(legA: '7', legB: '24', hypo: '?'),
    ),
    Probleme(
      id: 'pyt-8',
      theme: 'Pythagore',
      statement:
          'ABC est rectangle en A avec AB = 2 cm et AC = 3 cm. Calcule BC, arrondi au dixième.',
      answer: 3.6,
      tolerance: 0.05,
      unit: 'cm',
      explanation: 'BC² = 4 + 9 = 13, BC = √13 ≈ 3,6 cm.',
      niveau: Niveau.niveau4,
      schema: RightTriangleSchema(legA: '2', legB: '3', hypo: '?'),
    ),

    // ---------- THALÈS (4e/3e) ----------
    Probleme(
      id: 'tha-1',
      theme: 'Thalès',
      statement:
          'Dans le triangle ABC, D est sur [AB] et E sur [AC] avec (DE) // (BC). AD = 4, AB = 10, BC = 15. Calcule DE.',
      answer: 6,
      tolerance: 0.01,
      unit: 'cm',
      explanation: 'DE/BC = AD/AB, donc DE = 15 × 4/10 = 6 cm.',
      niveau: Niveau.niveau4,
      schema: ThalesSchema(ad: '4', ab: '10', bc: '15', de: '?'),
    ),
    Probleme(
      id: 'tha-2',
      theme: 'Thalès',
      statement:
          'Triangle ABC, (DE) // (BC) avec D sur [AB] et E sur [AC]. AD = 3, AB = 9, AC = 12. Calcule AE.',
      answer: 4,
      tolerance: 0.01,
      unit: 'cm',
      explanation: 'AE/AC = AD/AB, donc AE = 12 × 3/9 = 4 cm.',
      niveau: Niveau.niveau4,
      schema: ThalesSchema(ad: '3', ab: '9', ac: '12', ae: '?'),
    ),
    Probleme(
      id: 'tha-3',
      theme: 'Thalès',
      statement:
          'Triangle ABC, D sur [AB], E sur [AC], (DE) // (BC). AD = 5, AB = 8, DE = 10. Calcule BC.',
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
          'Configuration "papillon" : (AB) et (CD) se coupent en O. (AB) // (CD). OA = 3, OB = 6, OC = 4. Calcule OD.',
      answer: 8,
      tolerance: 0.01,
      unit: 'cm',
      explanation: 'OA/OB = OC/OD, donc OD = 6 × 4/3 = 8 cm.',
      niveau: Niveau.niveau3,
      schema: ThalesSchema(ad: '3', ab: '6', ae: '4', ac: '?', butterfly: true),
    ),
    Probleme(
      id: 'tha-6',
      theme: 'Thalès',
      statement:
          'Triangle ABC, (DE) // (BC). AD = 6, DB = 4, AE = 9. Calcule EC.',
      answer: 6,
      tolerance: 0.01,
      unit: 'cm',
      explanation: 'AD/AB = AE/AC. AB = 10, AC = AE × AB/AD = 9 × 10/6 = 15, donc EC = 15 − 9 = 6 cm.',
      niveau: Niveau.niveau4,
      schema: ThalesSchema(ad: '6', ab: '10', ae: '9', ac: '?'),
    ),

    // ---------- TRIGONOMÉTRIE (3e) ----------
    Probleme(
      id: 'trig-1',
      theme: 'Trigonométrie',
      statement:
          'ABC rectangle en A. L\'angle ABC mesure 60°. AB = 5 cm. Calcule BC, arrondi au dixième.',
      answer: 10,
      tolerance: 0.05,
      unit: 'cm',
      explanation: 'cos(60°) = AB/BC, donc BC = 5 / 0,5 = 10 cm.',
      niveau: Niveau.niveau3,
      schema: RightTriangleTrigSchema(
        angleLabel: '60°',
        adjacent: '5',
        hypotenuse: '?',
      ),
    ),
    Probleme(
      id: 'trig-2',
      theme: 'Trigonométrie',
      statement:
          'Triangle rectangle, hypoténuse 12 cm, angle 30°. Calcule le côté opposé à cet angle.',
      answer: 6,
      tolerance: 0.05,
      unit: 'cm',
      explanation: 'sin(30°) = opp/12 = 0,5, donc opp = 6 cm.',
      niveau: Niveau.niveau3,
      schema: RightTriangleTrigSchema(
        angleLabel: '30°',
        opposite: '?',
        hypotenuse: '12',
      ),
    ),
    Probleme(
      id: 'trig-3',
      theme: 'Trigonométrie',
      statement:
          'Triangle rectangle. Le côté adjacent à un angle de 45° mesure 7 cm. Calcule le côté opposé.',
      answer: 7,
      tolerance: 0.05,
      unit: 'cm',
      explanation: 'tan(45°) = 1, donc opp = adj = 7 cm.',
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
          'Triangle rectangle, côté adjacent 3 cm, côté opposé 4 cm. Calcule la mesure de l\'angle au degré près.',
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
          'ABC rectangle en A. AB = 8 cm, BC = 10 cm. Calcule la mesure de l\'angle ABC, au degré près.',
      answer: 37,
      tolerance: 0.6,
      unit: '°',
      explanation: 'cos(ABC) = AB/BC = 8/10 = 0,8, donc ABC ≈ arccos(0,8) ≈ 37°.',
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
          'Un rectangle mesure 8 cm de long et 5 cm de large. Calcule son aire.',
      answer: 40,
      tolerance: 0.01,
      unit: 'cm²',
      explanation: 'Aire = 8 × 5 = 40 cm².',
      niveau: Niveau.niveau4,
      schema: RectangleSchema(width: '8', height: '5'),
    ),
    Probleme(
      id: 'air-2',
      theme: 'Aire',
      statement:
          'Un triangle a une base de 10 cm et une hauteur de 6 cm. Calcule son aire.',
      answer: 30,
      tolerance: 0.01,
      unit: 'cm²',
      explanation: 'Aire = (base × hauteur) / 2 = 60 / 2 = 30 cm².',
      niveau: Niveau.niveau4,
      schema: TriangleSchema(base: '10', height: '6'),
    ),
    Probleme(
      id: 'air-3',
      theme: 'Aire',
      statement:
          'Un disque a un rayon de 5 cm. Calcule son aire (prendre π ≈ 3,14).',
      answer: 78.5,
      tolerance: 0.5,
      unit: 'cm²',
      explanation: 'Aire = π × r² = 3,14 × 25 = 78,5 cm².',
      niveau: Niveau.niveau4,
      schema: CircleSchema(radius: '5'),
    ),
    Probleme(
      id: 'air-4',
      theme: 'Aire',
      statement:
          'Calcule l\'aire d\'un carré de côté 7 cm.',
      answer: 49,
      tolerance: 0.01,
      unit: 'cm²',
      explanation: 'Aire = 7 × 7 = 49 cm².',
      niveau: Niveau.niveau4,
      schema: RectangleSchema(width: '7', height: '7'),
    ),
    Probleme(
      id: 'air-5',
      theme: 'Aire',
      statement:
          'Un parallélogramme a une base de 9 cm et une hauteur correspondante de 4 cm. Calcule son aire.',
      answer: 36,
      tolerance: 0.01,
      unit: 'cm²',
      explanation: 'Aire = base × hauteur = 9 × 4 = 36 cm².',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'air-6',
      theme: 'Aire',
      statement:
          'Un disque a un diamètre de 8 cm. Calcule son aire (π ≈ 3,14).',
      answer: 50.24,
      tolerance: 0.5,
      unit: 'cm²',
      explanation: 'r = 4 cm, Aire = 3,14 × 16 = 50,24 cm².',
      niveau: Niveau.niveau4,
      schema: CircleSchema(radius: '4'),
    ),
    Probleme(
      id: 'air-7',
      theme: 'Aire',
      statement:
          'Un triangle rectangle a pour côtés de l\'angle droit 6 cm et 9 cm. Calcule son aire.',
      answer: 27,
      tolerance: 0.01,
      unit: 'cm²',
      explanation: 'Aire = (6 × 9) / 2 = 27 cm².',
      niveau: Niveau.niveau4,
      schema: RightTriangleSchema(legA: '6', legB: '9'),
    ),

    // ---------- VOLUMES (3e) ----------
    Probleme(
      id: 'vol-1',
      theme: 'Volume',
      statement:
          'Un cube a une arête de 4 cm. Calcule son volume.',
      answer: 64,
      tolerance: 0.01,
      unit: 'cm³',
      explanation: 'V = 4³ = 64 cm³.',
      niveau: Niveau.niveau3,
      schema: CuboidSchema(length: '4', width: '4', height: '4'),
    ),
    Probleme(
      id: 'vol-2',
      theme: 'Volume',
      statement:
          'Un pavé droit a pour dimensions 5 cm, 3 cm et 4 cm. Calcule son volume.',
      answer: 60,
      tolerance: 0.01,
      unit: 'cm³',
      explanation: 'V = 5 × 3 × 4 = 60 cm³.',
      niveau: Niveau.niveau3,
      schema: CuboidSchema(length: '5', width: '3', height: '4'),
    ),
    Probleme(
      id: 'vol-3',
      theme: 'Volume',
      statement:
          'Un cylindre a un rayon de 3 cm et une hauteur de 10 cm. Calcule son volume (π ≈ 3,14).',
      answer: 282.6,
      tolerance: 1,
      unit: 'cm³',
      explanation: 'V = π × r² × h = 3,14 × 9 × 10 = 282,6 cm³.',
      niveau: Niveau.niveau3,
      schema: CylinderSchema(radius: '3', height: '10'),
    ),
    Probleme(
      id: 'vol-4',
      theme: 'Volume',
      statement:
          'Un cône a un rayon de base de 3 cm et une hauteur de 4 cm. Calcule son volume (π ≈ 3,14).',
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
      statement: 'Résous l\'équation : 3x + 7 = 22',
      answer: 5,
      tolerance: 0.01,
      unit: '',
      explanation: '3x = 15, donc x = 5.',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'eq-2',
      theme: 'Équation',
      statement: 'Résous l\'équation : 2x − 5 = 11',
      answer: 8,
      tolerance: 0.01,
      unit: '',
      explanation: '2x = 16, donc x = 8.',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'eq-3',
      theme: 'Équation',
      statement: 'Résous : 4x + 3 = 2x + 11',
      answer: 4,
      tolerance: 0.01,
      unit: '',
      explanation: '2x = 8, donc x = 4.',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'eq-4',
      theme: 'Équation',
      statement: 'Résous : 5(x − 2) = 20',
      answer: 6,
      tolerance: 0.01,
      unit: '',
      explanation: 'x − 2 = 4, donc x = 6.',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'eq-5',
      theme: 'Équation',
      statement: 'Résous : x/3 + 2 = 5',
      answer: 9,
      tolerance: 0.01,
      unit: '',
      explanation: 'x/3 = 3, donc x = 9.',
      niveau: Niveau.niveau4,
    ),

    // ---------- FONCTIONS (3e) ----------
    Probleme(
      id: 'fct-1',
      theme: 'Fonction',
      statement: 'Soit f(x) = 2x + 3. Calcule f(5).',
      answer: 13,
      tolerance: 0.01,
      unit: '',
      explanation: 'f(5) = 2 × 5 + 3 = 13.',
      niveau: Niveau.niveau3,
    ),
    Probleme(
      id: 'fct-2',
      theme: 'Fonction',
      statement:
          'Soit f(x) = 2x + 3. Pour quelle valeur de x a-t-on f(x) = 11 ?',
      answer: 4,
      tolerance: 0.01,
      unit: '',
      explanation: '2x + 3 = 11, donc 2x = 8 et x = 4.',
      niveau: Niveau.niveau3,
    ),
    Probleme(
      id: 'fct-3',
      theme: 'Fonction',
      statement: 'g(x) = −x + 7. Calcule g(2).',
      answer: 5,
      tolerance: 0.01,
      unit: '',
      explanation: 'g(2) = −2 + 7 = 5.',
      niveau: Niveau.niveau3,
    ),
    Probleme(
      id: 'fct-4',
      theme: 'Fonction',
      statement:
          'h(x) = 3x − 5 est une fonction affine. Pour quelle valeur de x a-t-on h(x) = 10 ?',
      answer: 5,
      tolerance: 0.01,
      unit: '',
      explanation: '3x − 5 = 10, donc x = 5.',
      niveau: Niveau.niveau3,
    ),

    // ---------- ARITHMÉTIQUE (3e) ----------
    Probleme(
      id: 'arit-1',
      theme: 'PGCD',
      statement: 'Calcule le PGCD de 36 et 48.',
      answer: 12,
      tolerance: 0.01,
      unit: '',
      explanation: '36 = 2² × 3², 48 = 2⁴ × 3, PGCD = 2² × 3 = 12.',
      niveau: Niveau.niveau3,
    ),
    Probleme(
      id: 'arit-2',
      theme: 'PGCD',
      statement: 'Calcule le PGCD de 45 et 75.',
      answer: 15,
      tolerance: 0.01,
      unit: '',
      explanation: '45 = 3² × 5, 75 = 3 × 5², PGCD = 3 × 5 = 15.',
      niveau: Niveau.niveau3,
    ),
    Probleme(
      id: 'arit-3',
      theme: 'PGCD',
      statement: 'Calcule le PGCD de 56 et 98.',
      answer: 14,
      tolerance: 0.01,
      unit: '',
      explanation: 'Algorithme d\'Euclide : 98 = 56 × 1 + 42, 56 = 42 × 1 + 14, 42 = 14 × 3, donc PGCD = 14.',
      niveau: Niveau.niveau3,
    ),
    Probleme(
      id: 'arit-4',
      theme: 'Identité remarquable',
      statement: 'Calcule 102² en utilisant (100 + 2)².',
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
          'Un rectangle a pour dimensions 12 cm sur 16 cm. Calcule la longueur de sa diagonale.',
      answer: 20,
      tolerance: 0.01,
      unit: 'cm',
      explanation: 'd² = 144 + 256 = 400, donc d = 20 cm.',
      niveau: Niveau.niveau4,
      schema: RectangleSchema(width: '16', height: '12'),
    ),
    Probleme(
      id: 'pyt-10',
      theme: 'Pythagore',
      statement:
          'ABC est rectangle en A. AB = 9 cm et AC = 12 cm. Calcule BC.',
      answer: 15,
      tolerance: 0.01,
      unit: 'cm',
      explanation: 'BC² = 81 + 144 = 225, donc BC = 15 cm.',
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
          'ABC est rectangle en A. BC = 25 cm et AC = 24 cm. Calcule AB.',
      answer: 7,
      tolerance: 0.01,
      unit: 'cm',
      explanation: 'AB² = 625 − 576 = 49, donc AB = 7 cm.',
      niveau: Niveau.niveau4,
      schema: RightTriangleSchema(legA: '?', legB: '24', hypo: '25'),
    ),
    Probleme(
      id: 'pyt-13',
      theme: 'Pythagore',
      statement:
          'Un carré a un côté de 5 cm. Calcule la longueur de sa diagonale, arrondi au dixième.',
      answer: 7.1,
      tolerance: 0.05,
      unit: 'cm',
      explanation: 'd² = 5² + 5² = 50, d = 5√2 ≈ 7,1 cm.',
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
          'Triangle ABC, (DE) // (BC). AD = 6, AB = 9, BC = 12. Calcule DE.',
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
          'Configuration papillon : (AB) et (CD) se coupent en O avec (AC) // (BD). OA = 4, OC = 6, OB = 10. Calcule OD.',
      answer: 15,
      tolerance: 0.01,
      unit: 'cm',
      explanation: 'OA/OB = OC/OD, donc OD = OC × OB/OA = 6 × 10/4 = 15 cm.',
      niveau: Niveau.niveau3,
      schema: ThalesSchema(ad: '4', ab: '10', ae: '6', ac: '?', butterfly: true),
    ),

    // ---------- TRIGO supplémentaires ----------
    Probleme(
      id: 'trig-7',
      theme: 'Trigonométrie',
      statement:
          'Triangle rectangle, hypoténuse 20 cm, angle 60°. Calcule le côté adjacent à cet angle.',
      answer: 10,
      tolerance: 0.05,
      unit: 'cm',
      explanation: 'cos(60°) = adj/20 = 0,5, donc adj = 10 cm.',
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
          'Triangle rectangle. Côté opposé à l\'angle = 5 cm, hypoténuse = 13 cm. Calcule la mesure de l\'angle au degré près.',
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
          'Un disque a un rayon de 10 cm. Calcule son aire (π ≈ 3,14).',
      answer: 314,
      tolerance: 1,
      unit: 'cm²',
      explanation: 'Aire = π × 100 = 314 cm².',
      niveau: Niveau.niveau4,
      schema: CircleSchema(radius: '10'),
    ),
    Probleme(
      id: 'air-9',
      theme: 'Aire',
      statement:
          'Un trapèze a pour grande base 10 cm, petite base 6 cm, hauteur 4 cm. Calcule son aire.',
      answer: 32,
      tolerance: 0.01,
      unit: 'cm²',
      explanation: 'Aire = (B + b) × h / 2 = (10 + 6) × 4 / 2 = 32 cm².',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'air-10',
      theme: 'Aire',
      statement:
          'Le périmètre d\'un rectangle est 30 cm et sa largeur 5 cm. Calcule sa longueur.',
      answer: 10,
      tolerance: 0.01,
      unit: 'cm',
      explanation: '2(L + 5) = 30, donc L + 5 = 15 et L = 10 cm.',
      niveau: Niveau.niveau4,
      schema: RectangleSchema(width: '?', height: '5'),
    ),

    // ---------- VOLUMES supplémentaires ----------
    Probleme(
      id: 'vol-6',
      theme: 'Volume',
      statement:
          'Un pavé droit a pour dimensions 10 cm × 6 cm × 4 cm. Calcule son volume.',
      answer: 240,
      tolerance: 0.01,
      unit: 'cm³',
      explanation: 'V = 10 × 6 × 4 = 240 cm³.',
      niveau: Niveau.niveau3,
      schema: CuboidSchema(length: '10', width: '6', height: '4'),
    ),
    Probleme(
      id: 'vol-7',
      theme: 'Volume',
      statement:
          'Un cylindre a un rayon de 5 cm et une hauteur de 8 cm. Calcule son volume (π ≈ 3,14).',
      answer: 628,
      tolerance: 1,
      unit: 'cm³',
      explanation: 'V = 3,14 × 25 × 8 = 628 cm³.',
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
      statement: 'Résous : 7x − 4 = 3x + 12',
      answer: 4,
      tolerance: 0.01,
      unit: '',
      explanation: '4x = 16, donc x = 4.',
      niveau: Niveau.niveau4,
    ),
    Probleme(
      id: 'eq-7',
      theme: 'Équation',
      statement: 'Résous : 3(2x + 1) = 21',
      answer: 3,
      tolerance: 0.01,
      unit: '',
      explanation: '6x + 3 = 21, 6x = 18, x = 3.',
      niveau: Niveau.niveau4,
    ),

    // ---------- FONCTIONS supplémentaires ----------
    Probleme(
      id: 'fct-5',
      theme: 'Fonction',
      statement:
          'Soit f la fonction affine telle que f(0) = 3 et f(2) = 7. Quel est son coefficient directeur ?',
      answer: 2,
      tolerance: 0.01,
      unit: '',
      explanation: 'a = (f(2) − f(0)) / (2 − 0) = (7 − 3) / 2 = 2.',
      niveau: Niveau.niveau3,
    ),
    Probleme(
      id: 'fct-6',
      theme: 'Fonction',
      statement: 'f(x) = x² − 4. Calcule f(5).',
      answer: 21,
      tolerance: 0.01,
      unit: '',
      explanation: 'f(5) = 25 − 4 = 21.',
      niveau: Niveau.niveau3,
    ),
  ];
}
