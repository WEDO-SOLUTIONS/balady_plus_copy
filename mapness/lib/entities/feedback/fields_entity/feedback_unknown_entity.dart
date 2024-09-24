part of '../feedback_base_entity.dart';

class FeedbackUnknownEntity extends FeedbackBaseEntity<void> {
  const FeedbackUnknownEntity({
    required super.id,
    required super.isRequired,
    required super.isHidden,
  }) : super(value: null);

  @override
  FeedbackUnknownEntity updatedValue(void value) => FeedbackUnknownEntity(
        id: id,
        isRequired: isRequired,
        isHidden: isHidden,
      );

  @override
  dynamic valueToJson() => null;
}
