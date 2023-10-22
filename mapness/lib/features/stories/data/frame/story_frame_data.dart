import 'package:mapness/features/stories/data/frame/story_frame_action.dart';

class StoryFrameData {
  final String title;
  final String imageUrl;
  final String? subtitle;
  final String? description;
  final bool isWatched;
  final StoryFrameAction? action;

  const StoryFrameData({
    required this.isWatched,
    required this.title,
    required this.imageUrl,
    this.subtitle,
    this.description,
    this.action,
  });
}
