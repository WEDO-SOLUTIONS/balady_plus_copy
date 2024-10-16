part of '../feedback_base_entity.dart';

class FeedbackChipsItemEntity {
  final String? iconUrl;
  final String label;
  final int id;

  const FeedbackChipsItemEntity({
    required this.id,
    required this.label,
    this.iconUrl,
  });
}

class FeedbackChipsEntity extends FeedbackBaseEntity {
  final String label;
  final List<FeedbackChipsItemEntity> variants;

  const FeedbackChipsEntity({
    required super.id,
    required super.isRequired,
    required this.label,
    required this.variants,
    required super.isHidden,
  });
}
