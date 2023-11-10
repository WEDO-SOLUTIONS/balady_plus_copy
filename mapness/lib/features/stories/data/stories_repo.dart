import 'package:mapness/features/common/providers/dgis_network.dart';
import 'package:mapness/generated/protocol/protocol.pb.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stories_repo.g.dart';

@Riverpod(dependencies: [DGisNetwork])
class StoriesRepo extends _$StoriesRepo {
  @override
  Future<StoriesResponse> build() async {
    final dio = ref.read(dGisNetworkProvider);
    final rawResponse = await dio.get('stories');
    final storiesResponse = StoriesResponse.fromBuffer(rawResponse.data);
    return storiesResponse;
  }
}
