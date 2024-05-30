import 'dart:async';

import 'package:mapness/features/stories/domain/stories_map.dart';
import 'package:mapness/features/stories/domain/story_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_stories_service.g.dart';

@riverpod
class LocalStoriesService extends _$LocalStoriesService {
  @override
  Future<List<StoryData>> build(String file) async {
    final networkStories = StoriesMap.stories[file] ?? [];

    final stories = networkStories;

    return [
      ...stories.where((element) => element.isViewed),
      ...stories.where((element) => !element.isViewed),
    ];
  }
}
