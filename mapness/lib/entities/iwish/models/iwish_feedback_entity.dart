import 'package:mapness/widgets/iwish/ui/iwish_feedback_mood.dart';

class IwishFeedbackEntity {
  final Set<String> tags;
  final String? comment;
  final IwishFeedbackMoodType? mood;

  IwishFeedbackEntity({
    required this.tags,
    required this.comment,
    required this.mood,
  });

  IwishFeedbackEntity copyWith({
    Set<String>? tags,
    String? comment,
    IwishFeedbackMoodType? mood,
  }) {
    return IwishFeedbackEntity(
      tags: tags ?? this.tags,
      comment: comment ?? this.comment,
      mood: mood ?? this.mood,
    );
  }
}
