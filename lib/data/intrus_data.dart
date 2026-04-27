/// Un set de l'intrus : 4 items dont un qui ne va pas, + thème explicatif.
class IntrusSet {
  const IntrusSet({
    required this.items,
    required this.intruderIndex,
    required this.theme,
    this.explanation,
    this.subjectId,
  });

  final List<String> items;
  final int intruderIndex;
  final String theme;
  final String? explanation;
  final String? subjectId;
}

class IntrusData {
  const IntrusData._();

  static const List<IntrusSet> all = <IntrusSet>[
    IntrusSet(
      items: <String>['Hugo', 'Zola', 'Voltaire', 'Beethoven'],
      intruderIndex: 3,
      theme: 'Auteurs français',
      explanation: 'Beethoven est un compositeur, pas un écrivain.',
      subjectId: 'francais',
    ),
    IntrusSet(
      items: <String>['1789', '1914', '1492', '1945'],
      intruderIndex: 2,
      theme: 'Dates du brevet',
      explanation: '1492 (Christophe Colomb) n\'est pas au programme du brevet.',
      subjectId: 'histoire-geo',
    ),
    IntrusSet(
      items: <String>['Pomme', 'Banane', 'Pain', 'Fraise'],
      intruderIndex: 2,
      theme: 'Fruits',
      explanation: 'Le pain n\'est pas un fruit.',
    ),
    IntrusSet(
      items: <String>['present', 'future', 'dog', 'past'],
      intruderIndex: 2,
      theme: 'Temps en anglais',
      explanation: 'Dog (chien) n\'est pas un temps grammatical.',
      subjectId: 'anglais',
    ),
    IntrusSet(
      items: <String>['carré', 'triangle', 'cercle', 'addition'],
      intruderIndex: 3,
      theme: 'Figures géométriques',
      explanation: 'L\'addition est une opération, pas une figure.',
      subjectId: 'maths',
    ),
    IntrusSet(
      items: <String>['cellule', 'noyau', 'mitochondrie', 'pancréas'],
      intruderIndex: 3,
      theme: 'Composants cellulaires',
      explanation: 'Le pancréas est un organe, pas un composant cellulaire.',
      subjectId: 'sciences',
    ),
    IntrusSet(
      items: <String>['Paris', 'Londres', 'Berlin', 'Sydney'],
      intruderIndex: 3,
      theme: 'Capitales européennes',
      explanation: 'Sydney est en Australie.',
      subjectId: 'histoire-geo',
    ),
    IntrusSet(
      items: <String>['nom', 'verbe', 'adjectif', 'paragraphe'],
      intruderIndex: 3,
      theme: 'Classes de mots',
      explanation: 'Un paragraphe est une unité de texte.',
      subjectId: 'francais',
    ),
    IntrusSet(
      items: <String>['Pythagore', 'Thalès', 'Newton', 'Hugo'],
      intruderIndex: 3,
      theme: 'Mathématiciens',
      explanation: 'Hugo est un écrivain.',
      subjectId: 'maths',
    ),
    IntrusSet(
      items: <String>['Volt', 'Ampère', 'Watt', 'Pascal'],
      intruderIndex: 3,
      theme: 'Unités électriques',
      explanation:
          'Pascal est l\'unité de pression, pas une unité électrique.',
      subjectId: 'sciences',
    ),
    IntrusSet(
      items: <String>['eat', 'sleep', 'run', 'red'],
      intruderIndex: 3,
      theme: 'Verbes anglais',
      explanation: 'Red (rouge) est un adjectif, pas un verbe.',
      subjectId: 'anglais',
    ),
    IntrusSet(
      items: <String>['1944', 'Débarquement', 'Normandie', 'Russie'],
      intruderIndex: 3,
      theme: 'Débarquement',
      explanation: 'Le débarquement a eu lieu en Normandie, pas en Russie.',
      subjectId: 'histoire-geo',
    ),
    IntrusSet(
      items: <String>['fraction', 'décimal', 'entier', 'voyelle'],
      intruderIndex: 3,
      theme: 'Types de nombres',
      explanation: 'Une voyelle est une lettre, pas un nombre.',
      subjectId: 'maths',
    ),
    IntrusSet(
      items: <String>['Voltaire', 'Hugo', 'Zola', 'Mozart'],
      intruderIndex: 3,
      theme: 'Écrivains',
      explanation: 'Mozart est un compositeur.',
      subjectId: 'francais',
    ),
    IntrusSet(
      items: <String>['oxygène', 'azote', 'fer', 'CO₂'],
      intruderIndex: 2,
      theme: 'Gaz de l\'atmosphère',
      explanation: 'Le fer n\'est pas un gaz atmosphérique courant.',
      subjectId: 'sciences',
    ),
  ];
}
