import 'package:flutter/material.dart';
import 'package:mapness/features/stories/models/story_data.dart';
import 'package:mapness/features/stories/models/story_frame_action.dart';
import 'package:mapness/features/stories/models/story_frame_data.dart';
import 'package:mapness/features/stories/models/story_frame_texts.dart';
import 'package:mapness/features/stories/models/story_frame_theme_data.dart';
import 'package:mapness/features/stories/models/story_thumbnail_data.dart';
import 'package:mapness/features/stories/models/story_typedefs.dart';
import 'package:mapness/features/stories/models/story_video_data.dart';

extension NetworkStoryResponseMapper on NetworkStoriesResponse {
  List<StoryData> toDomain() => stories.map((e) => e.toDomain()).toList();
}

extension NetworkStoryMapper on NetworkStory {
  StoryData toDomain() => StoryData(
        storyId: id,
        frames: frames.map((e) => e.toDomain(id)).toList(),
        videos: videos.map((e) => e.toDomain()).toList(),
        thumbnail: preview.toDomain(),
      );
}

extension NetworkStoryVideoMapper on NetworkStoryVideo {
  StoryVideoData toDomain() => StoryVideoData(
        url: url,
        resolution: resolution,
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
        imageUrl: background.url,
        storyId: storyId,
        action: actionButton.toDomain(),
        duration: duration,
        networkTheme: NetworkStoryThemeData(
          titleColor: style.title.color.toDomain(),
          descriptionColor: style.description.color.toDomain(),
          actionbackgroundColor: actionButton.style.backgroundColor.toDomain(),
          actionTextColor: actionButton.style.textStyle.color.toDomain(),
        ),
        networkTexts: StoryFrameTexts(
          title: title,
          description: description,
        ),
        isButtonEnabled: actionButton.isEnabled,
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
  StoryFrameAction? toDomain() {
    const navLinkPattern = 'com.balady:/';
    if (link.url.startsWith(navLinkPattern)) {
      return NavigationFrameAction(
        location: link.url.replaceFirst(navLinkPattern, ''),
        localeKey: '',
        title: title,
      );
    }
    if (link.url.startsWith('http')) {
      return NetworkLinkFrameAction(
        title: title,
        // TODO(someone): support deeplinks in native platforms
        url: link.url,
      );
    }
    return NextStoryAction(
      title: title,
    );
  }
}
