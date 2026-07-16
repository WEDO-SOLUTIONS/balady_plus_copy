import 'package:mapness/features/stories/models/story_data.dart';
import 'package:mapness/features/stories/models/story_frame_data.dart';
import 'package:mapness/features/stories/models/story_thumbnail_data.dart';

final List<StoryData> mockStories = [
  const StoryData(
    storyId: 'mbc-001',
    isWatched: false,
    thumbnail: StoryThumbnailData(
      // Use a network thumb for the circle avatar
      imageUrl: 'https://picsum.photos/seed/mbc1/200/200',
      title: 'MBC 1',
    ),
    frames: [
      StoryFrameData(
        storyId: 'mbc-001',
        // Local asset for full-screen frame
        imageUrl: 'assets/images/explore_mbc.webp',
        isAssetImage: true,
        duration: 8,
      ),
      StoryFrameData(
        storyId: 'mbc-001',
        imageUrl: 'https://picsum.photos/seed/mbc1f2/800/1400',
        duration: 7,
      ),
    ],
  ),
  const StoryData(
    storyId: 'mbc-002',
    isWatched: true,
    thumbnail: StoryThumbnailData(
      imageUrl: 'https://picsum.photos/seed/mbc2/200/200',
      title: 'MBC 2',
    ),
    // frames: const [
    //   StoryFrameData(
    //     storyId: 'mbc-002',
    //     imageUrl: 'https://picsum.photos/seed/mbc2f1/800/1400',
    //     duration: 6,
    //   ),
    // ],
    frames: [
      StoryFrameData(
        storyId: 'mbc-002',
        // Local asset for full-screen frame
        imageUrl: 'assets/images/explore_mbc.webp',
        isAssetImage: true,
        duration: 8,
      ),
      StoryFrameData(
        storyId: 'mbc-002',
        imageUrl: 'https://picsum.photos/seed/mbc1f2/800/1400',
        duration: 7,
      ),
    ],
  ),
];
