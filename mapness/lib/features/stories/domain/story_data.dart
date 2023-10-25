import 'package:mapness/features/stories/domain/frame/story_frame_data.dart';

class StoryData {
  final List<StoryFrameData> frames;
  final String storyId;
  final bool isViewed;

  const StoryData({
    required this.isViewed,
    required this.storyId,
    required this.frames,
  });
}
