import 'package:mapness/_features/stories/domain/frame/story_frame_data.dart';
import 'package:mapness/_features/stories/domain/thumbnail/story_thumbnail_data.dart';

class StoryData {

  const StoryData({
    required this.thumbnail,
    required this.storyId,
    required this.frames,
  });
  final List<StoryFrameData> frames;
  final String storyId;
  bool get isViewed => frames.last.isWatched;
  final StoryThumbnailData thumbnail;

  StoryData copyWith({
    List<StoryFrameData>? frames,
    String? storyId,
    StoryThumbnailData? thumbnail,
  }) {
    return StoryData(
      frames: frames ?? this.frames,
      storyId: storyId ?? this.storyId,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }
}
