import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_datasource.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_dio.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_models.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'dynamic_poi_repository.g.dart';

/// Reasonable padding for the viewport: 50% of the visible rect on each
/// side. Means a single pan of one screen-width still hits cached data.
const double _bboxGap = 0.5;

/// `page_size` of `DynamicPoiDatasource.fetchMarkers` (its default). The backend response does not depend on zoom,
/// only on the bbox, so a padded bbox stays valid for any viewport inside it -- unless the response hit this size.
const int _pageSize = 500;

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

  /// Padded bbox of the last viewport-driven response that is currently shown in [state]; `null` while the shown data
  /// is not known to cover any viewport (initial no-bbox data, a response cut off at [_pageSize], a rebuild).
  /// A failed or cancelled request never touches it: [state] keeps the last good data, and so does this.
  DynamicPoiBbox? _loadedBbox;

  /// The data behind [_loadedBbox], so a late initial fetch does not overwrite it.
  List<DynamicPoi>? _loadedPois;

  @override
  Future<List<DynamicPoi>> build() async {
    // A rebuild (locale/env change) drops the data the previous bbox belonged to.
    _loadedBbox = null;
    _loadedPois = null;

    final dio = ref.watch(dynamicPoiDioProvider);
    final env = await ref.watch(dgisEnvTypeProvider.future);
    final language = ref.watch(appLanguageProvider);
    final locale = language == Language.arabic ? 'ar_SA' : 'en_SA';

    final datasource = DynamicPoiDatasource(dio: dio, env: env);
    final controller = ref.watch(dgisControllerProvider.notifier);
    final initialToken = CancelToken();

    ref.onDispose(() {
      _cancelInFlight('DynamicPoiRepository disposed');
      if (!initialToken.isCancelled) {
        initialToken.cancel('DynamicPoiRepository disposed');
      }
      _subscription?.cancel();
    });

    // Re-subscribe whenever locale/env changes (the outer `build` runs again).
    _subscription?.cancel();
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
      final pois = await datasource.fetchMarkers(locale: locale, cancelToken: initialToken);
      if (!ref.mounted) {
        return const [];
      }
      // A viewport-driven response may have landed while this one was in flight; it is more specific, and returning
      // this one would replace it in [state] while [_loadedBbox] still claims it is shown.
      return _loadedPois ?? pois;
    } on Object catch (error) {
      if (!initialToken.isCancelled) {
        logger.log('Dynamic POI initial request failed: $error', logLevel: MapnessLogLevel.error);
      }
      // Keep the layer alive with an empty set on a transient initial-fetch
      // failure; viewport-driven retries will recover.
      return _loadedPois ?? const [];
    }
  }

  Future<void> _refresh(DynamicPoiDatasource ds, String locale, VisibleRect visibleRect) async {
    final viewport = DynamicPoiBbox(
      northLat: visibleRect.northEastLat,
      southLat: visibleRect.southWestLat,
      westLon: visibleRect.southWestLon,
      eastLon: visibleRect.northEastLon,
    );

    // The padded bbox that is already shown covers this viewport (small pan, zoom in, slight zoom out): nothing to
    // fetch. A request still in flight was made for a viewport the camera has left, and the shown data is enough,
    // so it is dropped instead of replacing the shown data with a different bbox.
    final loaded = _loadedBbox;
    if (loaded != null && _covers(loaded, viewport)) {
      _cancelInFlight('covered by loaded bbox');
      return;
    }

    _cancelInFlight('superseded');
    final cancel = _cancelToken = CancelToken();
    final bbox = viewport.padded(_bboxGap);

    try {
      final pois = await ds.fetchMarkers(
        locale: locale,
        bbox: bbox,
        cancelToken: cancel,
      );
      if (!ref.mounted || cancel.isCancelled || !identical(_cancelToken, cancel)) {
        return;
      }
      // A full page may be cut off, so it says nothing about the rest of the bbox: zooming in still has to refetch.
      _loadedBbox = pois.length >= _pageSize ? null : bbox;
      _loadedPois = pois;
      state = AsyncData(pois);
    } on Object catch (error) {
      if (cancel.isCancelled || (error is DioException && CancelToken.isCancel(error))) {
        return;
      }
      // Keep prior data on transient failure to avoid a blank flash. `_loadedBbox` keeps describing that prior data,
      // so the next viewport outside it (or any viewport, if none was loaded) is requested again.
      logger.log('Dynamic POI request failed: $error', logLevel: MapnessLogLevel.error);
    } finally {
      if (identical(_cancelToken, cancel)) {
        _cancelToken = null;
      }
    }
  }

  void _cancelInFlight(String reason) {
    final token = _cancelToken;
    _cancelToken = null;
    if (token != null && !token.isCancelled) {
      token.cancel(reason);
    }
  }

  /// Whether [inner] lies fully inside [outer]. A rect wrapping the antimeridian is never considered covered.
  static bool _covers(DynamicPoiBbox outer, DynamicPoiBbox inner) =>
      inner.westLon <= inner.eastLon &&
      outer.southLat <= inner.southLat &&
      inner.northLat <= outer.northLat &&
      outer.westLon <= inner.westLon &&
      inner.eastLon <= outer.eastLon;

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
