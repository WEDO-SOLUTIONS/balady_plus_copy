part of '../dto/feedback_base_dto.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedbackChipsDto extends FeedbackBaseDto {
  final String label;
  final List<FeedbackChipsItemDto> variants;
  final String? hint;

  FeedbackChipsDto({
    required super.id,
    required super.type,
    required super.isRequired,
    required this.label,
    required this.variants,
    this.hint,
    super.isHidden = false,
    super.setOnMap = false,
  });

  @override
  FeedbackBaseEntity toDomain() {
    final isSubChipsField =
        variants.every((element) => element.icon != null && element.category != null) && hint != null;
    final map = <FeedbackSubChipsItemEntity, List<FeedbackChipsItemEntity>>{};
    if (isSubChipsField) {
      for (final variant in variants) {
        final key = FeedbackSubChipsItemEntity(
          name: variant.category ?? '',
          icon: variant.icon ?? '',
        );

        map.update(
          key,
          (value) => value..add(variant.toDomain()),
          ifAbsent: () => [variant.toDomain()],
        );
      }

      return FeedbackSubChipsEntity(
        id: id,
        isRequired: isRequired,
        isHidden: isHidden,
        label: label,
        hint: hint ?? '',
        variants: Map.unmodifiable(map),
      );
    }

    return FeedbackChipsEntity(
      id: id,
      isRequired: isRequired,
      label: label,
      variants: variants.map((e) => e.toDomain()).toList(),
      isHidden: isHidden,
    );
  }

  factory FeedbackChipsDto.fromJson(Map<String, dynamic> json) => _$FeedbackChipsDtoFromJson(json);
}
