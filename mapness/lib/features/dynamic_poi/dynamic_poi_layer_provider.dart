import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_icon_resolver.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_models.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_repository.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_visibility.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_visibility_provider.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/shared/extensions/string_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dynamic_poi_layer_provider.g.dart';

const int _polygonFillArgb = 0x331B5E5C; // teal, ~20% alpha
const int _polygonStrokeArgb = 0xFF0AB0A4; // teal solid

@Riverpod(keepAlive: true)
class DynamicPoiLayer extends _$DynamicPoiLayer {
  late final MapObjectManagerSettings _settings = MapObjectManagerSettings.dynamicPoi();

  /// Last poi list and visibility config used to (re)build markers — kept so
  /// camera-zoom updates can re-filter without re-fetching.
  List<DynamicPoi> _lastPois = const [];
  DynamicPoiVisibility _lastVisibility = DynamicPoiVisibility.fallback;

  /// IDs currently present on the map for this layer. Used by the diff-based
  /// rebuild path so viewport refreshes (and zoom transitions) only add new
  /// objects and remove objects that left — items in both old and new sets
  /// stay onscreen continuously, eliminating the empty-state gap that the
  /// iter4 `removeAll → addAll` path produced.
  final Set<String> _liveMarkerIds = <String>{};
  final Set<String> _livePolygonIds = <String>{};

  /// Cache of constructed `Marker` / `Polygon` objects keyed by the same id
  /// the SDK uses. Built lazily on first sight of a poi and reused across
  /// rebuilds — visibility transitions don't re-allocate marker/polygon
  /// objects or rebuild closures. Cleared whenever `_lastPois` is replaced
  /// (the `build()` reset path) so stale entries don't leak.
  final Map<String, Marker> _markerCache = <String, Marker>{};
  final Map<String, List<Polygon>> _polygonCache = <String, List<Polygon>>{};

  /// Serialization for `_rebuildAtZoom` so concurrent zoom ticks don't race
  /// on the live-ID sets. Trailing-debounce semantics: only one rebuild runs
  /// at a time; ticks that arrive while a rebuild is in flight overwrite a
  /// single pending slot, and the latest pending zoom is drained when the
  /// active rebuild finishes.
  Future<void>? _activeRebuild;
  double? _pendingZoom;
  bool? _pendingIsArabic;

  @override
  Future<void> build() async {
    // ignore: avoid_print
    print('[DynamicPoiDebug] layer build() entered');

    final managerProvider = mapObjectManagerProvider(
      named: _settings.name,
      layerId: _settings.layerId,
    );
    final manager = ref.watch(managerProvider.notifier);
    await ref.watch(managerProvider.future);

    final pois = await ref.watch(dynamicPoiRepositoryProvider.future);
    final visibility = await ref.watch(dynamicPoiVisibilityConfigProvider.future);
    final isArabic = ref.watch(appLanguageProvider) == Language.arabic;

    // ignore: avoid_print
    print('[DynamicPoiDebug] layer rebuilding pois=${pois.length} visibility=$visibility');

    // New data set / config: invalidate the marker+polygon caches so the
    // next rebuild sees fresh objects (e.g. updated isArabic, updated icon).
    // The set-equality short-circuit in `_runRebuild` will still no-op when
    // the desired ID set matches what's already onscreen.
    _lastPois = pois;
    _lastVisibility = visibility;
    _markerCache.clear();
    _polygonCache.clear();

    final initialZoom = ref.read(cameraPositionProvider)?.zoom ?? 0;
    await _rebuildAtZoom(manager, initialZoom, isArabic: isArabic);

    // React to subsequent zoom changes. We listen rather than watch so the
    // layer doesn't fully rebuild on every camera tick — only on bucket cross.
    ref.listen<CameraPositionMessage?>(cameraPositionProvider, (prev, next) {
      if (next == null) {
        return;
      }
      _rebuildAtZoom(manager, next.zoom, isArabic: isArabic);
    });
  }

  /// Public entry point — serializes against itself with trailing-debounce
  /// semantics. See `_activeRebuild` doc above for the rationale.
  Future<void> _rebuildAtZoom(
    MapObjectManager manager,
    double zoom, {
    required bool isArabic,
  }) async {
    if (_activeRebuild != null) {
      _pendingZoom = zoom;
      _pendingIsArabic = isArabic;
      return;
    }
    _activeRebuild = _runRebuild(manager, zoom, isArabic: isArabic);
    try {
      await _activeRebuild;
    } finally {
      _activeRebuild = null;
    }
    if (_pendingZoom != null) {
      final z = _pendingZoom!;
      final a = _pendingIsArabic ?? isArabic;
      _pendingZoom = null;
      _pendingIsArabic = null;
      await _rebuildAtZoom(manager, z, isArabic: a);
    }
  }

  /// Compute the desired ID set for `zoom`, diff against `_liveMarkerIds` /
  /// `_livePolygonIds`, and apply only the difference to the SDK. The cheap
  /// fast-path is the set-equality check at the top — most camera ticks
  /// (panning at constant zoom, sub-threshold zoom drift) bail out there
  /// without ever touching the SDK.
  ///
  /// Why no integer "bucket" gate any more: the previous gate compared
  /// `bucketOf(zoom)` to its last value, but `bucketOf` rounded fractional
  /// zooms to integer threshold edges. The SDK emits continuous zoom
  /// values, so e.g. zoom 17.0 (polygon visible) and zoom 18.5 (polygon
  /// hidden) both fell in bucket 16 — threshold crossings within the same
  /// bucket were silently dropped. Comparing the actual *desired ID set*
  /// catches every transition exactly when it happens.
  Future<void> _runRebuild(
    MapObjectManager manager,
    double zoom, {
    required bool isArabic,
  }) async {
    // Phase 1 — cheap visibility scan: just collect ID sets, no marker /
    // polygon construction. ~700 visibility evaluations per tick is fine.
    final desiredMarkerIds = <String>{};
    final desiredPolygonIds = <String>{};
    var fallbackIcons = 0;
    for (final poi in _lastPois) {
      final mid = _markerId(poi);
      if (_lastVisibility.isVisible(
        geometry: DynamicPoiGeometryType.marker,
        objectType: poi.objectType,
        zoom: zoom,
      )) {
        desiredMarkerIds.add(mid);
        if (DynamicPoiIconResolver.resolveWithFallbackInfo(poi.rubricIds).isFallback) {
          fallbackIcons++;
        }
      }
      if (poi.hasPolygon &&
          _lastVisibility.isVisible(
            geometry: DynamicPoiGeometryType.polygon,
            objectType: poi.objectType,
            zoom: zoom,
          )) {
        for (var i = 0; i < poi.polygonContours!.length; i++) {
          desiredPolygonIds.add(_polygonId(poi, i));
        }
      }
    }

    // Phase 2 — fast-path: the desired ID sets match what's already onscreen.
    // No rebuild needed. This replaces the broken integer-bucket short-circuit.
    if (_setEquals(desiredMarkerIds, _liveMarkerIds) &&
        _setEquals(desiredPolygonIds, _livePolygonIds)) {
      return;
    }

    // Phase 3 — diff. Work out exactly which IDs need to enter/leave the SDK.
    final markersToAddIds = desiredMarkerIds.difference(_liveMarkerIds);
    final markersToRemoveIds = _liveMarkerIds.difference(desiredMarkerIds);
    final polygonsToAddIds = desiredPolygonIds.difference(_livePolygonIds);
    final polygonsToRemoveIds = _livePolygonIds.difference(desiredPolygonIds);

    // Phase 4 — build the new objects (heavy path), drawing from the cache so
    // a marker that was removed for being off-zoom and is now back doesn't
    // re-allocate.
    final markersToAdd = <Marker>[
      for (final poi in _lastPois)
        if (markersToAddIds.contains(_markerId(poi)))
          _markerCache.putIfAbsent(_markerId(poi), () => _buildMarker(poi, isArabic: isArabic)),
    ];
    final polygonsToAdd = <Polygon>[
      for (final poi in _lastPois)
        if (poi.hasPolygon)
          ..._polygonCache
              .putIfAbsent(poi.id, () => _buildPolygons(poi))
              .where((p) => polygonsToAddIds.contains(p.id)),
    ];

    // ignore: avoid_print
    print('[DynamicPoiDebug] zoom=$zoom — '
        'desired: ${desiredMarkerIds.length} markers, ${desiredPolygonIds.length} polygons; '
        'fallbackIcons=$fallbackIcons; '
        'diff: +${markersToAdd.length}/-${markersToRemoveIds.length} markers, '
        '+${polygonsToAdd.length}/-${polygonsToRemoveIds.length} polygons');

    try {
      // Add the genuinely new objects FIRST so they appear while the old set
      // is still on screen — overlap stays continuously visible.
      if (markersToAdd.isNotEmpty) {
        await manager.addMarkers(markersToAdd);
      }
      if (polygonsToAdd.isNotEmpty) {
        await manager.addPolygons(polygonsToAdd);
      }
      // Then remove the objects that left the desired set. Removals run in
      // parallel; each is an independent pigeon round-trip.
      await Future.wait([
        for (final id in markersToRemoveIds) manager.removeMarkerById(id),
        for (final id in polygonsToRemoveIds) manager.removePolygonById(id),
      ]);

      _liveMarkerIds
        ..removeAll(markersToRemoveIds)
        ..addAll(markersToAddIds);
      _livePolygonIds
        ..removeAll(polygonsToRemoveIds)
        ..addAll(polygonsToAddIds);
    } catch (e, st) {
      // ignore: avoid_print
      print('[DynamicPoiDebug] diff update failed: $e\n$st');
    }
  }

  static bool _setEquals(Set<String> a, Set<String> b) {
    if (a.length != b.length) {
      return false;
    }
    for (final v in a) {
      if (!b.contains(v)) {
        return false;
      }
    }
    return true;
  }

  String _markerId(DynamicPoi poi) => 'dynamic_poi_${poi.id}';

  String _polygonId(DynamicPoi poi, int ringIndex) => 'dynamic_poi_polygon_${poi.id}_$ringIndex';

  Marker _buildMarker(DynamicPoi poi, {required bool isArabic}) {
    final position = GeoPointWithElevationMessage(
      latitude: poi.lat,
      longitude: poi.lon,
      elevation: 0,
    );
    final closestPoint = LatLng(latitude: poi.lat, longitude: poi.lon);
    final iconPath = DynamicPoiIconResolver.resolve(poi.rubricIds);
    final label = poi.name?.trim();
    final hasLabel = label != null && label.isNotEmpty;

    return Marker(
      id: _markerId(poi),
      // Native iOS+Android tap handlers (urbi_map/.../ObjectTapHandler) now
      // route Marker hits through the long-press callback, so this `onTap`
      // closure only fires after a ~500ms hold. Short taps no longer open
      // the POI sheet.
      onTap: () async {
        // ignore: avoid_print
        print('[DynamicPoiDebug] marker long-press id=${poi.id} '
            'type=${poi.objectType} rubrics=${poi.rubricIds}');
        await _openPoiCard(objectId: poi.objectId, point: closestPoint);
      },
      options: MarkerOptionsMessage(
        position: position,
        icon: iconPath.markerIcon(size: 28),
        text: hasLabel ? label : null,
        textStyle: hasLabel ? _labelStyle(label, isArabic: isArabic) : null,
        // Anchor at icon center (0.5, 0.5) so the disc renders symmetrically
        // around the geo position. The previous (0.5, 1.0) anchor pinned the
        // bottom of the icon to the geo point and combined with the SVGs'
        // negative-origin viewBox produced the clipped half-disc artifact
        // (`.task/iter4_clipped_icons.png`). The SVGs were also rebuilt with
        // `viewBox="0 0 32 32"` for clean rasterization.
        anchor: MarkerAnchorMessage(x: 0.5, y: 0.5),
        animatedAppearance: true,
        zIndex: 40,
      ),
    );
  }

  /// Flat list of polygons for one POI (one entry per outer ring, so a
  /// `MultiPolygon` produces N polygons). Each polygon shares the POI's
  /// `onTap` so long-pressing the area opens the same card as the marker.
  List<Polygon> _buildPolygons(DynamicPoi poi) {
    final contours = poi.polygonContours!;
    final closestPoint = LatLng(latitude: poi.lat, longitude: poi.lon);
    final result = <Polygon>[];
    for (var i = 0; i < contours.length; i++) {
      final ring = contours[i];
      result.add(
        Polygon(
          id: _polygonId(poi, i),
          options: PolygonOptionsMessage(
            contours: [PolylineGeometryMessage(points: ring)],
            color: _polygonFillArgb,
            strokeColor: _polygonStrokeArgb,
            strokeWidth: 2,
          ),
          onTap: () async {
            // ignore: avoid_print
            print('[DynamicPoiDebug] polygon long-press id=${poi.id} type=${poi.objectType}');
            await _openPoiCard(objectId: poi.objectId, point: closestPoint);
          },
        ),
      );
    }
    return result;
  }

  Future<void> _openPoiCard({required int objectId, required LatLng point}) async {
    await ref
        .read(appRouterProvider)
        .replaceOrPush(
          route: PoiCardWidgetRoute(
            objectId: DgisObjectIdMessage(objectId: objectId, entranceId: 0),
            closestPoint: point,
          ),
          toCompareRoutes: [PoiCardWidgetRoute.page],
        );
  }

  MarkerTextStyleMessage _labelStyle(String label, {required bool isArabic}) {
    final useArabicFont = label.containsArabic() || isArabic;
    return MarkerTextStyleMessage(
      fontSize: 11,
      textOffset: 2,
      color: 0xff1B1B1B,
      strokeColor: 0xD3FFFFFF,
      strokeWidth: 1,
      fontName: useArabicFont ? poiMapFontAr : poiMapFontEn,
      textPlacement: MarkerTextPlacementMessage(placement: TextPlacementMessage.bottomCenter),
      suppressOnOverlap: true,
    );
  }
}
