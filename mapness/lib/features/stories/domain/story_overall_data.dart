import 'package:mapness/features/stories/domain/story_data.dart';
import 'package:mapness/features/stories/domain/thumbnail/story_thumbnail_data.dart';

class StoryOverallData {
  final List<StoryData> stories;
  final List<StoryThumbnailData> thumbnails;

  StoryOverallData({
    required this.thumbnails,
    required this.stories,
  });

  StoryOverallData copyWith({
    List<StoryData>? stories,
    List<StoryThumbnailData>? thumbnails,
  }) {
    return StoryOverallData(
      stories: stories ?? this.stories,
      thumbnails: thumbnails ?? this.thumbnails,
    );
  }
}
