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

  bool isStringValid() {
    final regex = switch (type) {
      FeedbackTextType.email =>
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
      FeedbackTextType.phone => RegExp(r'^\+?[0-9]{10,14}$'),
      FeedbackTextType.url => RegExp(
          r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$'),
      _ => null,
    };
    if (regex == null) {
      return true;
    }

    return regex.hasMatch(value ?? '');
  }

  @override
  bool get isValid => !isRequired || (value != null && isStringValid());

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
