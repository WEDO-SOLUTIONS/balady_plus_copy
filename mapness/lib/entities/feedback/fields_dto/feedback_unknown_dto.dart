part of '../dto/feedback_base_dto.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedbackUnknownDto extends FeedbackBaseDto {
  FeedbackUnknownDto({
    required super.id,
    required super.type,
    required super.isRequired,
    super.isHidden = false,
  });

  @override
  FeedbackUnknownEntity toDomain() => FeedbackUnknownEntity(
        id: id,
        isRequired: isRequired,
        isHidden: isHidden,
      );

  factory FeedbackUnknownDto.fromJson(Map<String, dynamic> json) => _$FeedbackUnknownDtoFromJson(json);
}
