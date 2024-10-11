part of '../feedback_base_entity.dart';

class FeedbackTextEntity extends FeedbackBaseEntity {
  final String label;
  final int maxLength;
  final String hint;
  final bool setOnMap;
  final FeedbackTextType type;

  const FeedbackTextEntity({
    required this.type,
    required super.id,
    required super.isRequired,
    required this.label,
    required this.maxLength,
    required this.hint,
    required super.isHidden,
    this.setOnMap = false,
  });
}
