part of '../dto/feedback_base_dto.dart';

@JsonSerializable()
class FeedbackUnknownDto extends FeedbackBaseDto {
  FeedbackUnknownDto({
    required super.id,
    required super.type,
    required super.isRequired,
  });

  @override
  FeedbackUnknownEntity toDomain() => FeedbackUnknownEntity(
        id: id,
        isRequired: isRequired,
      );
}
