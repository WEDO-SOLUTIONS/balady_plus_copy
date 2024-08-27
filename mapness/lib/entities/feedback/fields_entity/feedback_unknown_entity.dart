part of '../feedback_base_entity.dart';

class FeedbackUnknownEntity extends FeedbackBaseEntity<void> {
  const FeedbackUnknownEntity({
    required super.id,
    required super.isRequired,
  }) : super(value: null);

  @override
  FeedbackUnknownEntity updatedValue(void value) => this;
}
