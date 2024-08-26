part of '../feedback_base_entity.dart';

class FeedbackBoolToggleEntity extends FeedbackBaseEntity {
  final String label;

  const FeedbackBoolToggleEntity({
    required super.id,
    required super.isRequired,
    required this.label,
  });
}
