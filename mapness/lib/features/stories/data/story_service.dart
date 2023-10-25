import 'dart:async';
import 'dart:math';

import 'package:mapness/features/stories/data/stories_repo.dart';
import 'package:mapness/features/stories/domain/story_overall_data.dart';
import 'package:mapness/features/stories/domain/thumbnail/story_thumbnail_data.dart';
import 'package:mapness/features/stories/mappers/network_story_mapper.dart';
import 'package:mapness/generated/protocol/protocol.pb.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_service.g.dart';

@Riverpod(dependencies: [StoriesRepo])
class StoryService extends _$StoryService {
  /// collect viewed stories to send single request to server. Contain storyId key and last viewed frame index
  final _viewedStories = <String, int>{};

  Future<void> markStoryReeded(final storyId, int frameIndex) async {
    _viewedStories[storyId] = max(frameIndex, _viewedStories[storyId] ?? 0);

    state.whenData((stateData) {
      final updatedStories = stateData.stories.map(
        (story) {
          if (story.storyId != storyId) {
            return story;
          }

          final updatedFrames = story.frames.indexed.map(
            (indexedFrame) {
              final (index, frame) = indexedFrame;
              if (index <= frameIndex) {
                return frame.copyWith(isWatched: true);
              }
              return frame;
            },
          ).toList();

          return story.copyWith(
            frames: updatedFrames,
            isViewed: updatedFrames.last.isWatched,
          );
        },
      ).toList();

      final updatedThumbnails = stateData.thumbnails.map(
        (thumbnail) {
          if (thumbnail.storyId != storyId) {
            return thumbnail;
          }

          return thumbnail.copyWith(
            isWatched: updatedStories
                .firstWhere((element) => element.storyId == storyId)
                .isViewed,
          );
        },
      ).toList();

      state = AsyncValue.data(
        stateData.copyWith(
          stories: updatedStories,
          thumbnails: updatedThumbnails,
        ),
      );
    });
  }

  void refresh() {
    ref.invalidateSelf();
  }

  /// flush viewed stories to server
  Future<void> sendViewedStories() async {
    if (_viewedStories.isEmpty) {
      return;
    }

    return ref.read(storiesRepoProvider.notifier).markStoiesReaded(
          _viewedStories.entries.map((e) => (e.key, e.value)).toList(),
        );
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

    return StoryOverallData(stories: [
      ...stories.where((element) => !element.isViewed),
      ...stories.where((element) => element.isViewed),
    ], thumbnails: [
      ...thumnails.where((element) => !element.isWatched),
      ...thumnails.where((element) => element.isWatched),
    ]);
  }
}
