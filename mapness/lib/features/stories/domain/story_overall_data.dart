import 'package:mapness/features/stories/domain/story_data.dart';
import 'package:mapness/features/stories/domain/thumbnail/story_thumbnail_data.dart';

class StoryOverallData {
  final int frameDuration;
  final List<StoryData> stories;
  final List<StoryThumbnailData> thumbnails;

  StoryOverallData({
    required this.thumbnails,
    required this.frameDuration,
    required this.stories,
  });
}
