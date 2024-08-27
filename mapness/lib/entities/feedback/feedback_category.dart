import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/feedback_icon.dart';

class FeedbackCategoryEntity {
  final String id;
  final String name;
  final List<FeedbackBaseEntity> fields;
  final FeedbackIcon icon;

  const FeedbackCategoryEntity({
    required this.id,
    required this.name,
    required this.fields,
    required this.icon,
  });
}
