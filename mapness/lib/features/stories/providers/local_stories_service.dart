import 'dart:async';

import 'package:mapness/features/stories/models/stories_type_data.dart';
import 'package:mapness/features/stories/models/story_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_stories_service.g.dart';

@riverpod
class LocalStoriesService extends _$LocalStoriesService {
  @override
  Future<List<StoryData>> build(String file) async {
    final networkStories = StoryTypedData.fromFile(file).stories;

    final stories = networkStories;

    return [
      ...stories.where((element) => element.isWatched),
      ...stories.where((element) => !element.isWatched),
    ];
  }
}
