import 'dart:async';

import 'package:mapness/features/stories/data/stories_repo.dart';
import 'package:mapness/features/stories/domain/story_overall_data.dart';
import 'package:mapness/features/stories/domain/thumbnail/story_thumbnail_data.dart';
import 'package:mapness/features/stories/mappers/network_story_mapper.dart';
import 'package:mapness/generated/protocol/protocol.pb.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_service.g.dart';

@Riverpod(dependencies: [StoriesRepo])
class StoryService extends _$StoryService {
  void markStoryReeded(final storyId, int frameIndex) {
    markStoryReeded(storyId, frameIndex);
    ref.invalidateSelf();
  }

  void refresh() {
    ref.invalidateSelf();
  }

  Future<void> cacheImages(void Function(String url) cacheImage) async {
    await state.whenOrNull(data: (data) async {
      for (var story in data.stories) {
        for (var frame
            in story.frames.where((element) => !element.isWatched).take(4)) {
          cacheImage(frame.imageUrl);
        }
      }
    });
  }

  @override
  Future<StoryOverallData> build() async {
    final StoriesResponse storiesNetwork =
        await ref.watch(storiesRepoProvider.future);
    final stories = storiesNetwork.stories.map((e) => e.toStory()).toList();
    print(stories.map((e) => e.storyId).toList());
    final thumnails = storiesNetwork.stories
        .map(
          (e) => StoryThumbnailData(
            storyId: e.id,
            imageUrl: e.preview.image.url,
            title: e.preview.title,
            isWatched: e.isViewed,
          ),
        )
        .toList();

    return StoryOverallData(
      stories: stories,
      thumbnails: thumnails,
    );
  }
}
