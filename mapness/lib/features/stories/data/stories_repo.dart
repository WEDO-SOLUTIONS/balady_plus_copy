import 'package:dio/dio.dart';
import 'package:mapness/core/dgis_network.dart';
import 'package:mapness/generated/protocol/protocol.pb.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stories_repo.g.dart';

@Riverpod(dependencies: [DGisNetwork])
class StoriesRepo extends _$StoriesRepo {
  Dio get readDio => ref.read(dGisNetworkProvider);

  @override
  Future<StoriesResponse> build() async {
    final rawResponse = await ref.watch(dGisNetworkProvider).get('stories');
    final storiesResponse = StoriesResponse.fromBuffer(rawResponse.data);
    return storiesResponse;
  }

  Future<OkResponse> markStoryReeded(String storyId, int pages) async {
    final request = ViewedStoriesRequest(stories: [
      ViewedStoriesRequest_ViewedStory(
        id: storyId.toString(),
        frames: List.generate(
          pages,
          (index) =>
              ViewedStoriesRequest_ViewedStory_ViewedStoryFrame(index: index),
        ),
      ),
    ]);
    final rawResponse = await readDio.post(
      'stories/viewed',
      data: request.writeToBuffer(),
    );
    return OkResponse.fromBuffer(rawResponse.data);
  }
}
