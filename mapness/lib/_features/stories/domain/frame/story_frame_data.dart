import 'package:mapness/_features/stories/domain/frame/story_frame_action.dart';
import 'package:mapness/_features/stories/domain/frame/story_text_style.dart';

class StoryFrameData {
  final String storyId;
  final String title;
  final String imageUrl;
  final String? subtitle;
  final String? description;
  final StoryTextStyle? titleStyle;
  final StoryTextStyle? descriptionStyle;
  final bool isWatched;
  final StoryFrameAction? action;
  final int duration;

  const StoryFrameData({
    required this.duration,
    required this.storyId,
    required this.isWatched,
    required this.title,
    required this.imageUrl,
    this.titleStyle,
    this.descriptionStyle,
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
    StoryTextStyle? titleStyle,
    StoryTextStyle? descriptionStyle,
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
      titleStyle: titleStyle ?? this.titleStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      isWatched: isWatched ?? this.isWatched,
      action: action ?? this.action,
      duration: duration ?? this.duration,
    );
  }
}
