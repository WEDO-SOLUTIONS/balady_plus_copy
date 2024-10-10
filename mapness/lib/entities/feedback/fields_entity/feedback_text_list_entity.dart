part of '../feedback_base_entity.dart';

class FeedbackTextListEntity extends FeedbackBaseEntity {
  final FeedbackTextType type;
  final String label;
  final int maxLength;
  final String hint;
  final List<String> values;
  final List<String> oldValues;

  const FeedbackTextListEntity({
    required this.type,
    required this.values,
    required this.oldValues,
    required this.label,
    required this.maxLength,
    required this.hint,
    required super.id,
    required super.isHidden,
    required super.isRequired,
  });
}
