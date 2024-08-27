part of '../feedback_base_entity.dart';

class FeedbackImageInputEntity extends FeedbackBaseEntity<List<XFile>> {
  final String label;
  final int maxSize;
  final List<String> acceptedFormats;

  const FeedbackImageInputEntity({
    required super.id,
    required super.isRequired,
    required this.label,
    required this.maxSize,
    required this.acceptedFormats,
    List<XFile>? value,
  }) : super(value: value);

  @override
  FeedbackImageInputEntity updateValue(List<XFile> value) =>
      FeedbackImageInputEntity(
        id: id,
        isRequired: isRequired,
        label: label,
        maxSize: maxSize,
        acceptedFormats: acceptedFormats,
        value: value,
      );
}
