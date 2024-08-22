part of 'feedback_base_entity.dart';

class FeedbackImageInputEntity extends FeedbackBaseEntity {
  final String label;
  final int maxSize;
  final List<String> acceptedFormats;

  FeedbackImageInputEntity({
    required super.id,
    required super.isRequired,
    required this.label,
    required this.maxSize,
    required this.acceptedFormats,
  });
}
