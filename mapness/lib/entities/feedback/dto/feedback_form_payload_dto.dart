import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/entities/feedback/dto/feedback_field_payload_dto.dart';
import 'package:mapness/entities/feedback/feedback_form_payload_entity.dart';

part 'feedback_form_payload_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedbackFormPayloadDto {
  final String category;
  final List<FeedbackFieldPayloadDto> fields;
  final double latitude;
  final double longitude;
  final String objectId;
  final String objectType;
  final String userEmail;

  const FeedbackFormPayloadDto({
    required this.category,
    required this.fields,
    required this.latitude,
    required this.longitude,
    required this.objectId,
    required this.objectType,
    required this.userEmail,
  });

  Map<String, dynamic> toJson() => _$FeedbackFormPayloadDtoToJson(this);

  factory FeedbackFormPayloadDto.fromDomain(
    FeedbackFormPayloadEntity entity,
  ) =>
      FeedbackFormPayloadDto(
        category: entity.category.name,
        fields: entity.fields.map((e) => FeedbackFieldPayloadDto.fromDomain(e)).toList(),
        latitude: entity.latitude,
        longitude: entity.longitude,
        objectId: entity.objectId,
        objectType: entity.objectType,
        userEmail: entity.userEmail,
      );
}
