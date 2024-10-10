part of '../dto/feedback_base_dto.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedbackScheduleDto extends FeedbackBaseDto {
  final String label;

  FeedbackScheduleDto({
    required super.id,
    required super.type,
    required super.isRequired,
    required this.label,
    super.isHidden = false,
    super.setOnMap = false,
  });

  @override
  FeedbackScheduleEntity toDomain() => FeedbackScheduleEntity(
        id: id,
        isRequired: isRequired,
        isHidden: isHidden,
      );

  factory FeedbackScheduleDto.fromJson(Map<String, dynamic> json) => _$FeedbackScheduleDtoFromJson(json);
}
