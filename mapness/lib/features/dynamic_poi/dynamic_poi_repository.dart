import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_datasource.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_dio.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_models.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'dynamic_poi_repository.g.dart';

/// Reasonable padding for the viewport: 50% of the visible rect on each
/// side. Means a single pan of one screen-width still hits cached data.
const double _bboxGap = 0.5;

/// Extra debounce on top of the dgis controller's own 1s, used to coalesce
/// rapid pinch/pan transitions.
const Duration _viewportDebounce = Duration(milliseconds: 400);

/// Don't bother re-fetching when the camera is zoomed out beyond any plausible
/// dynamic-POI display. The actual visibility filter is applied later from the
/// remote-config-driven `DynamicPoiVisibility` table; this is just a coarse
/// early-exit so we don't hammer the backend at world zoom.
const int _minFetchZoom = 8;

@Riverpod(keepAlive: true)
class DynamicPoiRepository extends _$DynamicPoiRepository {
  CancelToken? _cancelToken;
  StreamSubscription? _subscription;

  @override
  Future<List<DynamicPoi>> build() async {
    final dio = ref.watch(dynamicPoiDioProvider);
    final env = await ref.watch(dgisEnvTypeProvider.future);
    final language = ref.watch(appLanguageProvider);
    final locale = language == Language.arabic ? 'ar_SA' : 'en_SA';

    final datasource = DynamicPoiDatasource(dio: dio, env: env);
    final controller = ref.watch(dgisControllerProvider.notifier);

    ref.onDispose(() {
      final token = _cancelToken;
      if (token != null && !token.isCancelled) {
        token.cancel('DynamicPoiRepository disposed');
      }
      detach(_subscription?.cancel(), tag: 'dynamicPoiRepository.cancelSubscription');
    });

    // Re-subscribe whenever locale/env changes (the outer `build` runs again).
    detach(_subscription?.cancel(), tag: 'dynamicPoiRepository.cancelOnResubscribe');
    _subscription = controller.visibleRectSubject
        .whereNotNull()
        .where((event) => event.visibleRect.zoom >= _minFetchZoom)
        .debounceTime(_viewportDebounce)
        .distinct(_sameViewport)
        .listen((event) async {
          await _refresh(datasource, locale, event.visibleRect);
        });

    // Initial fetch: the dgis SDK doesn't always emit a visibleRectEvent at
    // app launch (the camera may not move), so we kick a no-bbox fetch right
    // away to populate the layer. The viewport-driven fetches above then
    // refine with a real bbox once the user pans/zooms.
    try {
      final pois = await datasource.fetchMarkers(locale: locale);
      if (!ref.mounted) {
        return const [];
      }
      return pois;
    } on Object {
      // Keep the layer alive with an empty set on a transient initial-fetch
      // failure; viewport-driven retries will recover.
      return const [];
    }
  }

  Future<void> _refresh(DynamicPoiDatasource ds, String locale, VisibleRect visibleRect) async {
    final oldToken = _cancelToken;
    if (oldToken != null && !oldToken.isCancelled) {
      oldToken.cancel('superseded');
    }
    final cancel = _cancelToken = CancelToken();

    final bbox = DynamicPoiBbox(
      northLat: visibleRect.northEastLat,
      southLat: visibleRect.southWestLat,
      westLon: visibleRect.southWestLon,
      eastLon: visibleRect.northEastLon,
    ).padded(_bboxGap);

    try {
      final pois = await ds.fetchMarkers(
        locale: locale,
        bbox: bbox,
        cancelToken: cancel,
      );
      if (!ref.mounted || cancel.isCancelled || !identical(_cancelToken, cancel)) {
        return;
      }
      state = AsyncData(pois);
    } on Object {
      if (cancel.isCancelled) {
        return;
      }
      // Keep prior data on transient failure to avoid a blank flash.
    }
  }

  static bool _sameViewport(VisibleRectEvent a, VisibleRectEvent b) {
    // Coarse comparison — only re-fetch when bbox changed meaningfully.
    // Threshold ~0.001° lat/lon ≈ ~110m.
    const epsilon = 0.001;
    final aRect = a.visibleRect;
    final bRect = b.visibleRect;
    return (aRect.northEastLat - bRect.northEastLat).abs() < epsilon &&
        (aRect.northEastLon - bRect.northEastLon).abs() < epsilon &&
        (aRect.southWestLat - bRect.southWestLat).abs() < epsilon &&
        (aRect.southWestLon - bRect.southWestLon).abs() < epsilon;
  }
}
