import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/entities/feedback/dto/feedback_base_dto.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';

part 'feedback_bool_toggle_dto.g.dart';

/// owner type
@JsonSerializable()
class FeedbackBoolToggleDto extends FeedbackBaseDto {
  final String label;

  FeedbackBoolToggleDto({
    required super.id,
    required super.type,
    required super.isRequired,
    required this.label,
  });

  factory FeedbackBoolToggleDto.fromJson(Map<String, dynamic> json) =>
      _$FeedbackBoolToggleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackBoolToggleDtoToJson(this);

  FeedbackBoolToggleEntity toDomain() => FeedbackBoolToggleEntity(
        id: id,
        isRequired: isRequired,
        label: label,
      );
}
