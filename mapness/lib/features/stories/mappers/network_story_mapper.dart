import 'package:flutter/material.dart';
import 'package:mapness/features/stories/data/story_types.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_action.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_data.dart';
import 'package:mapness/features/stories/domain/frame/story_text_style.dart';
import 'package:mapness/features/stories/domain/story_data.dart';
import 'package:mapness/features/stories/domain/thumbnail/story_thumbnail_data.dart';

extension NetworkStoryResponseMapper on NetworkStoriesResponse {
  List<StoryData> toDomain() => stories.map((e) => e.toDomain()).toList();
}

extension NetworkStoryMapper on NetworkStory {
  StoryData toDomain() => StoryData(
        storyId: id,
        frames: frames.map((e) => e.toDomain(id)).toList(),
        thumbnail: preview.toDomain(),
      );
}

extension NetworkStoryPreviewMapper on NetworkStoryPreview {
  StoryThumbnailData toDomain() => StoryThumbnailData(
        imageUrl: image.url,
        title: title,
      );
}

extension NetworkStoryFrameMapper on NetworkStoryFrame {
  StoryFrameData toDomain(String storyId) => StoryFrameData(
        isWatched: false,
        title: title,
        imageUrl: ({required isArabic}) => background.url,
        storyId: storyId,
        description: description,
        action: actionButton.toDomain(),
        duration: duration,
        descriptionStyle: style.description.toDomain(),
        titleStyle: style.title.toDomain(),
      );
}

extension NetworkStoryTextStyleMapper on NetworkStoryTextStyle {
  StoryTextStyle toDomain() => StoryTextStyle(
        color: color.toDomain(),
      );
}

extension ColorMapper on NetowrkColor {
  Color? toDomain() {
    final intValue = int.tryParse(hex, radix: 16);
    if (intValue != null) {
      return Color(0xFF000000 + intValue);
    }

    return null;
  }
}

extension NetworkStoryPageActionMapper on NetworkStoryPageAction {
  StoryFrameAction? toDomain() => VerbatimStoryFrameAction(
        title: title,
        // TODO(someone): support deeplinks in native platforms
        deeplinkUrl: link.url.replaceFirst('balady:/', ''),
        textStyle: style.textStyle.toDomain(),
        backgroundColor: style.backgroundColor.toDomain(),
      );
}
