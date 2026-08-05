import 'dart:async';
import 'dart:math';

import 'package:hive_ce/hive.dart';
import 'package:mapness/features/stories/data/mappers/network_story_mapper.dart';
import 'package:mapness/features/stories/models/story_data.dart';
import 'package:mapness/features/stories/providers/stories_repo.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_service.g.dart';

@riverpod
class StoryService extends _$StoryService {
  Box<dynamic>? _viewedStories;

  Future<void> markStoryAsRead(final String storyId, int frameIndex) async {
    await _viewedStories?.put(
      storyId,
      max(frameIndex, (_viewedStories?.get(storyId) as int?) ?? 0),
    );
    state.whenData(
      (value) => state = AsyncValue.data(syncronizeWatcheness(value)),
    );
  }

  void refresh() {
    ref.invalidateSelf();
  }

  List<StoryData> syncronizeWatcheness(List<StoryData> stories) {
    final watchStored = Map.of(_viewedStories?.toMap() ?? {}).cast<String, int>();

    final updatedStories = stories.map(
      (story) {
        final watchedFrames = watchStored[story.storyId];
        if (watchedFrames != null) {
          return story.copyWith(isWatched: true);
        }

        return story;
      },
    ).toList();

    return updatedStories;
  }

  void pauseUpdate() {
    ref.read(storiesRepoProvider.notifier).pauseUpdate();
  }

  void resumeUpdate() {
    ref.read(storiesRepoProvider.notifier).resumeUpdate();
  }

  @override
  Future<List<StoryData>> build() async {
    final storiesNetwork = await ref.watch(storiesRepoProvider.future);
    final networkStories = storiesNetwork.toDomain();

    _viewedStories = await ref.watch(hiveProvider('storiesBox').future);

    // TEMP SOLUTION: keep the exact order returned by the API.
    // We still run `syncronizeWatcheness` so the watched (seen) state is
    // preserved, but we intentionally do NOT sort so unwatched stories are no
    // longer floated to the front — the list mirrors the backend order 1:1.
    final stories = syncronizeWatcheness(networkStories);
    return stories;

    // OLD SOLUTION (kept intentionally, do not remove): floated watched
    // stories to the end and unwatched to the front, overriding API order.
    // final stories = syncronizeWatcheness(networkStories)..sort((a, b) => a.isWatched ? 1 : -1);
    // return stories;
  }
}
