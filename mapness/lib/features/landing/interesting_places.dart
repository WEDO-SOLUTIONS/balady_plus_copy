import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:geobase/geobase.dart' as gb;
import 'package:mapness/_generated/protocol/protocol.pb.dart';
import 'package:mapness/features/landing/landing_visibility.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/constants/info_mock.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/app_settled.dart';
import 'package:mapness/shared/utils/camera_refetch_gate.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'interesting_places.g.dart';

/// Interesting places for the landing carousel, served by the backend for the map viewport
/// (`interesting-places?bound=<WKT>`).
///
/// The carousel is secondary content, so the first request waits until the map has reported its viewport or the app
/// has settled (whichever comes first): one bounded request instead of an unbounded one followed by a bounded one.
/// Afterwards the camera only causes a request when it moved meaningfully ([CameraRefetchGate]), never more often than
/// every few seconds, and not while the landing is covered by another route. A newer request cancels the older one; a
/// failed request keeps the last good places.
@riverpod
class InterestingPlaces extends _$InterestingPlaces {
  CancelToken? _cancelToken;

  @override
  Future<List<InterestingPlace>> build() async {
    // Set when this build is disposed or superseded by a rebuild; every continuation below checks it.
    var stale = false;
    CameraRefetchGate? gate;
    StreamSubscription<VisibleRectEvent?>? subscription;
    var landingVisible = ref.read(landingVisibleProvider);

    ref
      ..listen(landingVisibleProvider, (_, visible) {
        landingVisible = visible;
        gate?.paused = !visible;
      })
      ..onDispose(() {
        stale = true;
        gate?.dispose();
        unawaited(subscription?.cancel());
        _cancelActiveRequest('interestingPlacesProvider disposed');
      });

    final dio = await ref.watch(dGisNetworkProvider.future);
    if (stale) {
      return const [];
    }

    final rects = ref.read(dgisControllerProvider.notifier).visibleRectSubject;
    final initialRect = await _awaitInitialRect(rects);
    if (stale) {
      return const [];
    }
    final loaded = await _fetch(dio, initialRect, _startRequest());
    if (stale) {
      return const [];
    }

    // Camera-driven updates start only once the first request is done, so they never race it. The subject replays
    // its latest viewport, which is checked against the one the first request was made for.
    final activeGate = CameraRefetchGate(refetch: (rect) => _refresh(dio, rect), paused: !landingVisible);
    if (loaded != null) {
      activeGate.markFetched(initialRect);
    }
    gate = activeGate;
    subscription = rects.whereNotNull().listen((event) => activeGate.onCamera(event.visibleRect));

    // A failed first request keeps what was shown before a rebuild (if anything) rather than blanking the carousel.
    return loaded ?? state.value ?? const [];
  }

  /// The viewport the first request is made for: the current one, else the first one the map reports, else (the app
  /// settled and the map still has not moved) `null`, meaning no viewport.
  Future<VisibleRect?> _awaitInitialRect(ValueStream<VisibleRectEvent?> rects) async {
    final known = rects.valueOrNull?.visibleRect;
    if (known != null) {
      return known;
    }

    final completer = Completer<VisibleRect?>();
    final subscription = rects.whereNotNull().listen(
      (event) {
        if (!completer.isCompleted) {
          completer.complete(event.visibleRect);
        }
      },
      onDone: () {
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
    );
    unawaited(
      whenAppSettled().then((_) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      }),
    );
    try {
      return await completer.future;
    } finally {
      unawaited(subscription.cancel());
    }
  }

  /// Requests the places for [rect] and publishes them if they are still the newest and differ from what is shown.
  Future<bool> _refresh(Dio dio, VisibleRect rect) async {
    final cancelToken = _startRequest();
    final places = await _fetch(dio, rect, cancelToken);
    if (!_isCurrent(cancelToken)) {
      return true;
    }
    if (places == null) {
      return false;
    }
    if (!listEquals(places, state.value)) {
      state = AsyncValue.data(places);
    }
    return true;
  }

  CancelToken _startRequest() {
    _cancelActiveRequest('Superseded by a newer interesting places request');
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

  /// Never throws: `null` means the request failed or was cancelled.
  Future<List<InterestingPlace>?> _fetch(Dio dio, VisibleRect? rect, CancelToken cancelToken) async {
    final polygon = rect != null ? CommonFunctions.getPolygonFromRect(rect) : null;
    final wkt = polygon != null ? polygon.toText(format: gb.WKT.geometry) : '';

    try {
      final response = await dio.get(
        wkt.isNotEmpty ? '/interesting-places?bound=$wkt' : '/interesting-places',
        options: defaultCacheOptions,
        cancelToken: cancelToken,
      );
      return InterestingPlacesResponse.fromBuffer(response.data as List<int>).interestingPlaces;
    } on Object catch (error, stackTrace) {
      if (!cancelToken.isCancelled && !(error is DioException && CancelToken.isCancel(error))) {
        logger.log('Interesting places request failed: $error\n$stackTrace', logLevel: MapnessLogLevel.error);
      }
      return null;
    }
  }
}

// TODO: remove stubs
extension InterestingPlaceX on InterestingPlace {
  String titleOrFallback({required AppLocalizations locale}) {
    final intId = int.tryParse(entity.id);

    if (intId != null) {
      final mock = nameMock(
        intId,
        switch (locale.localeName) {
          'ar' => Language.arabic,
          _ => Language.english,
        },
      );
      if (mock != null) {
        return mock;
      }
    }
    return switch (entity.id) {
      '70000001079215988' => locale.poi_boulevard_riyadh_city,
      '70030076256609771' => locale.poi_kingdom_center,
      '70030076201501940' => locale.poi_faisaliya_tower,
      '70000001079216136' => locale.poi_masmak_fortress,
      '70030076419526924' => locale.poi_masmak_fortress,
      _ => preview.title,
    };
  }
}
