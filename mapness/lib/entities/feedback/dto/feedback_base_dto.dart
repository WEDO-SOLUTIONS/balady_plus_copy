import 'package:json_annotation/json_annotation.dart';

part 'feedback_base_dto.g.dart';

@JsonSerializable()
class FeedbackBaseDto {
  final String id;
  final String type;
  final bool isRequired;

  FeedbackBaseDto({
    required this.id,
    required this.type,
    required this.isRequired,
  });

  factory FeedbackBaseDto.fromJson(Map<String, dynamic> json) =>
      _$FeedbackBaseDtoFromJson(json);
}
