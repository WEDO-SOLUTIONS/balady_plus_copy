part of '../dto/feedback_base_dto.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedbackWeekDaysDto extends FeedbackBaseDto {
  final String label;
  final List<String> variants;

  FeedbackWeekDaysDto({
    required super.id,
    required super.type,
    required super.isRequired,
    required super.isHidden,
    required this.label,
    required this.variants,
  });

  @override
  FeedbackWorkingHoursEntity toDomain() => FeedbackWorkingHoursEntity(
        id: id,
        isRequired: isRequired,
        isHidden: isHidden,
        label: label,
        variants: variants,
      );

  factory FeedbackWeekDaysDto.fromJson(Map<String, dynamic> json) => _$FeedbackWeekDaysDtoFromJson(json);
}
