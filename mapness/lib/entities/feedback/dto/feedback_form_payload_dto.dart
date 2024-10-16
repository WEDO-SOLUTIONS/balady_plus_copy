import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/entities/feedback/dto/feedback_field_payload_dto.dart';
import 'package:mapness/entities/feedback/feedback_form_payload_entity.dart';
import 'package:mapness/entities/feedback/feedback_object_type.dart';

part 'feedback_form_payload_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class FeedbackFormPayloadDto {
  final String category;
  final List<FeedbackFieldPayloadDto> fields;
  final double latitude;
  final double longitude;
  final String objectId;
  final String objectType;
  final String? userEmail;

  const FeedbackFormPayloadDto({
    required this.category,
    required this.fields,
    required this.latitude,
    required this.longitude,
    required this.objectId,
    required this.objectType,
    this.userEmail,
  });

  Map<String, dynamic> toJson() => _$FeedbackFormPayloadDtoToJson(this);

  factory FeedbackFormPayloadDto.fromDomain({
    required FeedbackFormPayloadEntity entity,
    required double latitude,
    required double longitude,
    required FeedbackObjectType objectType,
    String? userEmail,
  }) =>
      FeedbackFormPayloadDto(
        category: entity.category,
        fields: entity.fields.unlock,
        latitude: latitude,
        longitude: longitude,
        objectId: entity.objectId.toString(),
        objectType: objectType.name,
        userEmail: userEmail,
      );
}
