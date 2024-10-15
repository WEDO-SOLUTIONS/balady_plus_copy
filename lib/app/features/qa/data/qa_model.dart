

class QAModel {
  QAModel({
    this.title,
    this.fieldFaqAnswer,
    this.fieldAnswer,});

  QAModel.fromJson(dynamic json) {
    title = json['title'];
    fieldFaqAnswer = json['field_faq_answer'];
    fieldAnswer = json['field_answer'];
  }
  String? title;
  String? fieldFaqAnswer;
  String? fieldAnswer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['field_faq_answer'] = fieldFaqAnswer;
    map['field_answer'] = fieldAnswer;
    return map;
  }
}
