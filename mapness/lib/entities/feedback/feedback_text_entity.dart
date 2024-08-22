part of 'feedback_base_entity.dart';

enum FeedbackTextType {
  text,
  multilineText,
  email,
  phone,
  url,
}

class FeedbackTextEntity extends FeedbackBaseEntity {
  final String label;
  final int maxLenght;
  final String hint;
  final FeedbackTextType type;

  FeedbackTextEntity({
    required this.type,
    required super.id,
    required super.isRequired,
    required this.label,
    required this.maxLenght,
    required this.hint,
  });
}
