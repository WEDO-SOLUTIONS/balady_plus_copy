part of '../dto/feedback_base_dto.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class FeedbackTextListDto extends FeedbackBaseDto {
  final String label;
  final int length;
  final String hint;
  @JsonKey(defaultValue: [])
  final List<String> values;
  @JsonKey(defaultValue: [])
  final List<String> oldValues;

  const FeedbackTextListDto({
    required this.values,
    required this.oldValues,
    required this.label,
    required this.length,
    required this.hint,
    required super.id,
    required super.type,
    required super.isRequired,
    super.isHidden = false,
    super.setOnMap = false,
  });

  factory FeedbackTextListDto.fromJson(Map<String, dynamic> json) => _$FeedbackTextListDtoFromJson(json);

  @override
  FeedbackTextListEntity toDomain() => FeedbackTextListEntity(
        id: id,
        isRequired: isRequired,
        isHidden: isHidden,
        values: values,
        oldValues: oldValues,
        label: label,
        maxLength: length,
        hint: hint,
        type: _resolveType(),
      );

  FeedbackTextType _resolveType() {
    if (id == 'phone') {
      return FeedbackTextType.phone;
    }
    if (id == 'website_url') {
      return FeedbackTextType.url;
    }

    return FeedbackTextType.text;
  }
}
