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

    // ═══════════════ QCM supplémentaires ═══════════════

    // ───── Maths · Pythagore & Thalès (4e) ─────
    Question(
      id: 'x-m-pyt-q1',
      type: QuestionType.qcm,
      prompt:
          'Triangle rectangle, côtés de l\'angle droit 9 et 12. Hypoténuse ?',
      choices: <String>['13', '14', '15', '21'],
      answerIndex: 2,
      explanation: '9² + 12² = 81 + 144 = 225 = 15².',
      subjectId: 'maths',
      chapterId: 'maths-pythagore',
    ),
    Question(
      id: 'x-m-pyt-q2',
      type: QuestionType.qcm,
      prompt: 'Hypoténuse 17, un côté 8. L\'autre côté ?',
      choices: <String>['9', '13', '15', '16'],
      answerIndex: 2,
      explanation: '17² − 8² = 289 − 64 = 225 = 15².',
      subjectId: 'maths',
      chapterId: 'maths-pythagore',
    ),
    Question(
      id: 'x-m-pyt-q3',
      type: QuestionType.qcm,
      prompt:
          'Dans Thalès : AD=4, AB=10, BC=15. Combien vaut DE ?',
      choices: <String>['4', '6', '8', '10'],
      answerIndex: 1,
      explanation: 'DE = BC × AD/AB = 15 × 4/10 = 6.',
      subjectId: 'maths',
      chapterId: 'maths-pythagore',
    ),
    Question(
      id: 'x-m-pyt-q4',
      type: QuestionType.qcm,
      prompt: 'Triangle 7-24-25 : est-il rectangle ?',
      choices: <String>['Oui', 'Non', 'Isocèle', 'Indéterminé'],
      answerIndex: 0,
      explanation: '7² + 24² = 49 + 576 = 625 = 25² → oui.',
      subjectId: 'maths',
      chapterId: 'maths-pythagore',
    ),

    // ───── Maths · Calcul & Fractions (4e) ─────
    Question(
      id: 'x-m-calc-q1',
      type: QuestionType.qcm,
      prompt: 'Calcule : (−7) + 12',
      choices: <String>['−5', '5', '−19', '19'],
      answerIndex: 1,
      explanation: '12 − 7 = 5.',
      subjectId: 'maths',
      chapterId: 'maths-calcul',
    ),
    Question(
      id: 'x-m-calc-q2',
      type: QuestionType.qcm,
      prompt: '2/3 × 9/4 = ?',
      choices: <String>['3/2', '11/12', '6/7', '18/12'],
      answerIndex: 0,
      explanation: '(2 × 9) / (3 × 4) = 18/12 = 3/2.',
      subjectId: 'maths',
      chapterId: 'maths-calcul',
    ),
    Question(
      id: 'x-m-calc-q3',
      type: QuestionType.qcm,
      prompt: '5/6 − 1/3 = ?',
      choices: <String>['1/3', '1/2', '4/3', '2/3'],
      answerIndex: 1,
      explanation: '5/6 − 2/6 = 3/6 = 1/2.',
      subjectId: 'maths',
      chapterId: 'maths-calcul',
    ),
    Question(
      id: 'x-m-calc-q4',
      type: QuestionType.qcm,
      prompt: '10⁴ × 10² = ?',
      choices: <String>['10⁶', '10⁸', '10²', '100⁶'],
      answerIndex: 0,
      explanation: 'Puissances de même base : on additionne les exposants.',
      subjectId: 'maths',
      chapterId: 'maths-calcul',
    ),
    Question(
      id: 'x-m-calc-q5',
      type: QuestionType.qcm,
      prompt: 'Quelle est l\'écriture scientifique de 0,000 5 ?',
      choices: <String>['5 × 10⁻⁴', '5 × 10⁻³', '0,5 × 10⁻³', '5 × 10⁴'],
      answerIndex: 0,
      explanation: '0,000 5 = 5 × 10⁻⁴.',
      subjectId: 'maths',
      chapterId: 'maths-calcul',
    ),

    // ───── Maths · Géométrie & Aires (4e) ─────
    Question(
      id: 'x-m-geo-q1',
      type: QuestionType.qcm,
      prompt: 'Aire d\'un disque de rayon 6 cm (π ≈ 3,14) ?',
      choices: <String>[
        '36 cm²',
        '37,68 cm²',
        '113,04 cm²',
        '18,84 cm²'
      ],
      answerIndex: 2,
      explanation: 'π × 36 ≈ 113,04 cm².',
      subjectId: 'maths',
      chapterId: 'maths-geometrie',
    ),
    Question(
      id: 'x-m-geo-q2',
      type: QuestionType.qcm,
      prompt: 'Aire d\'un triangle de base 12 cm et hauteur 5 cm ?',
      choices: <String>['30 cm²', '60 cm²', '17 cm²', '24 cm²'],
      answerIndex: 0,
      explanation: '(12 × 5) / 2 = 30 cm².',
      subjectId: 'maths',
      chapterId: 'maths-geometrie',
    ),
    Question(
      id: 'x-m-geo-q3',
      type: QuestionType.qcm,
      prompt:
          'Combien de faces possède un cube ?',
      choices: <String>['4', '6', '8', '12'],
      answerIndex: 1,
      explanation: '6 faces carrées.',
      subjectId: 'maths',
      chapterId: 'maths-geometrie',
    ),
    Question(
      id: 'x-m-geo-q4',
      type: QuestionType.qcm,
      prompt:
          'Volume d\'un cylindre de rayon 2 et hauteur 5 (π ≈ 3,14) ?',
      choices: <String>['62,8', '31,4', '20', '125,6'],
      answerIndex: 0,
      explanation: 'π × r² × h = 3,14 × 4 × 5 = 62,8.',
      subjectId: 'maths',
      chapterId: 'maths-geometrie',
    ),

    // ───── Maths · Stats & Probas (3e) ─────
    Question(
      id: 'x-m-stat-q1',
      type: QuestionType.qcm,
      prompt:
          'Moyenne de la série : 3, 5, 8, 12, 7 ?',
      choices: <String>['6', '7', '8', '9'],
      answerIndex: 1,
      explanation: '(3+5+8+12+7)/5 = 35/5 = 7.',
      subjectId: 'maths',
      chapterId: 'maths-stats',
    ),
    Question(
      id: 'x-m-stat-q2',
      type: QuestionType.qcm,
      prompt:
          'On lance un dé équilibré : probabilité d\'obtenir un 6 ?',
      choices: <String>['1/2', '1/3', '1/6', '1/12'],
      answerIndex: 2,
      explanation: '1 chance sur 6.',
      subjectId: 'maths',
      chapterId: 'maths-stats',
    ),
    Question(
      id: 'x-m-stat-q3',
      type: QuestionType.qcm,
      prompt: 'Médiane de la série : 4, 7, 9, 12, 15 ?',
      choices: <String>['7', '9', '12', '47/5'],
      answerIndex: 1,
      explanation: 'Valeur centrale de la série triée à 5 termes : 9.',
      subjectId: 'maths',
      chapterId: 'maths-stats',
    ),

    // ───── Français · Conjugaison ─────
    Question(
      id: 'x-fr-conj-q1',
      type: QuestionType.qcm,
      prompt: '« Vous (faire) » au présent de l\'indicatif ?',
      choices: <String>['faisez', 'faites', 'faisiez', 'fassiez'],
      answerIndex: 1,
      explanation: 'Vous faites (3ᵉ groupe, irrégulier).',
      subjectId: 'francais',
      chapterId: 'fr-conjugaison',
    ),
    Question(
      id: 'x-fr-conj-q2',
      type: QuestionType.qcm,
      prompt: 'Imparfait de "aller" à la 1ʳᵉ personne du pluriel ?',
      choices: <String>['allions', 'allons', 'allâmes', 'irions'],
      answerIndex: 0,
      explanation: 'Nous allions.',
      subjectId: 'francais',
      chapterId: 'fr-conjugaison',
    ),
    Question(
      id: 'x-fr-conj-q3',
      type: QuestionType.qcm,
      prompt: 'Subjonctif présent de "faire" 1ʳᵉ pers sing ?',
      choices: <String>['que je fais', 'que je fasse', 'que je faisais', 'que je ferai'],
      answerIndex: 1,
      explanation: 'Que je fasse / tu fasses / il fasse.',
      subjectId: 'francais',
      chapterId: 'fr-conjugaison',
    ),
    Question(
      id: 'x-fr-conj-q4',
      type: QuestionType.qcm,
      prompt:
          'Conditionnel présent de "voir" 2ᵉ pers sing ?',
      choices: <String>['tu voyais', 'tu vois', 'tu verrais', 'tu vis'],
      answerIndex: 2,
      explanation: 'Conditionnel = radical de futur (verr-) + terminaisons d\'imparfait.',
      subjectId: 'francais',
      chapterId: 'fr-conjugaison',
    ),

    // ───── Français · Littérature ─────
    Question(
      id: 'x-fr-litt-q1',
      type: QuestionType.qcm,
      prompt: 'Auteur de "Madame Bovary" ?',
      choices: <String>['Hugo', 'Zola', 'Flaubert', 'Maupassant'],
      answerIndex: 2,
      explanation: 'Gustave Flaubert (1857).',
      subjectId: 'francais',
      chapterId: 'fr-litterature',
    ),
    Question(
      id: 'x-fr-litt-q2',
      type: QuestionType.qcm,
      prompt: 'Quel courant littéraire pour Émile Zola ?',
      choices: <String>['Romantisme', 'Naturalisme', 'Symbolisme', 'Surréalisme'],
      answerIndex: 1,
      explanation: 'Zola = chef de file du naturalisme.',
      subjectId: 'francais',
      chapterId: 'fr-litterature',
    ),
    Question(
      id: 'x-fr-litt-q3',
      type: QuestionType.qcm,
      prompt: '"L\'Étranger" est un roman de…',
      choices: <String>['Proust', 'Sartre', 'Camus', 'Gide'],
      answerIndex: 2,
      explanation: 'Albert Camus, 1942.',
      subjectId: 'francais',
      chapterId: 'fr-litterature',
    ),
    Question(
      id: 'x-fr-litt-q4',
      type: QuestionType.qcm,
      prompt:
          'Quel auteur du XIXᵉ a écrit "Les Fleurs du Mal" ?',
      choices: <String>['Verlaine', 'Rimbaud', 'Baudelaire', 'Mallarmé'],
      answerIndex: 2,
      explanation: 'Baudelaire (1857).',
      subjectId: 'francais',
      chapterId: 'fr-litterature',
    ),

    // ───── Français · Grammaire ─────
    Question(
      id: 'x-fr-gram-q1',
      type: QuestionType.qcm,
      prompt:
          'Dans "Le chat dort sur le canapé", "sur le canapé" est un :',
      choices: <String>[
        'Complément du nom',
        'COD',
        'Complément circ. de lieu',
        'Attribut'
      ],
      answerIndex: 2,
      explanation:
          'Indique le lieu de l\'action — complément circonstanciel de lieu.',
      subjectId: 'francais',
      chapterId: 'fr-grammaire',
    ),
    Question(
      id: 'x-fr-gram-q2',
      type: QuestionType.qcm,
      prompt: 'Nature de "rapidement" dans "Il court rapidement" ?',
      choices: <String>['Adjectif', 'Adverbe', 'Pronom', 'Préposition'],
      answerIndex: 1,
      explanation: 'Adverbe modifiant le verbe.',
      subjectId: 'francais',
      chapterId: 'fr-grammaire',
    ),
    Question(
      id: 'x-fr-gram-q3',
      type: QuestionType.qcm,
      prompt: 'Voix passive de "Le chat mange la souris" :',
      choices: <String>[
        'Le chat est mangé par la souris',
        'La souris est mangée par le chat',
        'La souris mange le chat',
        'Le chat a mangé la souris'
      ],
      answerIndex: 1,
      explanation:
          'Le COD devient sujet, le sujet devient compl. d\'agent.',
      subjectId: 'francais',
      chapterId: 'fr-grammaire',
    ),
    Question(
      id: 'x-fr-gram-q4',
      type: QuestionType.qcm,
      prompt:
          'Quelle conjonction introduit une cause ?',
      choices: <String>['bien que', 'parce que', 'pour que', 'si bien que'],
      answerIndex: 1,
      explanation:
          '"Parce que" introduit la cause. "Bien que" = concession, "pour que" = but.',
      subjectId: 'francais',
      chapterId: 'fr-grammaire',
    ),

    // ───── Histoire-géo · XIXᵉ (4e) ─────
    Question(
      id: 'x-hg-19-q1',
      type: QuestionType.qcm,
      prompt: 'Quelle révolution éclate en France en 1789 ?',
      choices: <String>['Industrielle', 'Française', 'd\'Octobre', 'Verte'],
      answerIndex: 1,
      explanation: 'Révolution française : prise de la Bastille le 14 juillet.',
      subjectId: 'histoire-geo',
      chapterId: 'hg-19e',
    ),
    Question(
      id: 'x-hg-19-q2',
      type: QuestionType.qcm,
      prompt: 'Qui devient empereur des Français en 1804 ?',
      choices: <String>['Louis XVI', 'Napoléon Bonaparte', 'Charles X', 'Louis-Philippe'],
      answerIndex: 1,
      explanation: 'Sacre de Napoléon Iᵉʳ le 2 décembre 1804.',
      subjectId: 'histoire-geo',
      chapterId: 'hg-19e',
    ),
    Question(
      id: 'x-hg-19-q3',
      type: QuestionType.qcm,
      prompt:
          'Sous quelle République l\'école devient-elle gratuite, laïque et obligatoire ?',
      choices: <String>['Iʳᵉ', 'IIIᵉ', 'IVᵉ', 'Vᵉ'],
      answerIndex: 1,
      explanation: 'Lois Ferry, IIIᵉ République (1881-1882).',
      subjectId: 'histoire-geo',
      chapterId: 'hg-19e',
    ),

    // ───── Histoire-géo · XXᵉ (3e) ─────
    Question(
      id: 'x-hg-xxe-q1',
      type: QuestionType.qcm,
      prompt: 'Année de l\'armistice de la 1ʳᵉ Guerre mondiale ?',
      choices: <String>['1914', '1917', '1918', '1939'],
      answerIndex: 2,
      explanation: '11 novembre 1918.',
      subjectId: 'histoire-geo',
      chapterId: 'hg-xxe',
    ),
    Question(
      id: 'x-hg-xxe-q2',
      type: QuestionType.qcm,
      prompt: 'Qui est le chef de la France libre pendant la 2nde G.M. ?',
      choices: <String>['Pétain', 'De Gaulle', 'Reynaud', 'Daladier'],
      answerIndex: 1,
      explanation: 'Charles de Gaulle, appel du 18 juin 1940.',
      subjectId: 'histoire-geo',
      chapterId: 'hg-xxe',
    ),
    Question(
      id: 'x-hg-xxe-q3',
      type: QuestionType.qcm,
      prompt: 'En quelle année tombe le mur de Berlin ?',
      choices: <String>['1985', '1989', '1991', '1995'],
      answerIndex: 1,
      explanation: '9 novembre 1989, fin de la guerre froide en perspective.',
      subjectId: 'histoire-geo',
      chapterId: 'hg-xxe',
    ),
    Question(
      id: 'x-hg-xxe-q4',
      type: QuestionType.qcm,
      prompt:
          'En quelle année les Françaises obtiennent-elles le droit de vote ?',
      choices: <String>['1936', '1944', '1945', '1968'],
      answerIndex: 1,
      explanation:
          'Ordonnance du 21 avril 1944 par le Comité français de libération nationale.',
      subjectId: 'histoire-geo',
      chapterId: 'hg-xxe',
    ),

    // ───── Histoire-géo · Vᵉ République ─────
    Question(
      id: 'x-hg-rep-q1',
      type: QuestionType.qcm,
      prompt:
          'Combien de temps dure le mandat présidentiel sous la Vᵉ depuis 2002 ?',
      choices: <String>['4 ans', '5 ans', '7 ans', '10 ans'],
      answerIndex: 1,
      explanation: 'Quinquennat (2000 → application en 2002).',
      subjectId: 'histoire-geo',
      chapterId: 'hg-republique',
    ),
    Question(
      id: 'x-hg-rep-q2',
      type: QuestionType.qcm,
      prompt:
          'Quelle assemblée vote les lois sous la Vᵉ République ?',
      choices: <String>[
        'Sénat seul',
        'Assemblée nationale uniquement',
        'Parlement (Assemblée + Sénat)',
        'Conseil constitutionnel'
      ],
      answerIndex: 2,
      explanation:
          'Le Parlement = Assemblée nationale + Sénat. L\'AN a le dernier mot.',
      subjectId: 'histoire-geo',
      chapterId: 'hg-republique',
    ),
    Question(
      id: 'x-hg-rep-q3',
      type: QuestionType.qcm,
      prompt:
          'En quelle année est élu François Mitterrand pour la 1ʳᵉ fois ?',
      choices: <String>['1974', '1981', '1988', '1995'],
      answerIndex: 1,
      explanation: '10 mai 1981, 1ʳᵉ alternance de gauche sous la Vᵉ.',
      subjectId: 'histoire-geo',
      chapterId: 'hg-republique',
    ),

    // ───── Sciences · SVT ─────
    Question(
      id: 'x-sc-svt-q1',
      type: QuestionType.qcm,
      prompt: 'Quel organite produit l\'énergie de la cellule ?',
      choices: <String>[
        'Noyau',
        'Mitochondrie',
        'Ribosome',
        'Chloroplaste'
      ],
      answerIndex: 1,
      explanation: 'Les mitochondries assurent la respiration cellulaire.',
      subjectId: 'sciences',
      chapterId: 'sc-svt',
    ),
    Question(
      id: 'x-sc-svt-q2',
      type: QuestionType.qcm,
      prompt:
          'Combien de paires de chromosomes possède l\'être humain ?',
      choices: <String>['22', '23', '24', '46'],
      answerIndex: 1,
      explanation: '23 paires (= 46 chromosomes).',
      subjectId: 'sciences',
      chapterId: 'sc-svt',
    ),
    Question(
      id: 'x-sc-svt-q3',
      type: QuestionType.qcm,
      prompt:
          'Que produisent les plantes lors de la photosynthèse ?',
      choices: <String>[
        'CO₂ et chaleur',
        'Glucose et O₂',
        'Eau seulement',
        'Méthane'
      ],
      answerIndex: 1,
      explanation:
          '6 CO₂ + 6 H₂O + lumière → C₆H₁₂O₆ + 6 O₂.',
      subjectId: 'sciences',
      chapterId: 'sc-svt',
    ),

    // ───── Sciences · Physique-Chimie ─────
    Question(
      id: 'x-sc-phy-q1',
      type: QuestionType.qcm,
      prompt: 'Unité de mesure de la force ?',
      choices: <String>['Joule', 'Newton', 'Watt', 'Pascal'],
      answerIndex: 1,
      explanation:
          'Le newton (N), du nom d\'Isaac Newton.',
      subjectId: 'sciences',
      chapterId: 'sc-physique',
    ),
    Question(
      id: 'x-sc-phy-q2',
      type: QuestionType.qcm,
      prompt: 'Symbole chimique de l\'or ?',
      choices: <String>['Or', 'O', 'Au', 'Ag'],
      answerIndex: 2,
      explanation: 'Au, du latin "aurum".',
      subjectId: 'sciences',
      chapterId: 'sc-physique',
    ),
    Question(
      id: 'x-sc-phy-q3',
      type: QuestionType.qcm,
      prompt:
          'À quelle température fond la glace au niveau de la mer ?',
      choices: <String>['−10 °C', '0 °C', '4 °C', '100 °C'],
      answerIndex: 1,
      explanation: '0 °C sous pression atmosphérique standard.',
      subjectId: 'sciences',
      chapterId: 'sc-physique',
    ),

    // ───── Sciences · Énergies (3e) ─────
    Question(
      id: 'x-sc-en-q1',
      type: QuestionType.qcm,
      prompt:
          'Laquelle de ces énergies est renouvelable ?',
      choices: <String>['Charbon', 'Pétrole', 'Éolien', 'Gaz naturel'],
      answerIndex: 2,
      explanation:
          'Le vent est inépuisable à l\'échelle humaine.',
      subjectId: 'sciences',
      chapterId: 'sc-energie',
    ),
    Question(
      id: 'x-sc-en-q2',
      type: QuestionType.qcm,
      prompt: 'Principal gaz à effet de serre lié aux énergies fossiles ?',
      choices: <String>['O₂', 'N₂', 'CO₂', 'Ar'],
      answerIndex: 2,
      explanation:
          'Le CO₂ piège la chaleur dans l\'atmosphère.',
      subjectId: 'sciences',
      chapterId: 'sc-energie',
    ),

    // ───── Anglais · Grammar ─────
    Question(
      id: 'x-en-gr-q1',
      type: QuestionType.qcm,
      prompt: 'Past simple of "to take" ?',
      choices: <String>['taked', 'took', 'taken', 'taking'],
      answerIndex: 1,
      explanation: 'take/took/taken (irregular).',
      subjectId: 'anglais',
      chapterId: 'en-grammar',
    ),
    Question(
      id: 'x-en-gr-q2',
      type: QuestionType.qcm,
      prompt: 'Choisis la bonne forme : "She ___ to school every day."',
      choices: <String>['go', 'goes', 'going', 'gone'],
      answerIndex: 1,
      explanation: '3ᵉ pers du sing au présent simple : verbe + s.',
      subjectId: 'anglais',
      chapterId: 'en-grammar',
    ),

    // ───── Anglais · Vocabulary ─────
    Question(
      id: 'x-en-voc-q1',
      type: QuestionType.qcm,
      prompt: 'Traduction de "homework" ?',
      choices: <String>['maison', 'devoirs', 'travail à la maison', 'œuvre'],
      answerIndex: 1,
      explanation: 'Homework = devoirs scolaires.',
      subjectId: 'anglais',
      chapterId: 'en-vocab',
    ),
    Question(
      id: 'x-en-voc-q2',
      type: QuestionType.qcm,
      prompt: 'Que veut dire "to borrow" ?',
      choices: <String>['prêter', 'emprunter', 'voler', 'donner'],
      answerIndex: 1,
      explanation: 'Borrow = emprunter. Lend = prêter.',
      subjectId: 'anglais',
      chapterId: 'en-vocab',
    ),
  ];
}
