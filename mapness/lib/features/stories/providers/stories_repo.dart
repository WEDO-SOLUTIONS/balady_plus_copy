import 'dart:async';

import 'package:dio/dio.dart';
import 'package:geobase/geobase.dart' as gb;
import 'package:mapness/_generated/protocol/protocol.pb.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'stories_repo.g.dart';

@riverpod
class StoriesRepo extends _$StoriesRepo {
  bool _isUpdatePaused = false;

  void pauseUpdate() {
    _isUpdatePaused = true;
  }

  void resumeUpdate() {
    _isUpdatePaused = false;
  }

  @override
  Future<StoriesResponse> build() async {
    final dio = await ref.watch(dGisNetworkProvider.future);

    final subscription = ref
        .read(dgisControllerProvider.notifier)
        .visibleRectSubject
        .whereNotNull()
        .debounceTime(const Duration(seconds: 1))
        .listen((event) async {
          if (_isUpdatePaused) {
            return;
          }
          final polygon = CommonFunctions.getPolygonFromRect(event.visibleRect);

          state = AsyncValue.data(await _fetch(dio, polygon));
        });

    ref.onDispose(subscription.cancel);

    return _fetch(dio);
  }

  Future<StoriesResponse> _fetch(Dio dio, [gb.Polygon? polygon]) async {
    mixpanel?.timeEvent('StoriesRepo: _fetch');
    final url = polygon != null ? 'stories?bound=${polygon.toText(format: gb.WKT.geometry)}' : 'stories';

    final rawResponse = await dio.get(url, options: defaultCacheOptions);
    final storiesResponse = StoriesResponse.fromBuffer(rawResponse.data as List<int>);
    detach(mixpanel?.track('StoriesRepo: _fetch'), tag: 'storiesRepo.track');
    return storiesResponse;
  }
}
