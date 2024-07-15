import 'package:mapness/features/stories_v2/models/story_frame_data.dart';
import 'package:mapness/widgets/stories/lib/models/story_thumbnail_data.dart';

class StoryData {
  const StoryData({
    required this.thumbnail,
    required this.storyId,
    required this.frames,
  });
  final List<StoryFrameData> frames;
  final String storyId;
  final StoryThumbnailData thumbnail;

  bool get isViewed => frames.last.isWatched;

  StoryData copyWith({
    List<StoryFrameData>? frames,
    String? storyId,
    StoryThumbnailData? thumbnail,
  }) =>
      StoryData(
        frames: frames ?? this.frames,
        storyId: storyId ?? this.storyId,
        thumbnail: thumbnail ?? this.thumbnail,
      );
}
