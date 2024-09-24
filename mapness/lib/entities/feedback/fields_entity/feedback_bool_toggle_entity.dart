part of '../feedback_base_entity.dart';

class FeedbackBoolToggleEntity extends FeedbackBaseEntity<bool> {
  final String label;

  const FeedbackBoolToggleEntity({
    required super.id,
    required super.isRequired,
    required this.label,
    required super.isHidden,
    bool? value,
  }) : super(value: value);

  @override
  FeedbackBoolToggleEntity updatedValue(bool value) => FeedbackBoolToggleEntity(
        id: id,
        isRequired: isRequired,
        label: label,
        value: value,
        isHidden: isHidden,
      );

  @override
  dynamic valueToJson() => value;
}
