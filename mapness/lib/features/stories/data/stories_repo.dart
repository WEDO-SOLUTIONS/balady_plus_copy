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
}
