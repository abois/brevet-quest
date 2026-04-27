/// Type de question — détermine quel mini-jeu peut l'utiliser.
enum QuestionType { qcm, trueFalse, calc }

/// Question de révision (QCM, Vrai/Faux ou calcul mental).
class Question {
  const Question({
    required this.id,
    required this.type,
    required this.prompt,
    required this.answerIndex,
    this.choices = const [],
    this.explanation,
    this.subjectId,
    this.chapterId,
  });

  final String id;
  final QuestionType type;
  final String prompt;
  final List<String> choices;

  /// Index de la bonne réponse dans `choices`.
  /// Pour `trueFalse` : 0 = vrai, 1 = faux.
  /// Pour `calc` : `choices` contient une seule valeur (la solution texte).
  final int answerIndex;

  final String? explanation;
  final String? subjectId;
  final String? chapterId;

  String get correctAnswer => choices[answerIndex];

  bool isCorrect(int? selectedIndex) =>
      selectedIndex != null && selectedIndex == answerIndex;
}
