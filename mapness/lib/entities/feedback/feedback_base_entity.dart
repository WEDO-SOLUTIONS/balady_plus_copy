part 'fields_entity/feedback_bool_toggle_entity.dart';
part 'fields_entity/feedback_text_entity.dart';
part 'fields_entity/feedback_image_input_entity.dart';
part 'fields_entity/feedback_unknown_entity.dart';

sealed class FeedbackBaseEntity {
  final String id;
  final bool isRequired;

  const FeedbackBaseEntity({
    required this.id,
    required this.isRequired,
  });
}
