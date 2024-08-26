import 'package:mapness/entities/feedback/feedback_base_entity.dart';

class FeedbackCategoryEntity {
  final String name;
  final List<FeedbackBaseEntity> fields;

  const FeedbackCategoryEntity({
    required this.name,
    required this.fields,
  });
}
