import 'package:mapness/features/stories/data/story_types.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_action.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_data.dart';
import 'package:mapness/features/stories/domain/story_data.dart';

extension NetworkStoryMapper on NetworkStory {
  StoryData toStory() {
    return StoryData(
      storyId: id,
      frames: frames.map((e) => e.toDomain(id)).toList(),
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
    );
  }
}

extension NetworkStoryPageActionMapper on NetworkStoryPageAction {
  StoryFrameAction? toDomain() {
    return switch (whichAction()) {
      NetworkStoryPageActionType.call => StoryFrameAction(
          title: title,
          type: FrameActionType.callPhone,
          action: call.phone,
        ),
      NetworkStoryPageActionType.externalUrl => StoryFrameAction(
          title: title,
          type: FrameActionType.openUrl,
          action: externalUrl.url,
        ),
      NetworkStoryPageActionType.deeplink => StoryFrameAction(
          title: title,
          type: FrameActionType.openDeepLink,
          action: deeplink.url,
        ),
      NetworkStoryPageActionType.openCard => StoryFrameAction(
          title: title,
          type: FrameActionType.openMap,
          action: openCard.id,
        ),
      NetworkStoryPageActionType.notSet => null,
    };
  }
}
