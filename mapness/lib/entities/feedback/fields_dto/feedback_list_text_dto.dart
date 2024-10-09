part of '../dto/feedback_base_dto.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class FeedbackListTextDto extends FeedbackBaseDto {
  final List<FeedbackTextDto> fields;

  FeedbackListTextDto({
    required this.fields,
    required super.id,
    required super.type,
    required super.isRequired,
    super.isHidden = false,
  });

  @override
  FeedbackTextListEntity toDomain() => FeedbackTextListEntity(
        id: id,
        isRequired: isRequired,
        isHidden: isHidden,
        fields: fields.map((e) => e.toDomain()).toList(),
        type: fields.firstOrNull?.resolveType() ?? FeedbackTextType.text,
      );
}
