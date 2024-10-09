part of '../feedback_base_entity.dart';

class FeedbackTextListEntity extends FeedbackBaseEntity {
  final FeedbackTextType type;

  final List<FeedbackTextEntity> fields;

  const FeedbackTextListEntity({
    required this.type,
    required this.fields,
    required super.id,
    required super.isHidden,
    required super.isRequired,
  });
}
