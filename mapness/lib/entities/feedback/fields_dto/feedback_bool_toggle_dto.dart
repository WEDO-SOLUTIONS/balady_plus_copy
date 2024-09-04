part of '../dto/feedback_base_dto.dart';

/// owner type
@JsonSerializable(fieldRename: FieldRename.snake)
class FeedbackBoolToggleDto extends FeedbackBaseDto {
  final String label;

  FeedbackBoolToggleDto({
    required super.id,
    required super.type,
    required super.isRequired,
    required this.label,
    required super.isHidden,
  });

  @override
  FeedbackBoolToggleEntity toDomain() => FeedbackBoolToggleEntity(
        id: id,
        isRequired: isRequired,
        label: label,
        isHidden: isHidden,
      );
}
