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

@immutable
class FeedbackSubChipsItemEntity {
  final String name;
  final String icon;

  const FeedbackSubChipsItemEntity({
    required this.name,
    required this.icon,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is FeedbackSubChipsItemEntity && other.name == name && other.icon == icon);

  @override
  int get hashCode => Object.hash(runtimeType, name, icon);
}

class FeedbackSubChipsEntity extends FeedbackBaseEntity {
  final String label;
  final String hint;
  final Map<FeedbackSubChipsItemEntity, List<FeedbackChipsItemEntity>> variants;

  FeedbackSubChipsEntity({
    required super.id,
    required super.isRequired,
    required super.isHidden,
    required this.label,
    required this.variants,
    required this.hint,
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
