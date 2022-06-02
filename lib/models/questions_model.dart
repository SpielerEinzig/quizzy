class QuestionsModel {
  String question;
  String answer;
  bool questionAnswered;
  List<String> options;

  QuestionsModel({
    required this.question,
    required this.answer,
    required this.questionAnswered,
    required this.options,
  });
}
