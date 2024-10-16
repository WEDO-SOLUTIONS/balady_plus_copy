part of '../dto/feedback_base_dto.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedbackTextDto extends FeedbackBaseDto {
  final String label;
  final int length;
  final String hint;

  const FeedbackTextDto({
    required this.label,
    required this.length,
    required this.hint,
    required super.id,
    required super.type,
    required super.isRequired,
    required super.setOnMap,
    super.isHidden = false,
  });

  factory FeedbackTextDto.fromJson(Map<String, dynamic> json) => _$FeedbackTextDtoFromJson(json);

  @override
  FeedbackTextEntity toDomain() => FeedbackTextEntity(
        id: id,
        isRequired: isRequired,
        isHidden: isHidden,
        label: label,
        maxLength: length,
        hint: hint,
        type: resolveType(),
      );

  FeedbackTextType resolveType() {
    if (id == 'phone') {
      return FeedbackTextType.phone;
    }
    if (id == 'website_url') {
      return FeedbackTextType.url;
    }

    return switch (type) {
      'email' => FeedbackTextType.email,
      'multiline' => FeedbackTextType.multilineText,
      _ => FeedbackTextType.text
    };
  }
}
