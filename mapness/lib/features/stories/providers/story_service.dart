import 'dart:async';
import 'dart:math';

import 'package:hive/hive.dart';
import 'package:mapness/features/stories/mappers/network_story_mapper.dart';
import 'package:mapness/features/stories/models/story_data.dart';
import 'package:mapness/features/stories/providers/stories_repo.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_service.g.dart';

@riverpod
class StoryService extends _$StoryService {
  late Box<dynamic> _viewedStories;

  Future<void> markStoryAsRead(final String storyId, int frameIndex) async {
    await _viewedStories.put(
      storyId,
      max(frameIndex, (_viewedStories.get(storyId) as int?) ?? 0),
    );
    state.whenData(
      (value) => state = AsyncValue.data(syncronizeWatcheness(value)),
    );
  }

  void refresh() {
    ref.invalidateSelf();
  }

  List<StoryData> syncronizeWatcheness(List<StoryData> stories) {
    final map = _viewedStories.toMap();
    final watchStored = map.map((key, value) => MapEntry(key as String, value as int));

    final updatedStories = stories.map(
      (story) {
        final watchedFrames = watchStored[story.storyId] ?? -1;

        final updatedFrames = story.frames.indexed.map(
          (indexedFrame) {
            final (index, frame) = indexedFrame;
            if (index <= watchedFrames) {
              return frame.copyWith(isWatched: true);
            }
            return frame;
          },
        ).toList();

        return story.copyWith(frames: updatedFrames);
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

    final stories = syncronizeWatcheness(networkStories);

    return [
      ...stories.where((element) => !element.isViewed),
      ...stories.where((element) => element.isViewed),
    ].toList();
  }
}
