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

  /// Identifiant stable dérivé du contenu — utilisé pour le tracking
  /// "déjà vu" via ProgressService.pickUnseen.
  String get id => '$theme|${items.join("/")}';
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
    IntrusSet(
      items: <String>['Mercure', 'Vénus', 'Lune', 'Mars'],
      intruderIndex: 2,
      theme: 'Planètes',
      explanation: 'La Lune est un satellite, pas une planète.',
      subjectId: 'sciences',
    ),
    IntrusSet(
      items: <String>['Joconde', 'Tableau', 'Sculpture', 'Léonard de Vinci'],
      intruderIndex: 2,
      theme: 'Œuvres picturales',
      explanation: 'Une sculpture n\'est pas un tableau.',
    ),
    IntrusSet(
      items: <String>['Espagnol', 'Italien', 'Portugais', 'Allemand'],
      intruderIndex: 3,
      theme: 'Langues romanes',
      explanation:
          'L\'allemand est une langue germanique, pas romane.',
      subjectId: 'anglais',
    ),
    IntrusSet(
      items: <String>['cerveau', 'cœur', 'foie', 'os'],
      intruderIndex: 3,
      theme: 'Organes',
      explanation: 'Un os n\'est pas un organe mou.',
      subjectId: 'sciences',
    ),
    IntrusSet(
      items: <String>['printemps', 'été', 'mois', 'hiver'],
      intruderIndex: 2,
      theme: 'Saisons',
      explanation: 'Un mois est une unité de temps, pas une saison.',
    ),
    IntrusSet(
      items: <String>['Loire', 'Seine', 'Garonne', 'Rhin'],
      intruderIndex: 3,
      theme: 'Fleuves français',
      explanation:
          'Le Rhin est un fleuve frontalier ; les fleuves français sont surtout Loire/Seine/Garonne/Rhône.',
      subjectId: 'histoire-geo',
    ),
    IntrusSet(
      items: <String>['Molière', 'Racine', 'Corneille', 'Hugo'],
      intruderIndex: 3,
      theme: 'Auteurs classiques (XVIIᵉ)',
      explanation: 'Hugo est un auteur du XIXᵉ siècle.',
      subjectId: 'francais',
    ),
    IntrusSet(
      items: <String>['nom', 'pronom', 'préposition', 'phrase'],
      intruderIndex: 3,
      theme: 'Natures de mots',
      explanation: 'Une phrase n\'est pas une nature de mot.',
      subjectId: 'francais',
    ),
    IntrusSet(
      items: <String>['carré', 'rectangle', 'losange', 'pyramide'],
      intruderIndex: 3,
      theme: 'Quadrilatères',
      explanation: 'Une pyramide est un solide en 3D.',
      subjectId: 'maths',
    ),
    IntrusSet(
      items: <String>['+', '−', '×', 'π'],
      intruderIndex: 3,
      theme: 'Opérations',
      explanation: 'π est une constante, pas une opération.',
      subjectId: 'maths',
    ),
    IntrusSet(
      items: <String>['1789', '1799', '1804', '1962'],
      intruderIndex: 3,
      theme: 'Révolution et Empire',
      explanation:
          '1962 = indépendance de l\'Algérie (XXᵉ s.), pas l\'époque révolutionnaire.',
      subjectId: 'histoire-geo',
    ),
    IntrusSet(
      items: <String>['Asie', 'Europe', 'France', 'Afrique'],
      intruderIndex: 2,
      theme: 'Continents',
      explanation: 'La France est un pays, pas un continent.',
      subjectId: 'histoire-geo',
    ),
    IntrusSet(
      items: <String>['poésie', 'roman', 'théâtre', 'roi'],
      intruderIndex: 3,
      theme: 'Genres littéraires',
      explanation: 'Un roi est une personne, pas un genre littéraire.',
      subjectId: 'francais',
    ),
    IntrusSet(
      items: <String>['hydrogène', 'oxygène', 'carbone', 'sel'],
      intruderIndex: 3,
      theme: 'Éléments chimiques',
      explanation: 'Le sel est un composé (NaCl), pas un élément.',
      subjectId: 'sciences',
    ),
    IntrusSet(
      items: <String>['Mitterrand', 'De Gaulle', 'Chirac', 'Napoléon'],
      intruderIndex: 3,
      theme: 'Présidents de la Vᵉ République',
      explanation: 'Napoléon est un empereur, pas un président de la Vᵉ.',
      subjectId: 'histoire-geo',
    ),
    IntrusSet(
      items: <String>['monday', 'tuesday', 'january', 'friday'],
      intruderIndex: 2,
      theme: 'Jours en anglais',
      explanation: 'January est un mois, pas un jour.',
      subjectId: 'anglais',
    ),
    IntrusSet(
      items: <String>['cosinus', 'sinus', 'tangente', 'logarithme'],
      intruderIndex: 3,
      theme: 'Trigonométrie',
      explanation: 'Le logarithme n\'est pas une fonction trigonométrique.',
      subjectId: 'maths',
    ),
    IntrusSet(
      items: <String>['Joule', 'Newton', 'Pascal', 'Kelvin'],
      intruderIndex: 3,
      theme: 'Unités physiques',
      explanation: 'Kelvin est une unité de température.',
      subjectId: 'sciences',
    ),
    IntrusSet(
      items: <String>['Algérie', 'Sénégal', 'Maroc', 'Espagne'],
      intruderIndex: 3,
      theme: 'Pays francophones',
      explanation:
          'L\'Espagne n\'est pas un pays officiellement francophone.',
      subjectId: 'histoire-geo',
    ),
    IntrusSet(
      items: <String>['imparfait', 'futur', 'passé simple', 'verbe'],
      intruderIndex: 3,
      theme: 'Temps de conjugaison',
      explanation: 'Le verbe est une nature de mot, pas un temps.',
      subjectId: 'francais',
    ),
    IntrusSet(
      items: <String>['carré', 'cube', 'racine', 'rectangle'],
      intruderIndex: 3,
      theme: 'Termes mathématiques',
      explanation:
          'La racine est une opération, les autres sont des figures/solides.',
      subjectId: 'maths',
    ),
    IntrusSet(
      items: <String>['Méditerranée', 'Atlantique', 'Pacifique', 'Europe'],
      intruderIndex: 3,
      theme: 'Mers et océans',
      explanation: 'L\'Europe est un continent.',
      subjectId: 'histoire-geo',
    ),
    IntrusSet(
      items: <String>['neutron', 'proton', 'électron', 'photon'],
      intruderIndex: 3,
      theme: 'Particules de l\'atome',
      explanation:
          'Le photon est une particule de lumière, pas un constituant de l\'atome.',
      subjectId: 'sciences',
    ),
    IntrusSet(
      items: <String>['1939', '1945', '1944', '1492'],
      intruderIndex: 3,
      theme: 'Seconde Guerre mondiale',
      explanation: '1492 = découverte de l\'Amérique.',
      subjectId: 'histoire-geo',
    ),
    IntrusSet(
      items: <String>['Romeo', 'Juliette', 'Hamlet', 'Astérix'],
      intruderIndex: 3,
      theme: 'Personnages de Shakespeare',
      explanation: 'Astérix est un personnage de bande dessinée.',
      subjectId: 'francais',
    ),
    IntrusSet(
      items: <String>['CO₂', 'O₂', 'H₂O', 'sel'],
      intruderIndex: 3,
      theme: 'Formules chimiques',
      explanation: 'Le sel n\'est pas une formule chimique mais un nom usuel.',
      subjectId: 'sciences',
    ),
    IntrusSet(
      items: <String>['UE', 'OTAN', 'ONU', 'INSEE'],
      intruderIndex: 3,
      theme: 'Organisations internationales',
      explanation:
          'INSEE est un institut français de statistiques, pas une orga. internationale.',
      subjectId: 'histoire-geo',
    ),
    IntrusSet(
      items: <String>['démocratie', 'monarchie', 'république', 'industrie'],
      intruderIndex: 3,
      theme: 'Régimes politiques',
      explanation: 'L\'industrie est un secteur économique.',
      subjectId: 'histoire-geo',
    ),
    IntrusSet(
      items: <String>['mètre', 'kilogramme', 'seconde', 'litre'],
      intruderIndex: 3,
      theme: 'Unités du SI fondamentales',
      explanation:
          'Le litre n\'est pas une unité de base du SI (le m³ l\'est).',
      subjectId: 'sciences',
    ),
    IntrusSet(
      items: <String>['have', 'be', 'do', 'and'],
      intruderIndex: 3,
      theme: 'Auxiliaires anglais',
      explanation: '"And" est une conjonction, pas un auxiliaire.',
      subjectId: 'anglais',
    ),
  ];
}
