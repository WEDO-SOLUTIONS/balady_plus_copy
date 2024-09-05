part of '../dto/feedback_base_dto.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedbackScheduleDto extends FeedbackBaseDto {
  final String label;
  final List<String> variants;

  FeedbackScheduleDto({
    required super.id,
    required super.type,
    required super.isRequired,
    required super.isHidden,
    required this.label,
    required this.variants,
  });

  @override
  FeedbackScheduleEntity toDomain() => FeedbackScheduleEntity(
        id: id,
        isRequired: isRequired,
        isHidden: isHidden,
        label: label,
        variants: variants,
      );

  factory FeedbackScheduleDto.fromJson(Map<String, dynamic> json) => _$FeedbackScheduleDtoFromJson(json);
}
