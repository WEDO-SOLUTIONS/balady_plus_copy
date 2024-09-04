part of '../feedback_base_entity.dart';

class FeedbackChipsItemEntity {
  final FeedbackIcon? icon;
  final String label;
  final String id;

  const FeedbackChipsItemEntity({
    required this.id,
    required this.label,
    this.icon,
  });
}

class FeedbackChipsEntity extends FeedbackBaseEntity<UnmodifiableSetView<String>> {
  final String label;
  final List<FeedbackChipsItemEntity> variants;

  const FeedbackChipsEntity({
    required super.id,
    required super.isRequired,
    required this.label,
    required this.variants,
    required super.value,
    required super.isHidden,
  });

  @override
  FeedbackChipsEntity updatedValue(Set<String> value) => FeedbackChipsEntity(
        id: id,
        isRequired: isRequired,
        label: label,
        variants: variants,
        value: UnmodifiableSetView<String>(value),
        isHidden: isHidden,
      );
}
