part of '../dto/feedback_base_dto.dart';

/// owner type
@JsonSerializable(fieldRename: FieldRename.snake)
class FeedbackBoolToggleDto extends FeedbackBaseDto {
  final String label;
  final bool baladyBusiness;

  const FeedbackBoolToggleDto({
    required super.id,
    required super.type,
    required super.isRequired,
    required this.label,
    this.baladyBusiness = false,
    super.isHidden = false,
    super.setOnMap = false,
  });

  @override
  FeedbackBoolToggleEntity toDomain() => FeedbackBoolToggleEntity(
        id: id,
        isRequired: isRequired,
        label: label,
        isHidden: isHidden,
        baladyBusiness: baladyBusiness,
      );

  factory FeedbackBoolToggleDto.fromJson(Map<String, dynamic> json) => _$FeedbackBoolToggleDtoFromJson(json);
}
