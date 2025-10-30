import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show Faq;

class FaqModel extends Faq {
  FaqModel({super.answer, super.question});

  factory FaqModel.fromMap(Map<String, dynamic> json) => FaqModel(
        question: json["question"],
        answer: json["answer"],
      );
}
