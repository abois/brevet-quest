import '../models/question.dart';

/// Questions supplémentaires non incluses dans `SubjectsData`, rattachées
/// à un `chapterId` existant. Permet d'étoffer le pool sans toucher au seed
/// principal. `SubjectsData.allQuestionsByTypeForNiveau` les inclut en
/// vérifiant que le chapitre parent matche le niveau de l'utilisateur.
class ExtraQuestions {
  const ExtraQuestions._();

  static const List<Question> all = <Question>[
    // ───── Maths · Pythagore & Thalès (4e) ─────
    Question(
      id: 'x-m-pyt-1',
      type: QuestionType.trueFalse,
      prompt:
          'Dans le théorème de Pythagore, c² = a² + b² où c est l\'hypoténuse.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 0,
      explanation: 'Oui : la somme des carrés des côtés de l\'angle droit '
          '= carré de l\'hypoténuse.',
      subjectId: 'maths',
      chapterId: 'maths-pythagore',
    ),
    Question(
      id: 'x-m-pyt-2',
      type: QuestionType.trueFalse,
      prompt: 'Un triangle 5-12-13 est rectangle.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 0,
      explanation: '25 + 144 = 169 = 13².',
      subjectId: 'maths',
      chapterId: 'maths-pythagore',
    ),
    Question(
      id: 'x-m-pyt-3',
      type: QuestionType.trueFalse,
      prompt:
          'Dans Thalès, les segments AD/AB et AE/AC ne sont pas forcément égaux.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 1,
      explanation:
          'Quand (DE)//(BC), AD/AB = AE/AC = DE/BC (égalité des rapports).',
      subjectId: 'maths',
      chapterId: 'maths-pythagore',
    ),

    // ───── Maths · Calcul & Fractions (4e) ─────
    Question(
      id: 'x-m-calc-1',
      type: QuestionType.trueFalse,
      prompt: '(−3) × (−5) = −15',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 1,
      explanation: 'Le produit de deux négatifs est positif : 15.',
      subjectId: 'maths',
      chapterId: 'maths-calcul',
    ),
    Question(
      id: 'x-m-calc-2',
      type: QuestionType.trueFalse,
      prompt: '1/2 + 1/3 = 2/5',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 1,
      explanation: 'Réduction au même dénominateur : 3/6 + 2/6 = 5/6.',
      subjectId: 'maths',
      chapterId: 'maths-calcul',
    ),
    Question(
      id: 'x-m-calc-3',
      type: QuestionType.trueFalse,
      prompt: '2³ × 2² = 2⁵',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 0,
      explanation: 'Produit de puissances de même base : on additionne les exposants.',
      subjectId: 'maths',
      chapterId: 'maths-calcul',
    ),

    // ───── Maths · Géométrie & Aires (4e) ─────
    Question(
      id: 'x-m-geo-1',
      type: QuestionType.trueFalse,
      prompt: 'L\'aire d\'un disque est π × diamètre.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 1,
      explanation: 'L\'aire est π × r². Le périmètre est π × diamètre.',
      subjectId: 'maths',
      chapterId: 'maths-geometrie',
    ),
    Question(
      id: 'x-m-geo-2',
      type: QuestionType.trueFalse,
      prompt: 'L\'aire d\'un trapèze est (B + b) × h / 2.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 0,
      explanation: 'B = grande base, b = petite base, h = hauteur.',
      subjectId: 'maths',
      chapterId: 'maths-geometrie',
    ),

    // ───── Maths · Stats & Probas (3e) ─────
    Question(
      id: 'x-m-stat-1',
      type: QuestionType.trueFalse,
      prompt: 'La probabilité d\'un évènement est toujours entre 0 et 1.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 0,
      explanation: '0 = impossible, 1 = certain.',
      subjectId: 'maths',
      chapterId: 'maths-stats',
    ),
    Question(
      id: 'x-m-stat-2',
      type: QuestionType.trueFalse,
      prompt:
          'La médiane d\'une série est la moyenne de toutes les valeurs.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 1,
      explanation:
          'C\'est la valeur centrale de la série triée. La moyenne est différente.',
      subjectId: 'maths',
      chapterId: 'maths-stats',
    ),

    // ───── Français · Conjugaison ─────
    Question(
      id: 'x-fr-conj-1',
      type: QuestionType.trueFalse,
      prompt: 'Au passé simple, "il fut" est la 3ᵉ personne du verbe être.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 0,
      explanation: 'Être au passé simple : je fus, tu fus, il fut, etc.',
      subjectId: 'francais',
      chapterId: 'fr-conjugaison',
    ),
    Question(
      id: 'x-fr-conj-2',
      type: QuestionType.trueFalse,
      prompt:
          'Le subjonctif présent du verbe avoir à la 1ʳᵉ personne est "que j\'aie".',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 0,
      explanation: 'Que j\'aie / tu aies / il ait.',
      subjectId: 'francais',
      chapterId: 'fr-conjugaison',
    ),

    // ───── Français · Littérature ─────
    Question(
      id: 'x-fr-litt-1',
      type: QuestionType.trueFalse,
      prompt: 'Victor Hugo a écrit "Notre-Dame de Paris".',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 0,
      explanation: 'Roman publié en 1831.',
      subjectId: 'francais',
      chapterId: 'fr-litterature',
    ),
    Question(
      id: 'x-fr-litt-2',
      type: QuestionType.trueFalse,
      prompt: '"Le Petit Prince" est de Camus.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 1,
      explanation: 'Il est de Saint-Exupéry (1943).',
      subjectId: 'francais',
      chapterId: 'fr-litterature',
    ),

    // ───── Français · Grammaire ─────
    Question(
      id: 'x-fr-gram-1',
      type: QuestionType.trueFalse,
      prompt: 'Les pronoms personnels "le, la, les" sont des COD.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 0,
      explanation:
          'Ils remplacent le complément d\'objet direct. "Lui, leur" = COI.',
      subjectId: 'francais',
      chapterId: 'fr-grammaire',
    ),
    Question(
      id: 'x-fr-gram-2',
      type: QuestionType.trueFalse,
      prompt: '"Bien que" introduit une subordonnée de cause.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 1,
      explanation:
          '"Bien que" introduit une subordonnée de concession (et avec subjonctif).',
      subjectId: 'francais',
      chapterId: 'fr-grammaire',
    ),

    // ───── Histoire-géo · XIXe ─────
    Question(
      id: 'x-hg-19-1',
      type: QuestionType.trueFalse,
      prompt: 'L\'esclavage a été aboli en France en 1848.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 0,
      explanation: 'Décret signé par Victor Schœlcher.',
      subjectId: 'histoire-geo',
      chapterId: 'hg-19e',
    ),
    Question(
      id: 'x-hg-19-2',
      type: QuestionType.trueFalse,
      prompt: 'La machine à vapeur a été perfectionnée par James Watt.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 0,
      explanation: 'Fin XVIIIᵉ — décollage de la révolution industrielle.',
      subjectId: 'histoire-geo',
      chapterId: 'hg-19e',
    ),

    // ───── Histoire-géo · XXe ─────
    Question(
      id: 'x-hg-xxe-1',
      type: QuestionType.trueFalse,
      prompt: 'Le débarquement en Normandie a eu lieu le 6 juin 1944.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 0,
      explanation: 'D-Day : ouverture du second front à l\'ouest.',
      subjectId: 'histoire-geo',
      chapterId: 'hg-xxe',
    ),
    Question(
      id: 'x-hg-xxe-2',
      type: QuestionType.trueFalse,
      prompt: 'La SDN a été créée après la Seconde Guerre mondiale.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 1,
      explanation:
          'La SDN a été créée après la Première (1920). L\'ONU est venue après la Seconde.',
      subjectId: 'histoire-geo',
      chapterId: 'hg-xxe',
    ),

    // ───── Histoire-géo · Vᵉ République ─────
    Question(
      id: 'x-hg-rep-1',
      type: QuestionType.trueFalse,
      prompt:
          'Le quinquennat (mandat de 5 ans) a été instauré en France en 2000.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 0,
      explanation:
          'Référendum du 24 septembre 2000, appliqué pour la 1ʳᵉ fois en 2002.',
      subjectId: 'histoire-geo',
      chapterId: 'hg-republique',
    ),
    Question(
      id: 'x-hg-rep-2',
      type: QuestionType.trueFalse,
      prompt: 'Le président de la République nomme le Premier ministre.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 0,
      explanation: 'Article 8 de la Constitution.',
      subjectId: 'histoire-geo',
      chapterId: 'hg-republique',
    ),

    // ───── Sciences · SVT ─────
    Question(
      id: 'x-sc-svt-1',
      type: QuestionType.trueFalse,
      prompt: 'La photosynthèse libère de l\'oxygène.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 0,
      explanation:
          'CO₂ + H₂O + lumière → glucose + O₂. Les plantes restituent l\'O₂.',
      subjectId: 'sciences',
      chapterId: 'sc-svt',
    ),
    Question(
      id: 'x-sc-svt-2',
      type: QuestionType.trueFalse,
      prompt:
          'Les chromosomes humains sont au nombre de 23 paires (46 chromosomes).',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 0,
      explanation: '46 chromosomes répartis en 23 paires.',
      subjectId: 'sciences',
      chapterId: 'sc-svt',
    ),

    // ───── Sciences · Physique-Chimie ─────
    Question(
      id: 'x-sc-phy-1',
      type: QuestionType.trueFalse,
      prompt: 'L\'eau bout à 100 °C au niveau de la mer.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 0,
      explanation:
          'Sous pression atmosphérique standard. La température baisse en altitude.',
      subjectId: 'sciences',
      chapterId: 'sc-physique',
    ),
    Question(
      id: 'x-sc-phy-2',
      type: QuestionType.trueFalse,
      prompt: 'La formule chimique du dioxyde de carbone est CO.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 1,
      explanation: 'C\'est CO₂. CO est le monoxyde de carbone.',
      subjectId: 'sciences',
      chapterId: 'sc-physique',
    ),
    Question(
      id: 'x-sc-phy-3',
      type: QuestionType.trueFalse,
      prompt: 'La tension électrique se mesure en ampères.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 1,
      explanation: 'La tension se mesure en volts. L\'ampère mesure l\'intensité.',
      subjectId: 'sciences',
      chapterId: 'sc-physique',
    ),

    // ───── Sciences · Énergies (3e) ─────
    Question(
      id: 'x-sc-en-1',
      type: QuestionType.trueFalse,
      prompt: 'Le pétrole est une énergie renouvelable.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 1,
      explanation: 'C\'est une énergie fossile, finie.',
      subjectId: 'sciences',
      chapterId: 'sc-energie',
    ),
    Question(
      id: 'x-sc-en-2',
      type: QuestionType.trueFalse,
      prompt: 'L\'énergie solaire est une énergie renouvelable.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 0,
      explanation: 'Le rayonnement solaire est inépuisable à l\'échelle humaine.',
      subjectId: 'sciences',
      chapterId: 'sc-energie',
    ),

    // ───── Anglais · Grammar ─────
    Question(
      id: 'x-en-gr-1',
      type: QuestionType.trueFalse,
      prompt: 'The past simple of "go" is "goed".',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 1,
      explanation: 'It is "went" (irregular verb).',
      subjectId: 'anglais',
      chapterId: 'en-grammar',
    ),
    Question(
      id: 'x-en-gr-2',
      type: QuestionType.trueFalse,
      prompt: '"He don\'t like coffee" is grammatically correct.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 1,
      explanation: 'It should be "He doesn\'t like coffee" (3rd person singular).',
      subjectId: 'anglais',
      chapterId: 'en-grammar',
    ),

    // ───── Anglais · Vocabulary ─────
    Question(
      id: 'x-en-voc-1',
      type: QuestionType.trueFalse,
      prompt: '"Library" means "librairie" in French.',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 1,
      explanation:
          'Faux ami : library = bibliothèque. Librairie = bookshop.',
      subjectId: 'anglais',
      chapterId: 'en-vocab',
    ),
    Question(
      id: 'x-en-voc-2',
      type: QuestionType.trueFalse,
      prompt: '"Actually" means "actuellement".',
      choices: <String>['Vrai', 'Faux'],
      answerIndex: 1,
      explanation:
          'Faux ami : actually = en fait. Actuellement = currently.',
      subjectId: 'anglais',
      chapterId: 'en-vocab',
    ),
  ];
}
