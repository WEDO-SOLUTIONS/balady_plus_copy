part of '../feedback_base_entity.dart';

enum FeedbackTextType {
  text,
  multilineText,
  email,
  phone,
  url,
}

class FeedbackTextEntity extends FeedbackBaseEntity<String> {
  final String label;
  final int maxLenght;
  final String hint;
  final FeedbackTextType type;

  const FeedbackTextEntity({
    required this.type,
    required super.id,
    required super.isRequired,
    required this.label,
    required this.maxLenght,
    required this.hint,
    String? value,
  }) : super(value: value);

  @override
  FeedbackTextEntity updateValue(String value) => FeedbackTextEntity(
        id: id,
        isRequired: isRequired,
        label: label,
        maxLenght: maxLenght,
        hint: hint,
        type: type,
        value: value,
      );
}
