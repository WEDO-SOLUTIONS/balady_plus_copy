import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/data/tifo_api.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';

@immutable
class TifoBuildingsState {
  const TifoBuildingsState({
    this.buildings = const {},
    this.isLoading = false,
    this.error,
  });

  /// Currently-known buildings, keyed by building id.
  final Map<String, TifoBuilding> buildings;
  final bool isLoading;
  final String? error;

  TifoBuildingsState copyWith({
    Map<String, TifoBuilding>? buildings,
    bool? isLoading,
    Object? error = _sentinel,
  }) => TifoBuildingsState(
    buildings: buildings ?? this.buildings,
    isLoading: isLoading ?? this.isLoading,
    error: identical(error, _sentinel) ? this.error : error as String?,
  );

  static const Object _sentinel = Object();
}

/// Owns the set of buildings visible in the current viewport. The map layer
/// pushes bbox changes in via [fetchForBbox]; the building sheet reports
/// capture outcomes via [applyOwnership].
class TifoBuildingsController extends Notifier<TifoBuildingsState> {
  CancelToken? _inFlight;

  @override
  TifoBuildingsState build() {
    ref.onDispose(() => _inFlight?.cancel('provider disposed'));
    return const TifoBuildingsState();
  }

  /// Fetches buildings for [bbox] (`minLng,minLat,maxLng,maxLat`), cancelling
  /// any previous still-running request so only the latest viewport wins.
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
      state = state.copyWith(
        buildings: {for (final b in items) b.id: b},
        isLoading: false,
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        return; // superseded — leave state to the newer request
      }
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      if (token.isCancelled) {
        return;
      }
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Locally recolors a building after a capture, so the map reflects the new
  /// owner immediately without waiting for the next viewport refresh.
  void applyOwnership({required String buildingId, required String clubSlug, int? savedScore}) {
    final existing = state.buildings[buildingId];
    if (existing == null) {
      return;
    }
    final updated = Map<String, TifoBuilding>.of(state.buildings)
      ..[buildingId] = existing.copyWith(ownerClubSlug: clubSlug, savedScore: savedScore);
    state = state.copyWith(buildings: updated);
  }

  void clear() => state = const TifoBuildingsState();
}

final tifoBuildingsProvider = NotifierProvider<TifoBuildingsController, TifoBuildingsState>(
  TifoBuildingsController.new,
);
