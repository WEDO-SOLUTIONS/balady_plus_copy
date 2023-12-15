import 'package:mapness/_generated/protocol/protocol.pb.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stories_repo.g.dart';

@riverpod
class StoriesRepo extends _$StoriesRepo {
  @override
  Future<StoriesResponse> build() async {
    final dio = await ref.read(dGisNetworkProvider.future);
    final rawResponse = await dio.get('stories');
    final storiesResponse = StoriesResponse.fromBuffer(rawResponse.data);
    print(rawResponse.data);
    return storiesResponse;
  }
}
