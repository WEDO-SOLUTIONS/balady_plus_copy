import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/entities/feedback/dto/feedback_base_dto.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';

part 'feedback_image_input_dto.g.dart';

@JsonSerializable()
class FeedbackImageInputDto extends FeedbackBaseDto {
  final String label;
  final int size;
  final List<String> format;

  FeedbackImageInputDto({
    required super.id,
    required super.type,
    required super.isRequired,
    required this.label,
    required this.size,
    required this.format,
  });

  factory FeedbackImageInputDto.fromJson(Map<String, dynamic> json) =>
      _$FeedbackImageInputDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackImageInputDtoToJson(this);

  FeedbackImageInputEntity toDomain() => FeedbackImageInputEntity(
        id: id,
        isRequired: isRequired,
        label: label,
        maxSize: size,
        acceptedFormats: format,
      );
}
