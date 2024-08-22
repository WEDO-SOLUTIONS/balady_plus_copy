part 'feedback_bool_toggle_entity.dart';
part 'feedback_text_entity.dart';
part 'feedback_image_input_entity.dart';

sealed class FeedbackBaseEntity {
  final String id;
  final bool isRequired;

  FeedbackBaseEntity({
    required this.id,
    required this.isRequired,
  });
}
