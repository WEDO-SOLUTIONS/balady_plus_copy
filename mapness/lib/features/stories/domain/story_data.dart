import 'package:mapness/features/stories/domain/frame/story_frame_data.dart';

class StoryData {
  final List<StoryFrameData> frames;
  final String storyId;

  const StoryData({
    required this.storyId,
    required this.frames,
  });
}
