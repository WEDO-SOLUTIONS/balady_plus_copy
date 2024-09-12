import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/entities/feedback/feedback_field_payload_entity.dart';

part 'feedback_field_payload_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedbackFieldPayloadDto {
  final String id;
  final String value;

  /// Backend team told that this is due to reusing of the model to pass further.
  /// But since it is defined in API, I've added it.
  final String? oldValue;

  const FeedbackFieldPayloadDto({
    required this.id,
    required this.value,
    this.oldValue,
  });

  Map<String, dynamic> toJson() => _$FeedbackFieldPayloadDtoToJson(this);

  factory FeedbackFieldPayloadDto.fromDomain(
    FeedbackFieldPayloadEntity entity,
  ) =>
      FeedbackFieldPayloadDto(
        id: entity.fieldId,
        value: entity.value,
      );
}
