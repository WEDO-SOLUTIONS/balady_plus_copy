import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/entities/feedback/dto/feedback_base_dto.dart';
import 'package:mapness/entities/feedback/feedback_category.dart';

part 'feedback_category_dto.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class FeedbackCategoryDto {
  final String type;
  final String name;
  final String? icon;

  @JsonKey(fromJson: _fieldsFromJson)
  final List<FeedbackBaseDto> fields;

  FeedbackCategoryDto({
    required this.name,
    required this.fields,
    required this.type,
    this.icon,
  });

  factory FeedbackCategoryDto.fromJson(Map<String, dynamic> json) => _$FeedbackCategoryDtoFromJson(json);

  /// because no field name
  static List<FeedbackCategoryDto> parseList(List<dynamic> jsonList) =>
      jsonList.map((json) => FeedbackCategoryDto.fromJson(json)).toList();

  /// convert to domain
  FeedbackCategoryEntity toDomain() => FeedbackCategoryEntity(
        id: type,
        name: name,
        fields: fields.map((e) => e.toDomain()).toList(),
        iconUrl: icon,
      );

  static List<FeedbackBaseDto> _fieldsFromJson(List<dynamic> fieldsJson) {
    final result = <FeedbackBaseDto>[];

    final listSingleLineFields = <FeedbackBaseDto>[];
    int fieldGroupFistPosition = -1;
    for (int i = 0; i < fieldsJson.length; i++) {
      final json = fieldsJson[i] as Map<String, dynamic>;

      if (json['type'] != 'list_singleline') {
        result.add(FeedbackBaseDto.fromJson(json));
        continue;
      }
      if (fieldGroupFistPosition == -1) {
        fieldGroupFistPosition = i;
      }
      listSingleLineFields.add(FeedbackBaseDto.fromJson(json));
    }

    final groupedMap = listSingleLineFields.groupListsBy((filed) => filed.id);

    for (final group in groupedMap.entries) {
      if (fieldGroupFistPosition != -1) {
        result.insert(
            fieldGroupFistPosition,
            FeedbackListTextDto(
              id: group.key,
              fields: group.value.cast<FeedbackTextDto>(),
              type: group.key,
              isRequired: group.value.any((e) => e.isRequired),
            ));
      }
    }

    return result;
  }
}
