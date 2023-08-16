class QAModel {
  final String? question;
  final String? answer;

  QAModel({this.question, this.answer});
  Map<String, dynamic> toJson() => {
        'question': question,
        'answer': answer,
      };

  static QAModel fromJson(Map<String, dynamic> json) => QAModel(
        question: json['question'],
        answer: json['answer'],
      );
}
