part of '../feedback_base_entity.dart';

class FeedbackWeekDaysEntity extends FeedbackBaseEntity<List<String>> {
  final String label;
  final List<String> variants;

  const FeedbackWeekDaysEntity({
    required super.id,
    required super.isRequired,
    required this.label,
    required this.variants,
    List<String>? value,
  }) : super(value: value);

  @override
  FeedbackWeekDaysEntity updatedValue(List<String> value) => FeedbackWeekDaysEntity(
        id: id,
        isRequired: isRequired,
        label: label,
        variants: variants,
        value: value,
      );
}
