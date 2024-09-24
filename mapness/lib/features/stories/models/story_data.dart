import 'package:mapness/features/stories/models/story_frame_data.dart';
import 'package:mapness/features/stories/models/story_thumbnail_data.dart';

/// Represents a story data object.
class StoryData {
  /// Constructs a [StoryData] object.
  const StoryData({
    required this.storyId,
    required this.frames,
    this.thumbnail,
  });

  /// The list of frames in the story.
  final List<StoryFrameData> frames;

  /// The ID of the story.
  final String storyId;

  /// The thumbnail of the story.
  final StoryThumbnailData? thumbnail;

  /// Returns whether the story has been viewed.
  bool get isViewed => frames.last.isWatched;

  /// Creates a copy of this [StoryData] object with the specified attributes.
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
