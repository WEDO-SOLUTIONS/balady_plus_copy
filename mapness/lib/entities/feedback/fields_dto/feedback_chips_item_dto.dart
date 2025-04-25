part of '../dto/feedback_base_dto.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedbackChipsItemDto {
  final int id;
  final String value;
  final String? icon;
  final String? category;
  final String? subcategory;

  FeedbackChipsItemDto({
    required this.id,
    required this.value,
    this.icon,
    this.category,
    this.subcategory,
  });

  FeedbackChipsItemEntity toDomain() => FeedbackChipsItemEntity(
        id: id,
        label: subcategory ?? value,
        iconUrl: icon,
      );

  factory FeedbackChipsItemDto.fromJson(Map<String, dynamic> json) => _$FeedbackChipsItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackChipsItemDtoToJson(this);
}
