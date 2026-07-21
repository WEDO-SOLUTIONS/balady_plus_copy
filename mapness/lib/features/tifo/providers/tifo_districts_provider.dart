import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/data/tifo_api.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';

@immutable
class TifoDistrictsState {
  const TifoDistrictsState({
    this.districts = const [],
    this.summaries = const {},
    this.isLoading = false,
    this.error,
  });

  /// Geometry, fetched once.
  final List<TifoDistrict> districts;

  /// Standings keyed by district id (polled).
  final Map<String, TifoDistrictSummary> summaries;
  final bool isLoading;
  final String? error;

  bool get hasGeometry => districts.isNotEmpty;

  TifoDistrictsState copyWith({
    List<TifoDistrict>? districts,
    Map<String, TifoDistrictSummary>? summaries,
    bool? isLoading,
    Object? error = _sentinel,
  }) => TifoDistrictsState(
    districts: districts ?? this.districts,
    summaries: summaries ?? this.summaries,
    isLoading: isLoading ?? this.isLoading,
    error: identical(error, _sentinel) ? this.error : error as String?,
  );

  static const Object _sentinel = Object();
}

/// Low-zoom district layer data: geometry (loaded once) merged with standings
/// (refreshable). Kept separate from the buildings provider because the two
/// render at different zoom levels.
class TifoDistrictsController extends Notifier<TifoDistrictsState> {
  @override
  TifoDistrictsState build() => const TifoDistrictsState();

  TifoApi get _api => ref.read(tifoApiProvider);

  /// Loads geometry (only if not already cached) and refreshes standings.
  Future<void> ensureLoaded() async {
    if (state.isLoading) {
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      final districts = state.hasGeometry ? state.districts : await _api.getDistricts();
      final summaries = await _api.getDistrictsSummary();
      state = state.copyWith(districts: districts, summaries: summaries, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e is TifoApiException ? e.message : e.toString());
    }
  }

  /// Refresh only the standings (e.g. after a capture) without refetching
  /// geometry.
  Future<void> refreshSummaries() async {
    try {
      state = state.copyWith(summaries: await _api.getDistrictsSummary());
    } catch (_) {
      // Keep stale standings.
    }
  }
}

final tifoDistrictsProvider =
    NotifierProvider<TifoDistrictsController, TifoDistrictsState>(TifoDistrictsController.new);
