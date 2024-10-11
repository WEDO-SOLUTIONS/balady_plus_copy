part of '../dto/feedback_base_dto.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedbackImageInputDto extends FeedbackBaseDto {
  final String label;
  final int size;
  final List<String> format;

  const FeedbackImageInputDto({
    required super.id,
    required super.type,
    required super.isRequired,
    required this.label,
    required this.size,
    required this.format,
    super.isHidden = false,
    super.setOnMap = false,
  });

  @override
  FeedbackImageInputEntity toDomain() => FeedbackImageInputEntity(
        id: id,
        isRequired: isRequired,
        label: label,
        maxSize: size,
        acceptedFormats: format,
        isHidden: isHidden,
      );

  factory FeedbackImageInputDto.fromJson(Map<String, dynamic> json) => _$FeedbackImageInputDtoFromJson(json);
}
