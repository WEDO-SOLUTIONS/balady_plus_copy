import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_icon_resolver.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_marker_bitmap.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_marker_size.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_models.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_repository.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_selection_provider.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_visibility.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_visibility_provider.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/extensions/string_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dynamic_poi_layer_provider.g.dart';

const int _polygonFillArgb = 0x331B5E5C; // teal, ~20% alpha
const int _polygonStrokeArgb = 0xFF0AB0A4; // teal solid

@Riverpod(keepAlive: true)
class DynamicPoiLayer extends _$DynamicPoiLayer {
  late final MapObjectManagerSettings _settings = MapObjectManagerSettings.dynamicPoi();
  final DynamicPoiMarkerBitmap _bitmap = DynamicPoiMarkerBitmap();

  /// Last POI list and visibility config used to (re)build markers — kept so
  /// camera-zoom / selection updates can re-filter without re-fetching.
  List<DynamicPoi> _lastPois = const [];
  DynamicPoiVisibility _lastVisibility = DynamicPoiVisibility.fallback;

  /// IDs currently present on the map for this layer. The marker id encodes
  /// `(poiId, size, isSelected)` so any change to those triggers an SDK-level
  /// add/remove via the diff path below. See `_markerId`.
  final Set<String> _liveMarkerIds = <String>{};
  final Set<String> _livePolygonIds = <String>{};

  /// Cache of constructed `Marker` / `Polygon` objects keyed by their SDK id.
  /// The byte-blob cache for the rendered marker bitmap lives inside
  /// `DynamicPoiMarkerBitmap` itself.
  final Map<String, Marker> _markerCache = <String, Marker>{};
  final Map<String, List<Polygon>> _polygonCache = <String, List<Polygon>>{};

  /// Serialization for `_rebuildAtZoom` so concurrent zoom / selection /
  /// theme ticks don't race on the live-ID sets. Trailing-debounce semantics:
  /// only one rebuild runs at a time; ticks that arrive while a rebuild is in
  /// flight overwrite a single pending slot, and the latest pending state is
  /// drained when the active rebuild finishes.
  Future<void>? _activeRebuild;
  double? _pendingZoom;
  bool? _pendingIsArabic;
  bool? _pendingIsDark;
  String? _pendingSelectedId;

  /// Tracks the last `isArabic` value passed to `_runRebuild`. A change here
  /// means every marker label must be re-rendered in the new language —
  /// since labels are baked into the SDK-side `Marker.options.text`, we
  /// can't just mutate them: the rebuild path tears down and re-adds the
  /// full set. See the language-change branch in `_runRebuild`.
  bool? _lastIsArabic;

  @override
  Future<void> build() async {
    final managerProvider = mapObjectManagerProvider(
      named: _settings.name,
      layerId: _settings.layerId,
    );
    final manager = ref.watch(managerProvider.notifier);
    await ref.watch(managerProvider.future);

    final pois = await ref.watch(dynamicPoiRepositoryProvider.future);
    final visibility = await ref.watch(dynamicPoiVisibilityConfigProvider.future);
    final isArabic = ref.watch(appLanguageProvider) == Language.arabic;
    final isDark = (await ref.watch(darkModeProvider.future)).isDark;
    final initialSelectedId = ref.read(selectedDynamicPoiIdProvider);

    // New data set / config: invalidate the marker+polygon object caches so
    // the next rebuild builds fresh objects (e.g. updated isArabic). The
    // bitmap byte-blob cache inside `_bitmap` is intentionally NOT cleared —
    // its keys are `(rubricId, size, isSelected)` which are unaffected by
    // language / poi-list changes.
    _lastPois = pois;
    _lastVisibility = visibility;
    _markerCache.clear();
    _polygonCache.clear();

    final initialZoom = ref.read(cameraPositionProvider)?.zoom ?? 0;
    await _rebuildAtZoom(manager, initialZoom, isArabic: isArabic, isDark: isDark, selectedId: initialSelectedId);

    // Camera zoom + selection — listen (not watch) so the layer doesn't fully
    // rebuild on every camera tick, only the diff path runs. Theme changes
    // re-run build() via `ref.watch(darkModeProvider.future)` above, so they
    // arrive at the live-ID sets through a fresh build instead of `_runRebuild`.
    ref
      ..listen<CameraPositionMessage?>(cameraPositionProvider, (prev, next) {
        if (next == null) {
          return;
        }
        _rebuildAtZoom(
          manager,
          next.zoom,
          isArabic: isArabic,
          isDark: isDark,
          selectedId: ref.read(selectedDynamicPoiIdProvider),
        );
      })
      ..listen<String?>(selectedDynamicPoiIdProvider, (prev, next) {
        final z = ref.read(cameraPositionProvider)?.zoom ?? 0;
        _rebuildAtZoom(manager, z, isArabic: isArabic, isDark: isDark, selectedId: next);
      })
      ..listen<Marker?>(selectedMarkerProvider, (prev, next) {
        if (next == null) return;
        final selectedId = ref.read(selectedDynamicPoiIdProvider);
        if (selectedId == null) return;

        DynamicPoi? selectedPoi;
        for (final p in _lastPois) {
          if (p.id == selectedId) {
            selectedPoi = p;
            break;
          }
        }
        if (selectedPoi == null) {
          ref.read(selectedDynamicPoiIdProvider.notifier).select(null);
          return;
        }

        // ~0.0001 degrees ≈ 11m; the SDK reports the same coordinates for
        // each tap on a given POI, so this tolerance is just numerical
        // safety, not a "nearby POI" matcher.
        final dLat = (next.options.position.latitude - selectedPoi.lat).abs();
        final dLng = (next.options.position.longitude - selectedPoi.lon).abs();
        const sameSpotTolerance = 0.0001;
        final isSamePoi = dLat < sameSpotTolerance && dLng < sameSpotTolerance;

        if (isSamePoi) {
          ref.read(selectedMarkerProvider.notifier).clear();
        } else {
          ref.read(selectedDynamicPoiIdProvider.notifier).select(null);
        }
      });

    // Clear selection whenever the POI card leaves the route stack (e.g. user
    // dismissed the sheet, navigated away). Selection on tap of a different
    // dynamic POI is handled implicitly via `state = newId` in `select(...)`.
    // TODO(dynamic_poi): also clear on empty-area tap once the SDK exposes
    // such an event — there's no `EmptyTapEvent` in the current pigeon API.
    final appRouter = ref.read(appRouterProvider);
    void onRouteChanged() {
      if (!appRouter.isRouteActive(PoiCardWidgetRoute.name) && ref.read(selectedDynamicPoiIdProvider) != null) {
        ref.read(selectedDynamicPoiIdProvider.notifier).select(null);
      }
    }

    appRouter.addListener(onRouteChanged);
    ref.onDispose(() => appRouter.removeListener(onRouteChanged));
  }

  Future<void> _rebuildAtZoom(
    MapObjectManager manager,
    double zoom, {
    required bool isArabic,
    required bool isDark,
    required String? selectedId,
  }) async {
    if (_activeRebuild != null) {
      _pendingZoom = zoom;
      _pendingIsArabic = isArabic;
      _pendingIsDark = isDark;
      _pendingSelectedId = selectedId;
      return;
    }
    _activeRebuild = _runRebuild(manager, zoom, isArabic: isArabic, isDark: isDark, selectedId: selectedId);
    try {
      await _activeRebuild;
    } finally {
      _activeRebuild = null;
    }
    if (_pendingZoom != null) {
      final z = _pendingZoom!;
      final a = _pendingIsArabic ?? isArabic;
      final d = _pendingIsDark ?? isDark;
      final s = _pendingSelectedId;
      _pendingZoom = null;
      _pendingIsArabic = null;
      _pendingIsDark = null;
      _pendingSelectedId = null;
      await _rebuildAtZoom(manager, z, isArabic: a, isDark: d, selectedId: s);
    }
  }

  /// Compute the desired marker / polygon ID sets for the current
  /// (zoom, selectedId) and diff against `_liveMarkerIds` / `_livePolygonIds`.
  /// Only the difference is applied to the SDK; matching ID sets bail out at
  /// the equality check without touching the SDK.
  Future<void> _runRebuild(
    MapObjectManager manager,
    double zoom, {
    required bool isArabic,
    required bool isDark,
    required String? selectedId,
  }) async {
    final zoomSize = sizeForZoom(zoom);
    final dpr = WidgetsBinding.instance.platformDispatcher.views.isNotEmpty
        ? WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio
        : 3.0;

    // Phase 1 — cheap visibility scan: just collect ID sets, no bitmap work.
    // Selected POI is promoted to `large` so it stands out without a separate
    // selected-state palette (colors are theme-driven only).
    final desiredMarkerIds = <String>{};
    final desiredPolygonIds = <String>{};
    for (final poi in _lastPois) {
      final isSelected = poi.id == selectedId;
      final size = isSelected ? DynamicPoiMarkerSize.large : zoomSize;
      if (_lastVisibility.isVisible(
        geometry: DynamicPoiGeometryType.marker,
        objectType: poi.objectType,
        zoom: zoom,
      )) {
        desiredMarkerIds.add(_markerId(poi, size, isDark));
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

    // Phase 2 — fast-path: desired sets match what's already onscreen. Most
    // pan-at-constant-zoom ticks bail out here. A pending language change
    // disables this fast-path so labels actually get refreshed.
    final languageChanged = _lastIsArabic != null && _lastIsArabic != isArabic;
    _lastIsArabic = isArabic;

    if (!languageChanged &&
        _setEquals(desiredMarkerIds, _liveMarkerIds) &&
        _setEquals(desiredPolygonIds, _livePolygonIds)) {
      return;
    }

    // Phase 3 — diff. When the language changed every marker needs new label
    // text, so we treat every live object as "to remove" and every desired as
    // "to add" — the SDK has no "update text" API to patch in place.
    final markersToAddIds = languageChanged ? desiredMarkerIds : desiredMarkerIds.difference(_liveMarkerIds);
    final markersToRemoveIds = languageChanged
        ? Set<String>.from(_liveMarkerIds)
        : _liveMarkerIds.difference(desiredMarkerIds);
    final polygonsToAddIds = languageChanged ? desiredPolygonIds : desiredPolygonIds.difference(_livePolygonIds);
    final polygonsToRemoveIds = languageChanged
        ? Set<String>.from(_livePolygonIds)
        : _livePolygonIds.difference(desiredPolygonIds);

    if (languageChanged) {
      // Cached `Marker` objects bake in the localized label; drop them so the
      // rebuild path constructs fresh ones in the new language. Toggle the
      // manager invisible during the heavy `removeAll → addAll` sequence to
      // avoid a flash of empty space mid-swap.
      _markerCache.clear();
      await manager.setMapObjectManagerIsVisible(isVisible: false);
      await manager.removeAll();
      _liveMarkerIds.clear();
      _livePolygonIds.clear();
    }

    // Phase 4 — build new objects (heavy path: bitmap composition).
    // Composition is async; build in parallel to mask per-marker rendering
    // cost. The byte-blob cache inside `_bitmap` makes repeat combinations
    // ~free.
    final markersToAdd = <Future<Marker>>[];
    for (final poi in _lastPois) {
      final size = poi.id == selectedId ? DynamicPoiMarkerSize.large : zoomSize;
      if (markersToAddIds.contains(_markerId(poi, size, isDark))) {
        markersToAdd.add(
          _resolveMarker(
            poi,
            size: size,
            isArabic: isArabic,
            isDark: isDark,
            devicePixelRatio: dpr,
          ),
        );
      }
    }
    final resolvedMarkers = await Future.wait(markersToAdd);

    final polygonsToAdd = <Polygon>[
      for (final poi in _lastPois)
        if (poi.hasPolygon)
          ..._polygonCache.putIfAbsent(poi.id, () => _buildPolygons(poi)).where((p) => polygonsToAddIds.contains(p.id)),
    ];

    try {
      // Add new objects first so the overlap stays visible during transitions.
      if (resolvedMarkers.isNotEmpty) {
        await manager.addMarkers(resolvedMarkers);
      }
      if (polygonsToAdd.isNotEmpty) {
        await manager.addPolygons(polygonsToAdd);
      }
      if (languageChanged) {
        // Restore visibility — we already wiped the live sets above via
        // `removeAll`, so per-id removals would be no-ops here.
        await manager.setMapObjectManagerIsVisible(isVisible: true);
      } else {
        // Then remove what left, in parallel.
        await Future.wait([
          for (final id in markersToRemoveIds) manager.removeMarkerById(id),
          for (final id in polygonsToRemoveIds) manager.removePolygonById(id),
        ]);
      }

      _liveMarkerIds
        ..removeAll(markersToRemoveIds)
        ..addAll(markersToAddIds);
      _livePolygonIds
        ..removeAll(polygonsToRemoveIds)
        ..addAll(polygonsToAddIds);
    } on Object {
      // Swallow — keep prior live-ID state so a transient SDK failure doesn't
      // desync the diff path.
    }
  }

  Future<Marker> _resolveMarker(
    DynamicPoi poi, {
    required DynamicPoiMarkerSize size,
    required bool isArabic,
    required bool isDark,
    required double devicePixelRatio,
  }) async {
    final id = _markerId(poi, size, isDark);
    final cached = _markerCache[id];
    if (cached != null) {
      return cached;
    }
    final marker = await _buildMarker(
      poi,
      size: size,
      isArabic: isArabic,
      isDark: isDark,
      devicePixelRatio: devicePixelRatio,
    );
    _markerCache[id] = marker;
    return marker;
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

  String _markerId(DynamicPoi poi, DynamicPoiMarkerSize size, bool isDark) =>
      'dynamic_poi_${poi.id}_${size.name}_${isDark ? 'dk' : 'lt'}';

  String _polygonId(DynamicPoi poi, int ringIndex) => 'dynamic_poi_polygon_${poi.id}_$ringIndex';

  Future<Marker> _buildMarker(
    DynamicPoi poi, {
    required DynamicPoiMarkerSize size,
    required bool isArabic,
    required bool isDark,
    required double devicePixelRatio,
  }) async {
    final position = GeoPointWithElevationMessage(latitude: poi.lat, longitude: poi.lon, elevation: 0);
    final closestPoint = LatLng(latitude: poi.lat, longitude: poi.lon);
    final glyph = DynamicPoiIconResolver.resolve(poi.rubricIds);

    final pngBytes = await _bitmap.render(
      glyphAssetPath: glyph.assetPath,
      glyphPackageName: glyph.packageName,
      rubricId: glyph.rubricId,
      size: size,
      isDark: isDark,
      devicePixelRatio: devicePixelRatio,
    );

    final anchor = _bitmap.anchorFor(size);
    final iconWidth = _bitmap.logicalWidthOf(size);
    final label = poi.name?.trim();
    final hasLabel = size != DynamicPoiMarkerSize.small && label != null && label.isNotEmpty;

    return Marker(
      id: _markerId(poi, size, isDark),
      onTap: () async {
        ref.read(selectedDynamicPoiIdProvider.notifier).select(poi.id);
        await _openPoiCard(objectId: poi.objectId, point: closestPoint);
      },
      options: MarkerOptionsMessage(
        position: position,
        icon: PngBytesMarkerIcon(pngData: pngBytes, width: iconWidth),
        text: hasLabel ? label : null,
        textStyle: hasLabel ? _labelStyle(label, isArabic: isArabic, isDark: isDark) : null,
        anchor: MarkerAnchorMessage(x: anchor.x, y: anchor.y),
        animatedAppearance: true,
        // Above the 2GIS shared `selectedMarker` (zIndex 50) so the "large
        // + accent dot" stays on top instead of being covered by the SDK's
        // purple drop-pin that `point_of_interest.dart` adds when the POI
        // card opens.
        zIndex: 100,
      ),
    );
  }

  /// Flat list of polygons for one POI (one entry per outer ring, so a
  /// `MultiPolygon` produces N polygons). Each polygon shares the POI's
  /// `onTap`, so tapping the area opens the same card as the marker.
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
            ref.read(selectedDynamicPoiIdProvider.notifier).select(poi.id);
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

  MarkerTextStyleMessage _labelStyle(String label, {required bool isArabic, required bool isDark}) {
    final useArabicFont = label.containsArabic() || isArabic;
    // Label color follows the dark/light theme so it stays readable over the
    // matching map style. Mirrors the convention used in `makkah_places`.
    return MarkerTextStyleMessage(
      fontSize: 12,
      textOffset: 4,
      color: isDark ? 0xD3FFFFFF : 0xff1B1B1B,
      strokeColor: isDark ? 0xff1B1B1B : 0xD3FFFFFF,
      strokeWidth: 2,
      fontName: useArabicFont ? MapnessConstants.poiMapFontAr : MapnessConstants.poiMapFontEn,
      textPlacement: MarkerTextPlacementMessage(placement: TextPlacementMessage.bottomCenter),
      suppressOnOverlap: true,
    );
  }
}
