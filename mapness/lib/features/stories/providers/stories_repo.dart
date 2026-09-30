import 'dart:async';

import 'package:dgis_map/library.dart' show VisibleRect, VisibleRectEvent;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:geobase/geobase.dart' as gb;
import 'package:mapness/_generated/protocol/protocol.pb.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/landing/landing_visibility.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/camera_refetch_gate.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'stories_repo.g.dart';

/// Set by [StoriesRepo.pauseUpdate] while a story is open full-screen: a refetch would swap the stories under it.
///
/// Kept outside the notifier so that it survives the provider being rebuilt.
final _storiesUpdatePaused = ValueNotifier<bool>(false);

/// Stories are region-level content served by the backend for the map viewport (`stories?bound=<WKT>`).
///
/// Requests:
/// - the first one starts right away (stories are the landing's first visible content): for the current viewport when
///   the map has already reported one, otherwise without `bound`. In the latter case the first viewport the map
///   reports is requested once more, as the unbounded response is not known to cover the region the map opened at;
/// - afterwards the camera only causes a request when it moved meaningfully ([CameraRefetchGate]), never more often
///   than every few seconds, and not while the landing is covered by another route or a story is open;
/// - a newer request cancels the older one; a superseded response can never overwrite a newer one;
/// - a failed refetch is logged and the last good stories stay. Only the first request's failure surfaces (as an
///   `AsyncError`, which Riverpod retries), because there is nothing to show yet.
@riverpod
class StoriesRepo extends _$StoriesRepo {
  CancelToken? _cancelToken;

  void pauseUpdate() {
    _storiesUpdatePaused.value = true;
  }

  void resumeUpdate() {
    _storiesUpdatePaused.value = false;
  }

  @override
  Future<StoriesResponse> build() async {
    // Set when this build is disposed or superseded by a rebuild; every continuation below checks it.
    var stale = false;
    CameraRefetchGate? gate;
    StreamSubscription<VisibleRectEvent?>? subscription;
    var landingVisible = ref.read(landingVisibleProvider);

    void syncPause() {
      gate?.paused = !landingVisible || _storiesUpdatePaused.value;
    }

    ref.listen(landingVisibleProvider, (_, visible) {
      if (visible && !landingVisible) {
        // Whatever paused the updates (a story opened over the landing) is closed by now, even if it never called
        // resumeUpdate (e.g. it was dismissed with a system back gesture).
        _storiesUpdatePaused.value = false;
      }
      landingVisible = visible;
      syncPause();
    });
    _storiesUpdatePaused.addListener(syncPause);
    ref.onDispose(() {
      stale = true;
      _storiesUpdatePaused.removeListener(syncPause);
      gate?.dispose();
      unawaited(subscription?.cancel());
      _cancelActiveRequest('storiesRepoProvider disposed');
    });

    final dio = await ref.watch(dGisNetworkProvider.future);
    if (stale) {
      return StoriesResponse();
    }

    final rects = ref.read(dgisControllerProvider.notifier).visibleRectSubject;
    final initialRect = rects.valueOrNull?.visibleRect;
    final initial = await _fetch(dio, initialRect, _startRequest());
    if (stale) {
      return initial;
    }

    // Camera-driven updates start only once the first request is done, so they never race it. The subject replays
    // its latest viewport, which is checked against the one the first request was made for.
    final activeGate = CameraRefetchGate(
      refetch: (rect) => _refresh(dio, rect),
      paused: !landingVisible || _storiesUpdatePaused.value,
    )..markFetched(initialRect);
    gate = activeGate;
    subscription = rects.whereNotNull().listen((event) => activeGate.onCamera(event.visibleRect));

    return initial;
  }

  /// Requests the stories for [rect] and publishes them if they are still the newest and differ from what is shown.
  Future<bool> _refresh(Dio dio, VisibleRect rect) async {
    final cancelToken = _startRequest();
    try {
      final stories = await _fetch(dio, rect, cancelToken);
      if (_isCurrent(cancelToken) && stories != state.value) {
        state = AsyncValue.data(stories);
      }
      return true;
    } on Object catch (error, stackTrace) {
      if (cancelToken.isCancelled || (error is DioException && CancelToken.isCancel(error))) {
        return true;
      }
      logger.log('Stories request failed: $error\n$stackTrace', logLevel: MapnessLogLevel.error);
      return false;
    }
  }

  CancelToken _startRequest() {
    _cancelActiveRequest('Superseded by a newer stories request');
    return _cancelToken = CancelToken();
  }

  void _cancelActiveRequest(String reason) {
    final cancelToken = _cancelToken;
    _cancelToken = null;
    if (cancelToken != null && !cancelToken.isCancelled) {
      cancelToken.cancel(reason);
    }
  }

  bool _isCurrent(CancelToken cancelToken) =>
      ref.mounted && !cancelToken.isCancelled && identical(_cancelToken, cancelToken);

  Future<StoriesResponse> _fetch(Dio dio, VisibleRect? rect, CancelToken cancelToken) async {
    mixpanel?.timeEvent('StoriesRepo: _fetch');
    final polygon = rect != null ? CommonFunctions.getPolygonFromRect(rect) : null;
    final url = polygon != null ? 'stories?bound=${polygon.toText(format: gb.WKT.geometry)}' : 'stories';

    final rawResponse = await dio.get(url, options: defaultCacheOptions, cancelToken: cancelToken);
    final storiesResponse = StoriesResponse.fromBuffer(rawResponse.data as List<int>);
    unawaited(mixpanel?.track('StoriesRepo: _fetch'));
    return storiesResponse;
  }
}
