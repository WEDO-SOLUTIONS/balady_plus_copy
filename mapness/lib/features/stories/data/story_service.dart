import 'dart:async';
import 'dart:math';

import 'package:hive/hive.dart';
import 'package:mapness/features/stories/data/stories_repo.dart';
import 'package:mapness/features/stories/domain/story_overall_data.dart';
import 'package:mapness/features/stories/domain/thumbnail/story_thumbnail_data.dart';
import 'package:mapness/features/stories/mappers/network_story_mapper.dart';
import 'package:mapness/generated/protocol/protocol.pb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_service.g.dart';

@Riverpod(dependencies: [StoriesRepo])
class StoryService extends _$StoryService {
  late Box<int>? _viewedStories;

  Future<void> markStoryReeded(final storyId, int frameIndex) async {
    await _viewedStories?.put(
      storyId,
      max(frameIndex, _viewedStories?.get(storyId) ?? 0),
    );

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
    final _ = ref.refresh(storiesRepoProvider);
  }

  @override
  Future<StoryOverallData> build() async {
    final StoriesResponse storiesNetwork =
        await ref.watch(storiesRepoProvider.future);
    final stories = storiesNetwork.stories.map((e) => e.toStory()).toList();
    final appDocDir = await getApplicationDocumentsDirectory();
    _viewedStories =
        await Hive.openBox<int>('storiesBox', path: appDocDir.path);

    final thumnails = storiesNetwork.stories
        .map(
          (e) => StoryThumbnailData(
            storyId: e.id,
            imageUrl: e.preview.image.url,
            title: e.preview.title,
            isWatched: (_viewedStories?.get(e.id) ?? -1) + 1 == e.frames.length,
          ),
        )
        .toList();

    return StoryOverallData(stories: [
      ...stories.where((element) => element.isViewed),
      ...stories.where((element) => !element.isViewed),
    ], thumbnails: [
      ...thumnails.where((element) => element.isWatched),
      ...thumnails.where((element) => !element.isWatched),
    ]);
  }
}
