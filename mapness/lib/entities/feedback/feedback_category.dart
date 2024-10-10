import 'package:mapness/entities/feedback/feedback_base_entity.dart';

class FeedbackCategoryEntity {
  final String id;
  final String name;
  final List<FeedbackBaseEntity> fields;
  final String? iconUrl;

  const FeedbackCategoryEntity({
    required this.id,
    required this.name,
    required this.fields,
    required this.iconUrl,
  });

  @override
  String toString() => 'FeedbackCategoryEntity(id: $id, name: $name, fields: $fields, iconUrl: $iconUrl)';
}
