import 'package:dio/dio.dart';
import 'package:mapness/_features/common/providers/map_viewport_changes.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:geobase/geobase.dart' as gb;

part 'stories_repo.g.dart';

@riverpod
class StoriesRepo extends _$StoriesRepo {
  @override
  Future<StoriesResponse> build() async {
    final dio = await ref.watch(dGisNetworkProvider.future);

    ref.listen(
      mapViewportChangesProvider,
      (_, next) async {
        state = AsyncValue.data(await _fetch(dio, next));
        ref.invalidateSelf();
      },
    );

    return await _fetch(dio);
  }

  Future<StoriesResponse> _fetch(Dio dio, [gb.Polygon? polygon]) async {
    mixpanel?.timeEvent("StoriesRepo: _fetch");
    final url = polygon != null
        ? 'stories?bound=${polygon.toText(format: gb.WKT.geometry)}'
        : 'stories';

    final rawResponse = await dio.get(url, options: defaultCacheOptions);
    final storiesResponse = StoriesResponse.fromBuffer(rawResponse.data);
    mixpanel?.track("StoriesRepo: _fetch");
    return storiesResponse;
  }
}
