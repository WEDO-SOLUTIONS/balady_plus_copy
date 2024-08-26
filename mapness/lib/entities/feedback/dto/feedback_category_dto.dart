import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/entities/feedback/dto/feedback_base_dto.dart';
import 'package:mapness/entities/feedback/feedback_category.dart';
part 'feedback_category_dto.g.dart';

@JsonSerializable(createToJson: false)
class FeedbackCategoryDto {
  final String name;

  final List<FeedbackBaseDto> fields;

  FeedbackCategoryDto({
    required this.name,
    required this.fields,
  });

  factory FeedbackCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$FeedbackCategoryDtoFromJson(json);

  /// because no field name
  static List<FeedbackCategoryDto> parseList(List<dynamic> jsonList) =>
      jsonList.map((json) => FeedbackCategoryDto.fromJson(json)).toList();

  /// convert to domain
  FeedbackCategoryEntity toDomain() => FeedbackCategoryEntity(
        name: name,
        fields: fields.map((e) => e.toDomain()).toList(),
      );
}
