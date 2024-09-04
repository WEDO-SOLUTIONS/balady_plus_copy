part of '../dto/feedback_base_dto.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FeedbackChipsDto extends FeedbackBaseDto {
  final String label;
  final List<String> variants;

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
        variants: variants
            // TODO: refactor if backend desire to use ids
            .map((e) => FeedbackChipsItemEntity(
                  id: e,
                  label: e,
                ))
            .toList(),
        value: UnmodifiableSetView<String>({}),
        isHidden: isHidden,
      );
}
