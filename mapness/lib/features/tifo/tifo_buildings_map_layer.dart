import 'dart:async';
import 'dart:math' as math;

import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/tifo/building_sheet.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/data/tifo_region_outline.dart';
import 'package:mapness/features/tifo/district_sheet.dart';
import 'package:mapness/features/tifo/providers/tifo_buildings_poller.dart';
import 'package:mapness/features/tifo/providers/tifo_buildings_provider.dart';
import 'package:mapness/features/tifo/providers/tifo_districts_provider.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Whether TIFO itself is allowed to run right now. TIFO is NOT a city event
/// (it doesn't compete for `ActiveCityEvent`'s single slot — see that
/// provider's own pre-emption of city events when TIFO is on), but its
/// Remote Config schedule reuses the exact same date-range shape
/// (`CityEventDateRange.tifoDefault`: 12 Aug 2026 through end of Oct 2026,
/// a placeholder until the backend ships its own `tifoDateRange` value).
/// While the environment config hasn't loaded yet, defaults to unavailable —
/// a missing schedule means the game is off, not on by default.
final tifoAvailableProvider = Provider<bool>((ref) {
  final env = ref.watch(dgisEnvironmentProvider).value;
  return env?.tifoDateRange.isVisibleNow ?? false;
});

/// Level of detail the TIFO layer renders at, picked from the camera zoom.
enum _TifoLod {
  /// Zoomed far out: a single bundled region-outline polygon
  /// ([kTifoRegionPolygons]) painted in the SEASON leader's color. At that
  /// scale district borders aren't legible, so the region silhouette carries
  /// the same information as a 413-polygon mosaic — and it needs no
  /// `GET /districts` round-trip to appear.
  cluster,

  /// Mid range: each district in its own leading club's color.
  districts,

  /// Street level: individual buildings, colored by owner and tappable.
  buildings,
}

/// Axis-aligned lat/lng box, used both for the visible rect and for each
/// district's own extent so the district layer can be culled to what is
/// actually on screen.
@immutable
class _Bounds {
  const _Bounds({required this.minLat, required this.maxLat, required this.minLng, required this.maxLng});

  final double minLat;
  final double maxLat;
  final double minLng;
  final double maxLng;

  /// Grown by [fraction] of its own size on each axis.
  _Bounds padded(double fraction) {
    final padLat = (maxLat - minLat) * fraction;
    final padLng = (maxLng - minLng) * fraction;
    return _Bounds(
      minLat: minLat - padLat,
      maxLat: maxLat + padLat,
      minLng: minLng - padLng,
      maxLng: maxLng + padLng,
    );
  }

  bool intersects(_Bounds other) =>
      minLat <= other.maxLat && maxLat >= other.minLat && minLng <= other.maxLng && maxLng >= other.minLng;
}

/// Renders the TIFO layer on the dgis map with a zoom-based level of detail
/// (API v2.4 §3, plus the city-wide cluster tier below it):
///   * zoom <= 11 → ONE region-outline polygon in the season leader's color;
///   * zoom < 15  → district polygons tinted by each district's leading club;
///   * zoom >= 15 → individual buildings colored by owner, tappable to play.
///
/// Owns two independent [MapObjectManagerMessage]s so the two layers can be
/// cleared/redrawn without touching each other or the debug district layer.
class TifoBuildingsMapLayer extends Notifier<bool> {
  MapObjectManagerMessage? _buildingsManager;
  MapObjectManagerMessage? _districtsManager;
  StreamSubscription<VisibleRectEvent>? _visibleSub;
  Timer? _debounce;
  String? _lastBbox;

  /// LOD the district layer is currently painted at, or null when it isn't
  /// painted. LOD-aware rather than a plain bool because [_TifoLod.cluster]
  /// and [_TifoLod.districts] draw the SAME polygons in different colors — a
  /// bool would let a zoom across the cluster threshold hit the
  /// "already drawn, nothing to do" early-out and never repaint.
  _TifoLod? _drawnDistrictsLod;

  /// Fill currently painted for the cluster tier's region polygon, or null
  /// when it isn't on the map — same pointwise-diff bookkeeping the district
  /// and building layers use, so a standings poll that doesn't change the
  /// leader costs no bridge calls at all.
  int? _drawnRegionFill;

  /// Camera tilt the player had before the overlay forced the 2D view, so it
  /// can be restored on [disable]. Null once restored / never tilted.
  double? _tiltBeforeEnable;

  /// Anything at or below this counts as already flat — the SDK reports tiny
  /// residual tilts after an animation, and re-animating on those would make
  /// the camera twitch on every viewport event.
  static const double _flatTiltEpsilon = 0.5;
  double _zoom = 0;

  /// What's currently painted per building id — drives the pointwise diff
  /// redraw (recolor only what changed) instead of clearing the whole layer.
  final Map<String, int> _drawnFill = {};
  final Map<String, int> _drawnRings = {};

  /// Same diff bookkeeping for the district layer.
  final Map<String, int> _drawnDistrictFill = {};
  final Map<String, int> _drawnDistrictRings = {};

  /// Last viewport the camera reported, parsed out of the bbox string. Drives
  /// district culling; null until the camera has reported once, which means
  /// "draw everything" rather than "draw nothing".
  _Bounds? _viewBounds;

  /// Bounding box per district id, computed once from its rings. 405 boxes is
  /// nothing to hold, and it turns the cull test into four comparisons instead
  /// of a walk over every point on every viewport event.
  final Map<String, _Bounds> _districtBounds = {};

  /// District rings snapped to a coordinate grid, keyed `id@exponent`. See
  /// [_ringsFor]: at the zoom where the whole region is on screen a district
  /// is a few dozen pixels wide, so most of its vertices land in the same
  /// grid cell and collapse away.
  final Map<String, List<List<GeoPointMessage>>> _simplifiedRings = {};

  /// Grid exponent each drawn district was built at, so zooming IN can refine
  /// a district that was first painted coarsely. Never coarsens: precision
  /// already on the map is free to keep.
  final Map<String, int?> _drawnDistrictExp = {};

  /// Single-flight gate for tap-opened sheets. dgis fires onTap for EVERY
  /// polygon under the finger (overlapping rings, shared district borders)
  /// and iOS occasionally double-delivers the event — without the gate one
  /// tap stacks two identical sheets.
  bool _sheetShowing = false;
  DateTime _lastSheetOpen = DateTime.fromMillisecondsSinceEpoch(0);

  bool _acquireSheetGate() {
    final now = DateTime.now();
    if (_sheetShowing || now.difference(_lastSheetOpen) < const Duration(milliseconds: 600)) {
      return false;
    }
    _lastSheetOpen = now;
    _sheetShowing = true;
    return true;
  }

  /// At/above this zoom we show buildings; below it, districts. API §3 says 16,
  /// but this map's `visibleRectEvent.zoom` reads ~1 lower than the camera's
  /// zoom, so 16 is effectively unreachable on that stream — 15 is the real
  /// street-level threshold here.
  static const double _buildingMinZoom = 15;

  /// At/below this zoom the district layer collapses into one city-wide color
  /// (see [_TifoLod.cluster]). Same `visibleRectEvent.zoom` units as
  /// [_buildingMinZoom] above — i.e. roughly one lower than camera zoom.
  static const double _districtClusterMaxZoom = 11;

  /// Fallback district fill when nobody leads it (or the server sent no
  /// paint-ready color): the neutral palette grey.
  static const int _neutralDistrictArgb = 0xFFFCFBF2;

  /// Single polygon id for the cluster tier's region silhouette.
  static String _regionPolygonId(int index) => 'tifo-region#$index';

  /// Alpha both the fill and its border are painted at. Sharing it is the
  /// point: a fully opaque border over a 90%-alpha fill reads as a DIFFERENT
  /// colour rather than a darker edge of the same one, because only the fill
  /// picks up the basemap showing through it.
  static const int _polygonAlpha = 0xE6000000;

  /// How far the border is taken down from its fill, per channel. 0.85 is a
  /// 15% darkening — enough to separate the edge from its own fill, little
  /// enough to still read as the same colour. At 0.7 it read as a different
  /// colour entirely; raise toward 0.92 to soften it further.
  static const double _borderShade = 0.85;

  /// Nominal screen width in logical pixels, used to turn the visible rect
  /// into a degrees-per-pixel figure without reaching for a `BuildContext`.
  /// Deliberately on the wide side: overestimating the screen makes the
  /// simplification grid FINER than strictly needed, which is the safe
  /// direction to be wrong in.
  static const double _nominalScreenPx = 1600;

  /// Grid cell size as a fraction of one screen pixel. Below 1 the
  /// quantization cannot move a vertex by a distance anybody can see.
  static const double _gridPixelFraction = 0.5;

  /// How far past the visible rect the district layer is drawn, as a fraction
  /// of the rect's own size. A margin means a short pan reveals districts that
  /// are already on the map instead of waiting for the next redraw.
  static const double _districtCullPadding = 0.35;

  /// Polygons per `addPolygons` call, ordered on-screen-first by both layers
  /// so chunk #1 is what the player is actually looking at.
  ///
  /// Deliberately large. `urbi_map`'s `ObjectTapHandler.addPolygons` builds
  /// every SDK polygon object on the CALLING thread — which pigeon delivers on
  /// the platform main thread — and only the `addObjects` call goes to its
  /// background executor. So each chunk costs a main-thread hop, and small
  /// chunks trade total time away for a finer progressive reveal. Now that the
  /// previous tier stays on screen until the new one is painted, the player is
  /// never looking at a bare map, so fewer/bigger calls is the better trade.
  static const int _addChunkSize = 250;

  /// Viewport debounce while the player stays inside one tier. Long, on
  /// purpose: this is what stops a pan/fling from firing a
  /// `GET /buildings?bbox=` per frame.
  static const Duration _panDebounce = Duration(milliseconds: 400);

  /// Debounce for a viewport event that CHANGES the tier. A tier change is a
  /// visual jump the player is actively waiting on (the district mosaic
  /// appearing), so it must not queue behind [_panDebounce] — the geometry is
  /// already in memory by then, and a ~400 ms wait on top of the paint reads
  /// as "districts don't show up when I zoom out". Non-zero only to coalesce
  /// the burst of events a pinch emits while the zoom oscillates around the
  /// threshold, so the tier isn't cleared and repainted several times.
  static const Duration _tierChangeDebounce = Duration(milliseconds: 80);

  /// Safety cap on TOTAL buildings kept on the map, to bound the bridge/render
  /// cost on long sessions. Viewport-aware: on-screen buildings evict
  /// off-screen ones when the cap is hit (see [_syncBuildings]). Sized above a
  /// dense single viewport — ~1500 buildings observed live at z16 in Riyadh.
  static const int _maxRendered = 2000;

  _TifoLod get _lod => _lodFor(_zoom);

  _TifoLod _lodFor(double zoom) {
    if (zoom >= _buildingMinZoom) {
      return _TifoLod.buildings;
    }
    // `zoom == 0` means "the camera never reported a zoom" (see `enable`),
    // not "zoomed all the way out" — painting the entire city one color off
    // that guess would be a worse first frame than per-district paint.
    if (zoom > 0 && zoom <= _districtClusterMaxZoom) {
      return _TifoLod.cluster;
    }
    return _TifoLod.districts;
  }

  bool get _buildingsMode => _lod == _TifoLod.buildings;

  /// Hive box + key the ⚽ toggle is persisted under, so a killed/relaunched
  /// app comes back up with the layer in the state the player left it in
  /// instead of always cold-starting disabled.
  static const String _persistBoxName = 'tifo';
  static const String _persistKey = 'layerEnabled';

  @override
  bool build() {
    ref
      ..listen<TifoBuildingsState>(tifoBuildingsProvider, (_, next) {
        if (state && _buildingsMode) {
          unawaited(_syncBuildings(next));
        }
      })
      ..listen<TifoDistrictsState>(tifoDistrictsProvider, (_, next) {
        if (!state || _buildingsMode) {
          return;
        }
        // Standings only tint the region at the cluster tier; the polygon
        // itself is already on screen from bundled geometry.
        if (_lod == _TifoLod.cluster) {
          unawaited(_redrawRegion(next));
        } else {
          unawaited(_redrawDistricts(next));
        }
      })
      // Fill colors are resolved from `session.clubById` at draw time (see
      // `_syncBuildings`, and `_seasonLeaderColor` for the cluster LOD), but
      // the clubs roster loads asynchronously and can still be empty on the
      // very first draw — those polygons get stamped into the `_drawn*` maps
      // as neutral and the diff redraw then skips them forever, since nothing
      // else re-triggers a sync until the game state itself changes (e.g.
      // after finishing a game). Repaint once the roster actually changes, so
      // claimed buildings and the cluster tint pick up their club's color as
      // soon as it's known, without waiting on a game.
      ..listen<TifoSessionState>(tifoSessionProvider, (prev, next) {
        if (!state || identical(prev?.clubs, next.clubs)) {
          return;
        }
        if (_buildingsMode) {
          unawaited(_syncBuildings(ref.read(tifoBuildingsProvider)));
        } else if (_lod == _TifoLod.cluster) {
          unawaited(_redrawRegion(ref.read(tifoDistrictsProvider)));
        } else {
          unawaited(_redrawDistricts(ref.read(tifoDistrictsProvider)));
        }
      })
      // The Remote Config schedule can close mid-session (an admin ends the
      // event window while players are on the map) — turn the layer off
      // itself rather than leaving an unschedulable game running.
      ..listen<bool>(tifoAvailableProvider, (_, available) {
        if (!available && state) {
          logger.log('[tifo-map] disabling: tifoDateRange no longer visible');
          unawaited(disable());
        }
      })
      ..onDispose(_teardown);
    // Fire-and-forget: restore the persisted toggle once the Hive box opens
    // and the native map is ready — `enable()` awaits `dgisControllerProvider`
    // itself, so this doesn't race the map's own startup.
    unawaited(_restorePersistedState());
    return false; // disabled until the restore above (if any) flips it on
  }

  Future<void> _restorePersistedState() async {
    try {
      final box = await ref.read(hiveProvider(_persistBoxName).future);
      if (!ref.mounted) {
        return;
      }
      // Absent means "never chosen", and that reads as OFF: a fresh install
      // cold-starts on a plain map and the player opts in through the ⚽
      // control. Only an explicit `true` (the player having turned the layer
      // on themselves) restores it; the season schedule still has the final
      // say through `tifoAvailableProvider`.
      final stored = box.get(_persistKey);
      if (stored == true && ref.read(tifoAvailableProvider)) {
        logger.log('[tifo-map] restoring layer: stored=true');
        await enable();
      }
    } catch (error, stackTrace) {
      logger.log('[tifo-map] failed to restore persisted layer state: $error\n$stackTrace');
    }
  }

  Future<void> _persistEnabled(bool enabled) async {
    try {
      final box = await ref.read(hiveProvider(_persistBoxName).future);
      if (!ref.mounted) {
        return;
      }
      await box.put(_persistKey, enabled);
    } catch (error, stackTrace) {
      logger.log('[tifo-map] failed to persist layer state: $error\n$stackTrace');
    }
  }

  bool get isEnabled => state;

  Future<void> enable() async {
    if (state || !ref.read(tifoAvailableProvider)) {
      return;
    }
    state = true;
    unawaited(_persistEnabled(true));
    // Polygon colors are resolved from the clubs roster (`session.clubById`
    // in `_syncBuildings`, `_seasonLeaderColor` for the cluster tint), and
    // turning the layer on is not itself a play-intent — so nothing else in
    // this path loads the session. A player who dismissed the entry popup
    // with (X), or came back to a Hive-restored layer after a relaunch, was
    // left staring at an all-neutral map until some sheet happened to call
    // `load()`; pressing a CTA then "repainted the map", which reads as the
    // colors being a reward for tapping. Roster and config are public (the
    // guest bearer works), so this is safe while signed out.
    // Fire-and-forget: the `tifoSessionProvider` listener in `build` repaints
    // whatever is already drawn once the roster lands.
    if (ref.read(tifoSessionProvider).clubs.isEmpty) {
      unawaited(ref.read(tifoSessionProvider.notifier).load());
    }
    try {
      final controller = await ref.read(dgisControllerProvider.future);
      _buildingsManager ??= await controller.createMapObjectManager(layerId: MapObjectLayers.defaultLayerId);
      _districtsManager ??= await controller.createMapObjectManager(layerId: MapObjectLayers.defaultLayerId);

      _visibleSub = controller.visibleRectEvents.listen((event) {
        final rect = event.visibleRect;
        final delay = _lodFor(rect.zoom) == _lod ? _panDebounce : _tierChangeDebounce;
        _debounce?.cancel();
        _debounce = Timer(delay, () => unawaited(_onViewport(rect)));
      });

      // Seed zoom + first render from the current camera.
      try {
        final pos = await controller.getCameraPosition();
        _zoom = pos.zoom;
      } catch (_) {
        // Leave zoom at 0 → districts mode until the first visibleRectEvent.
      }
      logger.log('[tifo-map] enabled: zoom=$_zoom → ${_lod.name} mode');
      // BRD V2 US-05 BR-05: "The map should be shown in 2D view (bird eye
      // view)". A tilted camera also hides the flat capture polygons behind
      // the host map's 3D buildings, so this is functional, not just visual.
      await _forceTopDown(controller);
      // Long-poll building state while the layer is up (diff → pointwise redraw).
      ref.read(tifoBuildingsPollerProvider.notifier).start();
      // Right after enable the map often isn't ready to report its visible area
      // yet, so buildings mode would draw nothing until the user pans. Retry a
      // few times to render immediately. (Districts mode ignores bbox.)
      String? bbox;
      for (var attempt = 0; attempt < 6 && state; attempt++) {
        bbox = await _currentBbox(controller);
        if (bbox != null || !_buildingsMode) {
          break;
        }
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }
      if (state) {
        await _applyForViewport(bbox);
      }
      // Warm the district layer in the background. Its geometry
      // (`GET /districts`, ~413 polygons) is static for the whole season, so
      // pulling it once when the game turns on means a later pinch-out paints
      // from cache on the same frame instead of facing an empty map for a
      // round-trip. Fired AFTER the first render so it doesn't compete with the
      // visible tier's own request, and unawaited because nothing on screen
      // waits for it: this only loads data — it never moves the camera, and the
      // `tifoDistrictsProvider` listener in `build` skips the repaint entirely
      // while the player is at building zoom.
      if (state) {
        unawaited(ref.read(tifoDistrictsProvider.notifier).prefetch());
      }
    } catch (error, stackTrace) {
      logger.log('TIFO layer enable failed: $error\n$stackTrace');
    }
  }

  Future<void> disable() async {
    if (!state) {
      return;
    }
    state = false;
    unawaited(_persistEnabled(false));
    _debounce?.cancel();
    await _visibleSub?.cancel();
    _visibleSub = null;
    _lastBbox = null;
    _drawnDistrictsLod = null;
    _drawnRegionFill = null;
    _drawnFill.clear();
    _drawnRings.clear();
    _drawnDistrictFill.clear();
    _drawnDistrictRings.clear();
    _drawnDistrictExp.clear();
    ref.read(tifoBuildingsPollerProvider.notifier).stop();
    try {
      final controller = await ref.read(dgisControllerProvider.future);
      if (_buildingsManager != null) {
        await controller.removeAllPolygons(fromManager: _buildingsManager);
      }
      if (_districtsManager != null) {
        await controller.removeAllPolygons(fromManager: _districtsManager);
      }
      // The 2D view is a TIFO rule, not the host map's — give the player
      // their tilted view back when the overlay goes away.
      await _restoreTilt(controller);
    } catch (_) {
      // Map already gone.
    }
    // Keep the geometry cache (cheap re-enable); just drop the viewport set.
    ref.read(tifoBuildingsProvider.notifier).clearViewport();
  }

  Future<void> _onViewport(VisibleRect rect) async {
    final sw = Stopwatch()..start();
    final from = _lod;
    _zoom = rect.zoom;
    await _applyForViewport(
      '${rect.southWestLon},${rect.southWestLat},${rect.northEastLon},${rect.northEastLat}',
    );
    if (from != _lod) {
      // End to end, from the debounced camera event to the last polygon
      // crossing the bridge — the number that actually matches what the
      // player perceives on a tier change.
      logger.log('[tifo-map] ${from.name} → ${_lod.name} painted in ${sw.elapsedMilliseconds}ms');
    }
    // Keep the game view flat (BR-05). Re-asserted here rather than on a
    // camera stream: this runs debounced, after the gesture settles, so a
    // tilt gesture is undone once instead of being fought frame by frame.
    //
    // Runs AFTER the redraw, unawaited: it costs a `getCameraPosition` round
    // trip plus a 0.25 s camera animation whenever the player actually
    // tilted, and the polygons must not wait on that. Nothing in the redraw
    // path depends on the tilt.
    unawaited(_reassertTopDown());
  }

  Future<void> _reassertTopDown() async {
    try {
      await _forceTopDown(await ref.read(dgisControllerProvider.future));
    } catch (_) {
      // Map gone — the redraw already logged whatever went wrong.
    }
  }

  /// Flattens the camera to a bird-eye view, remembering the tilt the player
  /// had so [disable] can hand their 3D view back. No-op when already flat,
  /// so the debounced re-assert costs one `getCameraPosition` per viewport.
  Future<void> _forceTopDown(DgisMapController controller) async {
    try {
      final pos = await controller.getCameraPosition();
      if (pos.tilt <= _flatTiltEpsilon) {
        return;
      }
      _tiltBeforeEnable ??= pos.tilt;
      logger.log('[tifo-map] flattening camera: tilt ${pos.tilt.toStringAsFixed(1)} → 0 (BRD 2D view)');
      await controller.moveCamera(
        CameraPositionMessage(point: pos.point, zoom: pos.zoom, tilt: 0, bearing: pos.bearing),
        0.25,
        CameraAnimationTypeMessage.linear,
      );
    } catch (error) {
      logger.log('[tifo-map] camera flatten failed: $error');
    }
  }

  /// Puts the player's original tilt back when the overlay goes away.
  Future<void> _restoreTilt(DgisMapController controller) async {
    final tilt = _tiltBeforeEnable;
    _tiltBeforeEnable = null;
    if (tilt == null || tilt <= _flatTiltEpsilon) {
      return;
    }
    try {
      final pos = await controller.getCameraPosition();
      await controller.moveCamera(
        CameraPositionMessage(point: pos.point, zoom: pos.zoom, tilt: tilt, bearing: pos.bearing),
        0.25,
        CameraAnimationTypeMessage.linear,
      );
    } catch (_) {
      // Map gone; nothing to restore onto.
    }
  }

  /// Routes the current viewport to the right layer for the zoom level.
  ///
  /// Buildings depend on the viewport (fetch per bbox); districts are a
  /// city-wide static layer, so they're drawn once per LOD on entry — NOT on
  /// every pan (413 polygons/frame would flood the bridge and jank the map).
  Future<void> _applyForViewport(String? bbox) async {
    if (!state) {
      return;
    }
    if (bbox != null) {
      _viewBounds = _parseBbox(bbox) ?? _viewBounds;
    }
    final lod = _lod;
    final tierChanged = _drawnDistrictsLod != lod;
    if (lod == _TifoLod.buildings) {
      final hadDistricts = _drawnDistrictsLod != null;
      _drawnDistrictsLod = null;
      // Repaint whatever geometry is already cached (persists across pans /
      // district-mode round-trips), then discover new buildings for the bbox.
      await _syncBuildings(ref.read(tifoBuildingsProvider));
      if (hadDistricts) {
        // Only NOW does the district mosaic go, and unawaited at that: it stays
        // under the buildings while they paint, so the player never sees an
        // empty map. Separate object managers, so it cannot touch the polygons
        // just added.
        unawaited(_clearDistricts());
      }
      if (bbox != null && bbox != _lastBbox) {
        _lastBbox = bbox;
        logger.log('[tifo-map] buildings mode (zoom=$_zoom): fetch $bbox');
        await ref.read(tifoBuildingsProvider.notifier).fetchForBbox(bbox);
      }
    } else {
      // Both retirements below are deferred until after the new tier is on the
      // map — see [_districtPolygonIds].
      final hadBuildings = _lastBbox != null;
      _lastBbox = null;
      if (!tierChanged && lod == _TifoLod.cluster) {
        return; // one silhouette over the whole region — panning changes nothing
      }
      if (lod == _TifoLod.cluster) {
        // Region geometry is bundled ([kTifoRegionPolygons]), so paint FIRST
        // and ask the network after: the far-out view fills in on the same
        // frame instead of after a `/districts` round-trip, and standings —
        // which only pick the tint — arrive on their own schedule. No
        // `ensureGeometry()` here on purpose: this tier draws one silhouette,
        // never the ~413 district polygons, so it must not block on them (the
        // enable-time prefetch already has them coming in the background).
        logger.log('[tifo-map] cluster mode (zoom=$_zoom): painting region outline');
        // Snapshot the outgoing mosaic's ids and drop its bookkeeping BEFORE
        // painting, so a redraw racing in behind us doesn't think those
        // polygons are still live — but delete them from the map only after
        // the silhouette is up.
        final staleDistricts = _districtPolygonIds();
        _drawnDistrictFill.clear();
        _drawnDistrictRings.clear();
        _drawnDistrictExp.clear();
        await _redrawRegion(ref.read(tifoDistrictsProvider));
        unawaited(_removeDistrictPolygons(staleDistricts));
        if (hadBuildings) {
          unawaited(_clearBuildings());
        }
        unawaited(ref.read(tifoDistrictsProvider.notifier).refreshSummaries());
        return;
      }
      // Entering the mosaic: the region silhouette is what has to go, and the
      // fill bookkeeping is reset now so `_redrawRegion` doesn't later decide
      // the silhouette is "already painted in this color" and skip re-adding
      // it on the way back out.
      final regionWasDrawn = _drawnRegionFill != null;
      _drawnRegionFill = null;
      final districts = ref.read(tifoDistrictsProvider.notifier);
      // Standings are live, so entering the tier always refetches them — but
      // fire-and-forget: the polygons go up in their last known colors right
      // away and the `tifoDistrictsProvider` listener recolors the 0–2
      // districts whose leader actually changed once `/districts/summary`
      // answers. Only on tier ENTRY: panning within the tier must not fire a
      // request per camera move.
      if (tierChanged) {
        unawaited(districts.refreshSummaries());
      }
      if (!ref.read(tifoDistrictsProvider).hasGeometry) {
        // Cold cache — only reachable if the player pinches out within the few
        // seconds the enable-time prefetch is still in flight (`ensureGeometry`
        // hands back that same request rather than firing a second one), or if
        // that prefetch failed.
        logger.log('[tifo-map] ${lod.name} mode (zoom=$_zoom): geometry cold, loading…');
        await districts.ensureGeometry();
        // That fetch is a network round-trip: the player can keep pinching out
        // and cross into the cluster tier while it runs. Without this check the
        // 413 district polygons landed ON TOP of the region silhouette the
        // cluster branch had already painted, and neither side cleared the
        // other — the overlap then survived until the next tier change.
        if (!state || _lod != lod) {
          logger.log('[tifo-map] districts draw dropped: tier moved to ${_lod.name} while loading');
          return;
        }
      }
      final st = ref.read(tifoDistrictsProvider);
      logger.log(
        '[tifo-map] ${lod.name} mode (zoom=$_zoom): ${st.districts.length} geom, '
        '${st.summaries.length} summaries, err=${st.error}',
      );
      await _redrawDistricts(st);
      if (regionWasDrawn) {
        unawaited(_removeDistrictPolygons([for (var i = 0; i < _regionGeometry().length; i++) _regionPolygonId(i)]));
      }
      if (hadBuildings) {
        unawaited(_clearBuildings());
      }
    }
  }

  /// `minLng,minLat,maxLng,maxLat` — the same string the buildings endpoint
  /// takes, reused as the cull rect so there is one source of truth for
  /// "what the camera is looking at".
  static _Bounds? _parseBbox(String bbox) {
    final parts = bbox.split(',');
    if (parts.length != 4) {
      return null;
    }
    final v = [for (final part in parts) double.tryParse(part)];
    if (v.any((n) => n == null)) {
      return null;
    }
    return _Bounds(minLng: v[0]!, minLat: v[1]!, maxLng: v[2]!, maxLat: v[3]!);
  }

  static _Bounds _boundsOf(TifoDistrict district) {
    var minLat = double.infinity, maxLat = double.negativeInfinity;
    var minLng = double.infinity, maxLng = double.negativeInfinity;
    for (final ring in district.rings) {
      for (final p in ring) {
        minLat = p.latitude < minLat ? p.latitude : minLat;
        maxLat = p.latitude > maxLat ? p.latitude : maxLat;
        minLng = p.longitude < minLng ? p.longitude : minLng;
        maxLng = p.longitude > maxLng ? p.longitude : maxLng;
      }
    }
    return _Bounds(minLat: minLat, maxLat: maxLat, minLng: minLng, maxLng: maxLng);
  }

  /// Whether [district] is worth putting on the map right now. At z12–14 the
  /// visible rect holds a fraction of the ~405 districts, and the ones outside
  /// it cost bridge time and render time for something nobody can see.
  bool _districtInView(TifoDistrict district) {
    final view = _viewBounds;
    if (view == null) {
      return true; // camera hasn't reported yet — better all than none
    }
    return view.padded(_districtCullPadding).intersects(_districtBounds[district.id] ??= _boundsOf(district));
  }

  /// Exponent of the coordinate grid (step = 2^exp degrees) that is still
  /// sub-pixel at the current viewport, or null when the camera hasn't
  /// reported yet — in which case nothing is snapped.
  ///
  /// Derived from the visible rect rather than from the zoom number, so it
  /// needs no assumptions about this map's zoom units (`visibleRect.zoom`
  /// already reads ~1 lower than the camera's).
  int? _gridExponent() {
    final view = _viewBounds;
    if (view == null) {
      return null;
    }
    final target = (view.maxLng - view.minLng) / _nominalScreenPx * _gridPixelFraction;
    if (target <= 0 || !target.isFinite) {
      return null;
    }
    return (math.log(target) / math.ln2).floor();
  }

  /// Whether geometry built at [drawn] is coarser than [needed] — i.e. worth
  /// re-adding at higher precision. null means full precision.
  static bool _coarserThan(int? drawn, int? needed) {
    if (drawn == null) {
      return false;
    }
    if (needed == null) {
      return true;
    }
    return drawn > needed;
  }

  /// [district]'s rings, with every vertex snapped to a global grid of
  /// 2^[exp] degrees and consecutive duplicates dropped.
  ///
  /// A GLOBAL grid, not per-polygon simplification, and that is the whole
  /// point: districts form a mosaic of shared borders, and Douglas–Peucker
  /// run per polygon would move each side of a shared border differently,
  /// opening hairline gaps and overlaps between neighbours. Snapping to a
  /// grid every district shares moves both sides of a border to the same
  /// place, so the mosaic stays sealed.
  List<List<GeoPointMessage>> _ringsFor(TifoDistrict district, int? exp) {
    if (exp == null) {
      return [
        for (final ring in district.rings)
          [for (final p in ring) GeoPointMessage(latitude: p.latitude, longitude: p.longitude)],
      ];
    }
    final key = '${district.id}@$exp';
    final cached = _simplifiedRings[key];
    if (cached != null) {
      return cached;
    }
    final step = math.pow(2.0, exp).toDouble();
    final out = <List<GeoPointMessage>>[];
    for (final ring in district.rings) {
      final pts = <GeoPointMessage>[];
      double? lastLat, lastLng;
      for (final p in ring) {
        final lat = (p.latitude / step).roundToDouble() * step;
        final lng = (p.longitude / step).roundToDouble() * step;
        if (lat == lastLat && lng == lastLng) {
          continue; // collapsed onto the previous vertex's cell
        }
        pts.add(GeoPointMessage(latitude: lat, longitude: lng));
        lastLat = lat;
        lastLng = lng;
      }
      // Under 3 distinct vertices there is no polygon left to draw — keep the
      // original ring so a small district doesn't silently vanish.
      out.add(
        pts.length >= 3 ? pts : [for (final p in ring) GeoPointMessage(latitude: p.latitude, longitude: p.longitude)],
      );
    }
    _simplifiedRings[key] = out;
    return out;
  }

  /// Pushes [polygons] across the bridge in [_addChunkSize] batches, so the
  /// first (on-screen) ones render while the rest are still being serialized.
  Future<void> _addChunked(
    DgisMapController controller,
    List<Polygon> polygons,
    MapObjectManagerMessage? manager,
  ) async {
    for (var i = 0; i < polygons.length; i += _addChunkSize) {
      final end = i + _addChunkSize < polygons.length ? i + _addChunkSize : polygons.length;
      await controller.addPolygons(polygons.sublist(i, end), toManager: manager);
      if (!state) {
        return; // layer turned off mid-stream
      }
    }
  }

  Future<String?> _currentBbox(DgisMapController controller) async {
    try {
      final area = await controller.getVisibleArea();
      final pts = <GeoPointMessage>[];
      for (final c in area.contours) {
        if (c is PolylineGeometryMessage) {
          pts.addAll(c.points);
        }
      }
      if (pts.isEmpty) {
        return null;
      }
      var minLat = pts.first.latitude, maxLat = pts.first.latitude;
      var minLng = pts.first.longitude, maxLng = pts.first.longitude;
      for (final p in pts) {
        minLat = p.latitude < minLat ? p.latitude : minLat;
        maxLat = p.latitude > maxLat ? p.latitude : maxLat;
        minLng = p.longitude < minLng ? p.longitude : minLng;
        maxLng = p.longitude > maxLng ? p.longitude : maxLng;
      }
      return '$minLng,$minLat,$maxLng,$maxLat';
    } catch (_) {
      return null;
    }
  }

  // ─── Buildings (zoom >= 16) ────────────────────────────────────────────────

  /// Pointwise, accumulating redraw: every building ever fetched stays on the
  /// map (cached geometry) — we only ADD newly-discovered buildings and recolor
  /// those whose owner changed (poll). Nothing is removed when it leaves the
  /// viewport, so panning back is instant and the map fills in over time.
  Future<void> _syncBuildings(TifoBuildingsState st) async {
    final manager = _buildingsManager;
    if (manager == null) {
      return;
    }
    try {
      final controller = await ref.read(dgisControllerProvider.future);

      // Add new / recolor changed across the whole cache (not just the viewport).
      // The plugin only removes polygons one id at a time, so removals for a
      // recolor are collected and fired CONCURRENTLY — N parallel bridge calls
      // instead of N serialized round-trips — followed by one addPolygons batch.
      //
      // The render cap is VIEWPORT-AWARE: a single dense viewport can exceed
      // it (1489 buildings seen live at z16), and a dumb "skip when full" left
      // every later viewport blank. On-screen buildings are drawn first, and
      // when the cap is hit an off-screen polygon is evicted to make room —
      // off-screen cache only fills whatever room is left.
      final visible = st.visibleIds;
      final ordered = [
        ...st.byId.values.where((b) => visible.contains(b.id)),
        ...st.byId.values.where((b) => !visible.contains(b.id)),
      ];
      final evictable = _drawnFill.keys.where((id) => !visible.contains(id)).toList();
      var evicted = 0;
      final toAdd = <Polygon>[];
      final toRemove = <String>[];
      final session = ref.read(tifoSessionProvider);
      for (final building in ordered) {
        final club = session.clubById(building.ownerClubSlug);
        final fill = club?.fillArgb ?? kTifoNeutralFillArgb;
        final stroke = club?.strokeArgb ?? kTifoNeutralStrokeArgb;
        final prev = _drawnFill[building.id];
        if (prev == fill) {
          continue; // already drawn, unchanged → keep it
        }
        if (prev == null && _drawnFill.length >= _maxRendered) {
          // At the cap: an on-screen building may evict an off-screen one;
          // off-screen additions just wait for room.
          if (!visible.contains(building.id) || evicted >= evictable.length) {
            continue;
          }
          final victim = evictable[evicted++];
          final victimRings = _drawnRings.remove(victim) ?? 0;
          _drawnFill.remove(victim);
          for (var i = 0; i < victimRings; i++) {
            toRemove.add('tifo-bld:$victim#$i');
          }
        }
        if (prev != null) {
          final rings = _drawnRings[building.id] ?? 0;
          for (var i = 0; i < rings; i++) {
            toRemove.add('tifo-bld:${building.id}#$i'); // recolor → replace
          }
        }
        for (var i = 0; i < building.rings.length; i++) {
          toAdd.add(
            Polygon(
              id: 'tifo-bld:${building.id}#$i',
              onTap: () => _openBuilding(building),
              options: PolygonOptionsMessage(
                contours: [
                  PolylineGeometryMessage(
                    points: [
                      for (final p in building.rings[i]) GeoPointMessage(latitude: p.latitude, longitude: p.longitude),
                    ],
                  ),
                ],
                color: fill,
                strokeColor: stroke,
                strokeWidth: club == null ? 1.5 : 2,
              ),
            ),
          );
        }
        _drawnFill[building.id] = fill;
        _drawnRings[building.id] = building.rings.length;
      }
      if (toRemove.isNotEmpty) {
        await Future.wait(toRemove.map((id) => controller.removePolygon(id, fromManager: manager)));
      }
      if (toAdd.isNotEmpty) {
        // `ordered` puts on-screen buildings first, so the first chunk is the
        // screenful the player is looking at — the rest of the cache streams
        // in behind it instead of holding up the whole paint.
        final sw = Stopwatch()..start();
        await _addChunked(controller, toAdd, manager);
        logger.log(
          '[tifo-map] buildings sync: ${toAdd.length} polygons in ${sw.elapsedMilliseconds}ms '
          '(${toRemove.length} removed, ${st.byId.length} cached, ${visible.length} on screen)',
        );
      }
    } catch (error, stackTrace) {
      logger.log('[tifo-map] buildings sync failed: $error\n$stackTrace');
    }
  }

  Future<void> _clearBuildings() async {
    _drawnFill.clear();
    _drawnRings.clear();
    final manager = _buildingsManager;
    if (manager == null) {
      return;
    }
    try {
      final controller = await ref.read(dgisControllerProvider.future);
      await controller.removeAllPolygons(fromManager: manager);
    } catch (_) {}
  }

  void _openBuilding(TifoBuilding building) {
    final context = rootNavigatorKey.currentContext;
    if (context == null || !_acquireSheetGate()) {
      return;
    }
    // The tap closure captures the building as it was when the polygon was
    // drawn, and polygons are only redrawn on a fill change — so score/status
    // refreshed by the poller never reach it. Resolve the current cache entry
    // instead of the drawn-time snapshot.
    final fresh = ref.read(tifoBuildingsProvider).byId[building.id] ?? building;
    unawaited(showTifoBuildingSheet(context, fresh).whenComplete(() => _sheetShowing = false));
  }

  // ─── Districts (zoom < 15) ─────────────────────────────────────────────────

  /// Paint-ready ARGB of the club leading the SEASON, for the cluster LOD.
  ///
  /// Derived from the district standings this layer already loads — the
  /// `/leaderboards?scope=clubs` endpoint is deliberately NOT called here, so
  /// the cluster tier costs zero extra requests and always agrees with the
  /// polygons around it (both read the same `summaries` snapshot).
  ///
  /// Ranked by BUILDINGS claimed city-wide (`summary.counts` summed across
  /// every district, not just the ones a club leads — a club can hold the most
  /// buildings overall while leading no district at all), tie-broken by
  /// districts led and then by slug. That last tie-break isn't cosmetic: an
  /// unbroken tie would repaint the whole city a different color on every
  /// poll, purely from `Map` iteration order.
  ///
  /// Null when nothing is claimed yet (pre-season / fresh reset), which the
  /// caller paints neutral.
  int? _seasonLeaderColor(TifoDistrictsState districtsState) {
    final buildingsHeld = <String, int>{};
    final districtsLed = <String, int>{};
    final colorBySlug = <String, int>{};
    for (final summary in districtsState.summaries.values) {
      for (final entry in summary.counts.entries) {
        buildingsHeld[entry.key] = (buildingsHeld[entry.key] ?? 0) + entry.value;
      }
      final slug = summary.leaderClub;
      if (slug == null || slug.isEmpty) {
        continue; // neutral district — contributes claims, but leads nobody
      }
      districtsLed[slug] = (districtsLed[slug] ?? 0) + 1;
      final color = summary.leaderColorArgb;
      if (color != null) {
        colorBySlug[slug] ??= color;
      }
    }
    // Buildings are the ranking criterion, but `counts` is OPTIONAL in the
    // `/districts/summary` payload (see `TifoDistrictSummary.fromJson`) — a
    // response without it leaves `buildingsHeld` empty and used to sink the
    // whole tier to neutral white, even with a clear leader on screen. Fall
    // back to districts led in that case: it comes from `leaderClub`, which
    // is always present when anyone leads at all.
    final byBuildings = buildingsHeld.values.any((count) => count > 0);
    final primary = byBuildings ? buildingsHeld : districtsLed;
    final secondary = byBuildings ? districtsLed : buildingsHeld;
    var leader = '';
    for (final entry in primary.entries) {
      if (entry.value <= 0) {
        continue; // an explicit `{'club': 0}` is not a claim
      }
      if (leader.isEmpty || _outranks(entry.key, leader, primary, secondary)) {
        leader = entry.key;
      }
    }
    if (leader.isEmpty) {
      logger.log(
        '[tifo-map] no season leader: ${districtsState.summaries.length} summaries, '
        'none with claims → neutral paint',
      );
      return null;
    }
    // Prefer the server's paint-ready color from a district this club leads;
    // the city-wide leader may lead none, so fall back to the clubs roster
    // (same source the building polygons use). Roster still loading → null,
    // and the `tifoSessionProvider` listener repaints once it arrives.
    final color = colorBySlug[leader] ?? ref.read(tifoSessionProvider).clubById(leader)?.colorArgb;
    logger.log(
      '[tifo-map] season leader: $leader by ${byBuildings ? 'buildings' : 'districts (no counts in payload)'} '
      '(${buildingsHeld[leader] ?? 0} buildings, ${districtsLed[leader] ?? 0} districts led) '
      '→ color ${color == null ? 'UNKNOWN, painting neutral' : '0x${color.toRadixString(16)}'}',
    );
    return color;
  }

  /// Strict "a beats b" for [_seasonLeaderColor]'s ranking, so the winner is
  /// found in one pass without allocating a sorted list. [primary] decides;
  /// [secondary] only breaks its ties.
  bool _outranks(String a, String b, Map<String, int> primary, Map<String, int> secondary) {
    final byPrimary = (primary[a] ?? 0).compareTo(primary[b] ?? 0);
    if (byPrimary != 0) {
      return byPrimary > 0;
    }
    final bySecondary = (secondary[a] ?? 0).compareTo(secondary[b] ?? 0);
    if (bySecondary != 0) {
      return bySecondary > 0;
    }
    return a.compareTo(b) < 0; // stable tie-break on slug
  }

  /// Pointwise diff repaint, mirroring the buildings path: a summaries refresh
  /// repaints ONLY the districts whose leader color actually changed (usually
  /// 0–2) instead of a full removeAll + ~413-polygon re-add storm through the
  /// bridge on every poll.
  Future<void> _redrawDistricts(TifoDistrictsState districtsState) async {
    final manager = _districtsManager;
    if (manager == null || districtsState.districts.isEmpty || _lod == _TifoLod.cluster) {
      return; // the cluster tier owns this manager — region silhouette only
    }
    try {
      final controller = await ref.read(dgisControllerProvider.future);
      // Re-check after the await: `dgisControllerProvider` can suspend long
      // enough for a zoom gesture to hand the manager over to the cluster
      // tier, and two tiers must never share it.
      if (!state || _lod == _TifoLod.cluster) {
        return;
      }
      final toAdd = <Polygon>[];
      final toRemove = <String>[];
      final exp = _gridExponent();
      var culled = 0;
      var refined = 0;
      var srcPoints = 0;
      var outPoints = 0;
      for (final district in districtsState.districts) {
        if (!_districtInView(district)) {
          // Off-screen: not drawn, and not recolored either. Nothing is
          // removed, so a district already on the map stays there; when a pan
          // brings it back into view the fill diff below repaints it if its
          // leader changed in the meantime.
          culled++;
          continue;
        }
        final summary = districtsState.summaries[district.id];
        // leaderColor is server-side paint-ready — the leader's hex OR the
        // neutral palette color — so use it directly (fallback grey if absent).
        final baseArgb = summary?.leaderColorArgb ?? _neutralDistrictArgb;
        final fill = (baseArgb & 0x00FFFFFF) | 0xE6000000;
        final prev = _drawnDistrictFill[district.id];
        // A district first painted at the region-wide zoom carries coarse
        // geometry; zooming in re-adds it at the finer grid so it never looks
        // blocky. The narrower viewport is what keeps this cheap — by the time
        // fine precision matters, culling has cut the set to a screenful.
        final refine = prev != null && _coarserThan(_drawnDistrictExp[district.id], exp);
        if (prev == fill && !refine) {
          continue; // unchanged, and precise enough → keep the drawn polygons
        }
        if (refine) {
          refined++;
        }
        if (prev != null) {
          final rings = _drawnDistrictRings[district.id] ?? 0;
          for (var i = 0; i < rings; i++) {
            toRemove.add('tifo-dist:${district.id}#$i'); // recolor → replace
          }
        }
        final rings = _ringsFor(district, exp);
        for (var i = 0; i < rings.length; i++) {
          srcPoints += district.rings[i].length;
          outPoints += rings[i].length;
          toAdd.add(
            Polygon(
              id: 'tifo-dist:${district.id}#$i',
              onTap: () => _onDistrictTap(district),
              options: PolygonOptionsMessage(
                contours: [PolylineGeometryMessage(points: rings[i])],
                color: fill,
                strokeColor: (baseArgb & 0x00FFFFFF) | 0xCC000000,
                strokeWidth: 1.5,
              ),
            ),
          );
        }
        _drawnDistrictFill[district.id] = fill;
        _drawnDistrictRings[district.id] = rings.length;
        _drawnDistrictExp[district.id] = exp;
      }
      if (toRemove.isNotEmpty) {
        await Future.wait(toRemove.map((id) => controller.removePolygon(id, fromManager: manager)));
      }
      if (toAdd.isNotEmpty) {
        // Timed because this bulk add is now the only thing left between a
        // zoom-out and the mosaic appearing — geometry comes from memory and
        // the standings no longer block the paint.
        final sw = Stopwatch()..start();
        await _addChunked(controller, toAdd, manager);
        logger.log(
          '[tifo-map] districts diff: ${toAdd.length} polygons in ${sw.elapsedMilliseconds}ms, '
          'grid 2^$exp cut $srcPoints→$outPoints pts, '
          '$culled/${districtsState.districts.length} culled, $refined refined',
        );
      }
      // Recorded here rather than in `_applyForViewport`, because the district
      // layer also gets painted straight off the provider listener — geometry
      // landing from the enable-time prefetch while the player already sits at
      // this tier. Leaving the bookkeeping to the viewport path would let that
      // paint go unrecorded, and the next camera move would then read
      // "nothing drawn", clear the layer and re-add all ~413 polygons.
      _drawnDistrictsLod = _TifoLod.districts;
    } catch (error, stackTrace) {
      logger.log('[tifo-map] districts redraw failed: $error\n$stackTrace');
    }
  }

  /// Border colour for a TIFO polygon: its own fill taken a few steps darker
  /// and fully opaque, so the outline reads against the fill it encloses.
  static int _borderArgb(int baseArgb) {
    final r = ((baseArgb >> 16) & 0xFF) * _borderShade;
    final g = ((baseArgb >> 8) & 0xFF) * _borderShade;
    final b = (baseArgb & 0xFF) * _borderShade;
    return _polygonAlpha | (r.round() << 16) | (g.round() << 8) | b.round();
  }

  /// [kTifoRegionPolygons] as bridge contours, built once — the source is a
  /// compile-time constant, so there is nothing to invalidate.
  ///
  /// Outer index is the polygon, inner list its contours: index 0 the outer
  /// ring, the rest holes. Nothing is smoothed here, unlike the 21-vertex
  /// placeholder this replaced — that was a crude sketch that needed rounding
  /// to stop reading as a shard, whereas these 2252 vertices ARE the
  /// administrative boundary, and corner-cutting would only misplace it.
  static List<List<PolylineGeometryMessage>>? _regionContours;

  static List<List<PolylineGeometryMessage>> _regionGeometry() => _regionContours ??= [
    for (final polygon in kTifoRegionPolygons)
      [
        for (final ring in polygon)
          PolylineGeometryMessage(
            points: [
              for (final (latitude, longitude) in ring) GeoPointMessage(latitude: latitude, longitude: longitude),
            ],
          ),
      ],
  ];

  /// Cluster tier: one polygon over the whole season region, tinted with the
  /// season leader's color (neutral until standings say otherwise).
  ///
  /// Geometry is bundled, so this needs no network at all — a repaint only
  /// happens when the leader's color actually changes, which is why the fill
  /// is diffed against [_drawnRegionFill] instead of blindly re-adding.
  Future<void> _redrawRegion(TifoDistrictsState districtsState) async {
    final manager = _districtsManager;
    if (manager == null) {
      return;
    }
    if (_lod != _TifoLod.cluster) {
      return; // only the cluster tier shows the region
    }
    final baseArgb = _seasonLeaderColor(districtsState) ?? _neutralDistrictArgb;
    final fill = (baseArgb & 0x00FFFFFF) | _polygonAlpha;
    if (_drawnRegionFill == fill) {
      return; // already painted in this color
    }
    try {
      final controller = await ref.read(dgisControllerProvider.future);
      // Same reasoning as `_redrawDistricts`: the tier may have changed under
      // this await, and the region must not outlive the cluster zoom.
      if (!state || _lod != _TifoLod.cluster) {
        return;
      }
      final geometry = _regionGeometry();
      if (_drawnRegionFill != null) {
        await Future.wait([
          for (var i = 0; i < geometry.length; i++) controller.removePolygon(_regionPolygonId(i), fromManager: manager),
        ]);
        _drawnRegionFill = null;
      }
      await _addChunked(controller, [
        for (var i = 0; i < geometry.length; i++)
          Polygon(
            id: _regionPolygonId(i),
            options: PolygonOptionsMessage(
              // Contour 0 is the outer ring, the rest are holes — the region has
              // three enclaves, and passing them through means they read as
              // holes instead of being painted over.
              contours: geometry[i],
              color: fill,
              // This is the only outline on screen at this zoom, so it carries
              // the region's shape on its own: a darker shade of the fill rather
              // than the fill's own hue at lower alpha, and wider than the
              // district borders.
              strokeColor: _borderArgb(baseArgb),
              strokeWidth: 3,
            ),
          ),
      ], manager);
      _drawnRegionFill = fill;
      _drawnDistrictsLod = _TifoLod.cluster;
      logger.log(
        '[tifo-map] region painted (${geometry.length} polygons, '
        'fill 0x${fill.toRadixString(16)}, border 0x${_borderArgb(baseArgb).toRadixString(16)})',
      );
    } catch (error, stackTrace) {
      logger.log('[tifo-map] region redraw failed: $error\n$stackTrace');
    }
  }

  /// Every polygon id the district mosaic currently owns. Lets a tier swap
  /// remove exactly the outgoing tier's objects AFTER the incoming one is
  /// painted, instead of `removeAllPolygons` up front — both district tiers
  /// share one manager, so clearing first is what left the player staring at a
  /// bare map for as long as the new tier took to cross the bridge.
  List<String> _districtPolygonIds() => [
    for (final entry in _drawnDistrictRings.entries)
      for (var i = 0; i < entry.value; i++) 'tifo-dist:${entry.key}#$i',
  ];

  Future<void> _removeDistrictPolygons(List<String> ids) async {
    if (ids.isEmpty) {
      return;
    }
    final manager = _districtsManager;
    if (manager == null) {
      return;
    }
    try {
      final controller = await ref.read(dgisControllerProvider.future);
      await Future.wait(ids.map((id) => controller.removePolygon(id, fromManager: manager)));
    } catch (error) {
      logger.log('[tifo-map] stale district removal failed: $error');
    }
  }

  Future<void> _clearDistricts() async {
    _drawnDistrictFill.clear();
    _drawnDistrictRings.clear();
    _drawnDistrictExp.clear();
    _drawnRegionFill = null;
    final manager = _districtsManager;
    if (manager == null) {
      return;
    }
    try {
      final controller = await ref.read(dgisControllerProvider.future);
      await controller.removeAllPolygons(fromManager: manager);
    } catch (_) {}
  }

  /// District details sheet (BRD US-06, Figma node 696:119272). The summary is
  /// read at TAP time — unchanged polygons keep their original onTap closure
  /// across diff repaints, so a captured summary would go stale.
  void _onDistrictTap(TifoDistrict district) {
    final context = rootNavigatorKey.currentContext;
    if (context == null || !_acquireSheetGate()) {
      return;
    }
    final summary = ref.read(tifoDistrictsProvider).summaries[district.id];
    unawaited(
      showTifoDistrictSheet(context, district: district, summary: summary).whenComplete(() => _sheetShowing = false),
    );
  }

  void _teardown() {
    _debounce?.cancel();
    unawaited(_visibleSub?.cancel());
  }
}

final tifoBuildingsMapLayerProvider = NotifierProvider<TifoBuildingsMapLayer, bool>(TifoBuildingsMapLayer.new);
