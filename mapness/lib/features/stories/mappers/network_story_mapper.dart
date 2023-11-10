import 'package:flutter/material.dart';
import 'package:mapness/features/stories/data/story_types.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_action.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_data.dart';
import 'package:mapness/features/stories/domain/frame/story_text_style.dart';
import 'package:mapness/features/stories/domain/story_data.dart';
import 'package:mapness/features/stories/domain/thumbnail/story_thumbnail_data.dart';

extension NetworkStoryResponseMapper on NetworkStoriesResponse {
  List<StoryData> toDomain() {
    return stories.map((e) => e.toDomain()).toList();
  }
}

extension NetworkStoryMapper on NetworkStory {
  StoryData toDomain() {
    return StoryData(
      storyId: id,
      frames: frames.map((e) => e.toDomain(id)).toList(),
      thumbnail: preview.toDomain(),
    );
  }
}

extension NetworkStoryPreviewMapper on NetworkStoryPreview {
  StoryThumbnailData toDomain() {
    return StoryThumbnailData(
      imageUrl: image.url,
      title: title,
    );
  }
}

extension NetworkStoryFrameMapper on NetworkStoryFrame {
  StoryFrameData toDomain(String storyId) {
    return StoryFrameData(
      isWatched: false,
      title: title,
      imageUrl: background.url,
      storyId: storyId,
      subtitle: null,
      description: description,
      action: actionButton.toDomain(),
      duration: duration,
      descriptionStyle: style.description.toDomain(),
      titleStyle: style.title.toDomain(),
    );
  }
}

extension NetworkStoryTextStyleMapper on NetworkStoryTextStyle {
  StoryTextStyle toDomain() {
    return StoryTextStyle(
      color: color.toDomain(),
    );
  }
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
  StoryFrameAction? toDomain() {
    return switch (whichAction()) {
      NetworkStoryPageActionType.call => StoryFrameAction(
          title: title,
          type: FrameActionType.callPhone,
          action: call.phone,
          textStyle: style.textStyle.toDomain(),
          backgroundColor: style.backgroundColor.toDomain(),
        ),
      NetworkStoryPageActionType.externalUrl => StoryFrameAction(
          title: title,
          type: FrameActionType.openUrl,
          action: externalUrl.url,
          textStyle: style.textStyle.toDomain(),
          backgroundColor: style.backgroundColor.toDomain(),
        ),
      NetworkStoryPageActionType.deeplink => StoryFrameAction(
          title: title,
          type: FrameActionType.openDeepLink,
          action: deeplink.url,
          textStyle: style.textStyle.toDomain(),
          backgroundColor: style.backgroundColor.toDomain(),
        ),
      NetworkStoryPageActionType.openCard => StoryFrameAction(
          title: title,
          type: FrameActionType.openMap,
          action: openCard.id,
          textStyle: style.textStyle.toDomain(),
          backgroundColor: style.backgroundColor.toDomain(),
        ),
      NetworkStoryPageActionType.notSet => null,
    };
  }
}
