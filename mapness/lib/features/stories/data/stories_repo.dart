import 'package:dio/dio.dart';
import 'package:mapness/features/common/providers/dgis_network.dart';
import 'package:mapness/generated/protocol/protocol.pb.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stories_repo.g.dart';

@Riverpod(dependencies: [DGisNetwork])
class StoriesRepo extends _$StoriesRepo {
  // Dio get readDio => ref.read(dGisNetworkProvider.future);
  Future<Dio> get readDio => ref.read(dGisNetworkProvider.future);

  @override
  Future<StoriesResponse> build() async {
    final dio = await readDio;
    final rawResponse = await dio.get('stories');
    final storiesResponse = StoriesResponse.fromBuffer(rawResponse.data);
    return storiesResponse;
  }

  Future<OkResponse> markStoryReeded(String storyId, int pages) async {
    final dio = await readDio;
    final request = ViewedStoriesRequest(stories: [
      ViewedStoriesRequest_ViewedStory(
        id: storyId.toString(),
        frames: List.generate(
          pages + 1,
          (index) =>
              ViewedStoriesRequest_ViewedStory_ViewedStoryFrame(index: index),
        ),
      ),
    ]);
    final rawResponse = await dio.post(
      'stories/viewed',
      data: request.writeToBuffer(),
    );
    final response = OkResponse.fromBuffer(rawResponse.data);
    return response;
  }

  Future<void> markStoiesReaded(
      List<(String storyId, int frameCount)> stories) async {
    final dio = await readDio;

    final request = ViewedStoriesRequest(
      stories: stories.map(
        (story) {
          final (storyId, frames) = story;
          return ViewedStoriesRequest_ViewedStory(
            id: storyId,
            frames: List.generate(
              frames + 1,
              (index) => ViewedStoriesRequest_ViewedStory_ViewedStoryFrame(
                index: index,
              ),
            ),
          );
        },
      ).toList(),
    );

    dio.post(
      'stories/viewed',
      data: request.writeToBuffer(),
    );
  }
}
