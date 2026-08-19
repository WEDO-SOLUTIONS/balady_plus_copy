import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/data/tifo_api.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
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
    try {
      final items = await ref.read(tifoApiProvider).getBuildings(bbox, cancelToken: token);
      if (token.isCancelled) {
        return;
      }
      logger.log('[tifo] fetched ${items.length} buildings for bbox $bbox');
      final merged = Map<String, TifoBuilding>.of(state.byId);
      for (final b in items) {
        merged[b.id] = b;
      }
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
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      if (token.isCancelled) {
        return;
      }
      logger.log('[tifo] buildings fetch error for $bbox: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
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
      ..[buildingId] = existing.copyWith(ownerClubSlug: clubSlug, savedScore: savedScore);
    state = state.copyWith(byId: updated);
  }

  /// Drops the viewport set (map layer disabled). Geometry cache is kept so a
  /// re-enable doesn't re-fetch everything.
  void clearViewport() => state = state.copyWith(visibleIds: const {});

  void clear() => state = const TifoBuildingsState();
}

final tifoBuildingsProvider = NotifierProvider<TifoBuildingsController, TifoBuildingsState>(
  TifoBuildingsController.new,
);
