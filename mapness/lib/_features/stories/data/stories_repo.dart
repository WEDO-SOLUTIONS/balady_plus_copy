import 'package:dio/dio.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:geobase/geobase.dart' as gb;

part 'stories_repo.g.dart';

@riverpod
class StoriesRepo extends _$StoriesRepo {
  @override
  Future<StoriesResponse> build() async {
    final dio = await ref.watch(dGisNetworkProvider.future);

    final subscription = ref
        .read(dgisControllerProvider.notifier)
        .visibleRectSubject
        .listen((event) async {
      final polygon = CommonFunctions.getPolygonFromRect(event.visibleRect);
      state = AsyncValue.data(await _fetch(dio, polygon));
    });

    ref.onDispose(() {
      subscription.cancel();
    });

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
