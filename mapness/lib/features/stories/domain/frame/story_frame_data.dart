import 'package:mapness/features/stories/domain/frame/story_frame_action.dart';

class StoryFrameData {
  final String storyId;
  final String title;
  final String imageUrl;
  final String? subtitle;
  final String? description;
  final bool isWatched;
  final StoryFrameAction? action;
  final int duration;

  const StoryFrameData({
    required this.duration,
    required this.storyId,
    required this.isWatched,
    required this.title,
    required this.imageUrl,
    this.subtitle,
    this.description,
    this.action,
  });

  StoryFrameData copyWith({
    String? storyId,
    String? title,
    String? imageUrl,
    String? subtitle,
    String? description,
    bool? isWatched,
    StoryFrameAction? action,
    int? duration,
  }) {
    return StoryFrameData(
      storyId: storyId ?? this.storyId,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      isWatched: isWatched ?? this.isWatched,
      action: action ?? this.action,
      duration: duration ?? this.duration,
    );
  }
}
