part of '../dto/feedback_base_dto.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedbackTextDto extends FeedbackBaseDto {
  final String label;
  final int length;
  final String hint;

  FeedbackTextDto({
    required super.id,
    required super.type,
    required super.isRequired,
    required this.label,
    required this.length,
    required this.hint,
  });

  @override
  FeedbackTextEntity toDomain() => FeedbackTextEntity(
        id: id,
        isRequired: isRequired,
        label: label,
        maxLenght: length,
        hint: hint,
        type: switch (type) {
          'email' => FeedbackTextType.email,
          'multiline' => FeedbackTextType.multilineText,
          'phone' => FeedbackTextType.phone,
          'url' => FeedbackTextType.url,
          'singleline' || _ => FeedbackTextType.text
        },
      );
}
