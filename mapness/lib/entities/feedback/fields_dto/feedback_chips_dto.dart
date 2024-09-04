part of '../dto/feedback_base_dto.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedbackChipsDto extends FeedbackBaseDto {
  final String label;
  final List<FeedbackChipsItemDto> variants;

  FeedbackChipsDto({
    required super.id,
    required super.type,
    required super.isRequired,
    required this.label,
    required this.variants,
    required super.isHidden,
  });

  @override
  FeedbackChipsEntity toDomain() => FeedbackChipsEntity(
        id: id,
        isRequired: isRequired,
        label: label,
        variants: variants.map((e) => e.toDomain()).toList(),
        value: UnmodifiableSetView<int>({}),
        isHidden: isHidden,
      );

  factory FeedbackChipsDto.fromJson(Map<String, dynamic> json) => _$FeedbackChipsDtoFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedbackChipsItemDto {
  final int id;
  final String value;

  FeedbackChipsItemDto({
    required this.id,
    required this.value,
  });

  FeedbackChipsItemEntity toDomain() => FeedbackChipsItemEntity(
        id: id,
        label: value,
      );

  factory FeedbackChipsItemDto.fromJson(Map<String, dynamic> json) => _$FeedbackChipsItemDtoFromJson(json);
}
