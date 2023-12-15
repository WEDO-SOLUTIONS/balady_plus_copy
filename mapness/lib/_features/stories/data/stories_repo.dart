import 'package:mapness/_generated/protocol/protocol.pb.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stories_repo.g.dart';

@riverpod
class StoriesRepo extends _$StoriesRepo {
  @override
  Future<StoriesResponse> build() async {
    final env = await ref.read(dgisEnvironmentProvider.future);
    final url = env.url;
    final dio = ref.read(dGisNetworkProvider(url));
    final rawResponse = await dio.get('stories');
    final storiesResponse = StoriesResponse.fromBuffer(rawResponse.data);
    print(rawResponse.data);
    return storiesResponse;
  }
}
