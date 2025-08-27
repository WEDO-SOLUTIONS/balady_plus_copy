import 'package:mapness/features/stories/models/story_frame_data.dart';
import 'package:mapness/features/stories/models/story_thumbnail_data.dart';
import 'package:mapness/features/stories/models/story_video_data.dart';

/// Represents a story data object.
class StoryData {
  /// Constructs a [StoryData] object.
  const StoryData({
    required this.storyId,
    this.frames = const [],
    this.isWatched = false,
    this.videos = const [],
    this.thumbnail,
  });

  /// The list of frames in the story.
  final List<StoryFrameData> frames;
  final List<StoryVideoData> videos;

  /// The ID of the story.
  final String storyId;

  /// The thumbnail of the story.
  final StoryThumbnailData? thumbnail;

  /// Indicates whether the frame has been watched by the user.
  final bool isWatched;

  /// Creates a copy of this [StoryData] object with the specified attributes.
  StoryData copyWith({
    List<StoryFrameData>? frames,
    String? storyId,
    StoryThumbnailData? thumbnail,
    bool? isWatched,
    List<StoryVideoData>? videos,
  }) =>
      StoryData(
        frames: frames ?? this.frames,
        storyId: storyId ?? this.storyId,
        thumbnail: thumbnail ?? this.thumbnail,
        isWatched: isWatched ?? this.isWatched,
        videos: videos ?? this.videos,
      );
}
