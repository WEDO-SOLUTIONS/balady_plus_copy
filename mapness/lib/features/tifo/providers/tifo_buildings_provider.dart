import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/balady_analytics/events/tifo_events.dart';
import 'package:mapness/features/tifo/data/tifo_api.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/tifo_buildings_map_layer.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

@immutable
class TifoBuildingsState {
  const TifoBuildingsState({
    this.byId = const {},
    this.visibleIds = const {},
    this.isLoading = false,
    this.error,
  });

  /// Geometry+state cache of every building seen so far, keyed by id. Geometry
  /// is static, so entries are never dropped — the polling service just
  /// refreshes their ownership/status in place.
  final Map<String, TifoBuilding> byId;

  /// Ids inside the current viewport (what the map layer should render).
  final Set<String> visibleIds;
  final bool isLoading;
  final String? error;

  /// Buildings currently in the viewport, in cache order.
  Iterable<TifoBuilding> get visible => visibleIds.map((id) => byId[id]).whereType<TifoBuilding>();

  TifoBuildingsState copyWith({
    Map<String, TifoBuilding>? byId,
    Set<String>? visibleIds,
    bool? isLoading,
    Object? error = _sentinel,
  }) => TifoBuildingsState(
    byId: byId ?? this.byId,
    visibleIds: visibleIds ?? this.visibleIds,
    isLoading: isLoading ?? this.isLoading,
    error: identical(error, _sentinel) ? this.error : error as String?,
  );

  static const Object _sentinel = Object();
}

/// Owns the building geometry cache + the current viewport set. Geometry is
/// discovered by [fetchForBbox]; per-building state is refreshed by
/// [refreshVisible] (driven by the polling service) or optimistically by
/// [applyOwnership] after a capture.
class TifoBuildingsController extends Notifier<TifoBuildingsState> {
  CancelToken? _inFlight;
  Duration? _lastFetchDuration;
  DateTime? _lastDataAt;

  /// Backend round-trip of the `/buildings` request behind the cache's newest
  /// entries, or null while nothing has been fetched. Read once by the map
  /// layer for `tifo_surface_viewed`; never logged.
  Duration? get lastFetchDuration => _lastFetchDuration;

  /// When that response finished parsing into [state] — the start of the
  /// render clock the map layer stops on the frame after the polygons are up.
  DateTime? get lastDataAt => _lastDataAt;

  @override
  TifoBuildingsState build() {
    ref.onDispose(() => _inFlight?.cancel('provider disposed'));
    return const TifoBuildingsState();
  }

  /// Fetches buildings for [bbox] (`minLng,minLat,maxLng,maxLat`), cancelling
  /// any previous still-running request so only the latest viewport wins. New
  /// geometry is merged into the cache; [visibleIds] is set to this viewport.
  Future<void> fetchForBbox(String bbox) async {
    _inFlight?.cancel('superseded by newer viewport');
    final token = CancelToken();
    _inFlight = token;

    state = state.copyWith(isLoading: true, error: null);
    final timing = TifoRequestTiming();
    try {
      final items = await ref.read(tifoApiProvider).getBuildings(bbox, cancelToken: token, timing: timing);
      if (token.isCancelled) {
        return;
      }
      // The owner-standing row (TFS 86073) is only as good as the payload: if
      // `/buildings` names that field something `TifoBuilding._parseStandingDays`
      // doesn't know, the row silently never renders again. Log the shortfall so
      // the next person sees the cause instead of the symptom.
      final claimed = items.where((b) => !b.isNeutral).length;
      final withStanding = items.where((b) => b.standingDays != null).length;
      logger.log(
        '[tifo] fetched ${items.length} buildings for bbox $bbox '
        '($claimed claimed, $withStanding with a standing duration)',
      );
      if (claimed > 0 && withStanding == 0) {
        logger.log('[tifo] WARNING: no claimed building carried a standing duration — check the /buildings field name');
      }
      final merged = Map<String, TifoBuilding>.of(state.byId);
      for (final b in items) {
        merged[b.id] = b;
      }
      _lastFetchDuration = timing.total;
      _lastDataAt = DateTime.now();
      state = state.copyWith(
        byId: merged,
        visibleIds: {for (final b in items) b.id},
        isLoading: false,
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        return; // superseded — leave state to the newer request
      }
      logger.log('[tifo] buildings fetch failed (${e.response?.statusCode}) for $bbox: ${e.message}');
      _reportFetchBlocked();
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      if (token.isCancelled) {
        return;
      }
      logger.log('[tifo] buildings fetch error for $bbox: $e');
      _reportFetchBlocked();
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// `tifo_blocked {reason: error, surface: building}` for a `/buildings` fetch that failed
  /// with the layer on: the tier stays empty with nothing on screen saying why. The layer
  /// check below covers toggle-off-mid-flight; [TifoEvents.blocked] debounces a flapping backend.
  void _reportFetchBlocked() {
    if (!ref.read(tifoBuildingsMapLayerProvider)) {
      return;
    }
    unawaited(TifoEvents.blocked(reason: TifoBlockReason.error, surface: TifoSurface.building));
  }

  /// Refreshes ownership/status of the visible buildings via
  /// `POST /buildings/by-ids` (geometry untouched). Called on a timer by the
  /// polling service; failures are swallowed so a dropped poll keeps stale
  /// state rather than clearing the map.
  Future<void> refreshVisible() async {
    final ids = state.visibleIds.toList();
    if (ids.isEmpty) {
      return;
    }
    try {
      final fresh = await ref.read(tifoApiProvider).getBuildingsByIds(ids);
      if (fresh.isEmpty) {
        return;
      }
      final merged = Map<String, TifoBuilding>.of(state.byId);
      for (final b in fresh) {
        merged[b.id] = b;
      }
      state = state.copyWith(byId: merged);
    } catch (_) {
      // Keep stale state.
    }
  }

  /// Locally recolors a building after a capture, so the map reflects the new
  /// owner immediately without waiting for the next poll.
  void applyOwnership({required String buildingId, required String clubSlug, int? savedScore}) {
    final existing = state.byId[buildingId];
    if (existing == null) {
      return;
    }
    final updated = Map<String, TifoBuilding>.of(state.byId)
      // standingDays back to 0: the owner just changed, so the previous
      // holder's duration must not survive the recolor and show up in the
      // sheet as if the new owner had held it that long. scoreToBeat mirrors
      // savedScore: the capturing score is what the next challenger has to
      // beat; the poller reconciles from the server on its next tick anyway.
      ..[buildingId] = existing.copyWith(
        ownerClubSlug: clubSlug,
        savedScore: savedScore,
        scoreToBeat: savedScore,
        standingDays: 0,
      );
    state = state.copyWith(byId: updated);
  }

  /// Drops the viewport set (map layer disabled). Geometry cache is kept so a
  /// re-enable doesn't re-fetch everything.
  void clearViewport() => state = state.copyWith(visibleIds: const {});

  void clear() => state = const TifoBuildingsState();

  /// Language switch (BALADY-3959): building names ride inside the cached
  /// `/buildings` payloads, so the cache is dropped and the map layer
  /// re-fetches the viewport in the new language (see
  /// `TifoBuildingsMapLayer.relocalize`). A viewport request still in flight
  /// was built with the old `locale` and is cancelled. The on-screen entries
  /// are kept until that refetch replaces them, so the polygons do not blink
  /// off; everything off-screen is re-fetched when the camera gets back to it.
  void resetForLocale() {
    _inFlight?.cancel('language changed');
    _inFlight = null;
    final byId = state.byId;
    state = state.copyWith(
      byId: {
        for (final id in state.visibleIds)
          if (byId[id] case final building?) id: building,
      },
      isLoading: false,
    );
  }
}

final tifoBuildingsProvider = NotifierProvider<TifoBuildingsController, TifoBuildingsState>(
  TifoBuildingsController.new,
);
