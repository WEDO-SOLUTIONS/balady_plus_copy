import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/entities/feedback/dto/feedback_base_dto.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';

part 'feedback_text_dto.g.dart';

@JsonSerializable()
class FeedbackTextDto extends FeedbackBaseDto {
  final String label;
  final int length;
  final String hint;

  FeedbackTextDto({
    required super.id,
    required super.type,
    required super.isRequired,
    required this.label,
    required this.length,
    required this.hint,
  });

  factory FeedbackTextDto.fromJson(Map<String, dynamic> json) =>
      _$FeedbackTextDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackTextDtoToJson(this);

  FeedbackTextEntity toDomain() => FeedbackTextEntity(
        id: id,
        isRequired: isRequired,
        label: label,
        maxLenght: length,
        hint: hint,
        type: switch (type) {
          'email' => FeedbackTextType.email,
          'multiline' => FeedbackTextType.multilineText,
          'phone' => FeedbackTextType.phone,
          'url' => FeedbackTextType.url,
          'singleline' || _ => FeedbackTextType.text
        },
      );
}
