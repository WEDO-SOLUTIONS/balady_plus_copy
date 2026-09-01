import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/data/tifo_api.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

@immutable
class TifoDistrictsState {
  const TifoDistrictsState({
    this.districts = const [],
    this.summaries = const {},
    this.isLoadingGeometry = false,
    this.isLoadingSummaries = false,
    this.error,
  });

  /// Geometry, fetched once.
  final List<TifoDistrict> districts;

  /// Standings keyed by district id (polled).
  final Map<String, TifoDistrictSummary> summaries;

  /// `GET /districts` in flight — the one-off geometry payload.
  final bool isLoadingGeometry;

  /// `GET /districts/summary` in flight — the live standings.
  final bool isLoadingSummaries;
  final String? error;

  bool get isLoading => isLoadingGeometry || isLoadingSummaries;

  bool get hasGeometry => districts.isNotEmpty;

  TifoDistrictsState copyWith({
    List<TifoDistrict>? districts,
    Map<String, TifoDistrictSummary>? summaries,
    bool? isLoadingGeometry,
    bool? isLoadingSummaries,
    Object? error = _sentinel,
  }) => TifoDistrictsState(
    districts: districts ?? this.districts,
    summaries: summaries ?? this.summaries,
    isLoadingGeometry: isLoadingGeometry ?? this.isLoadingGeometry,
    isLoadingSummaries: isLoadingSummaries ?? this.isLoadingSummaries,
    error: identical(error, _sentinel) ? this.error : error as String?,
  );

  static const Object _sentinel = Object();
}

/// Low-zoom district layer data, split into two independently-loaded halves:
///
///   * **geometry** (`GET /districts`, ~413 polygons) is static for the whole
///     season, so it is fetched at most once per app run and then served from
///     memory — [ensureGeometry];
///   * **standings** (`GET /districts/summary`) change constantly and only
///     pick each polygon's tint, so they are always refetched —
///     [refreshSummaries].
///
/// Splitting them is what lets the map paint districts from cache on the frame
/// the player zooms out and recolor them when the standings answer, instead of
/// showing nothing until both requests are done. [prefetch] warms both up
/// front (called when the TIFO layer turns on).
///
/// Kept separate from the buildings provider because the two render at
/// different zoom levels.
class TifoDistrictsController extends Notifier<TifoDistrictsState> {
  /// In-flight de-duplication: the enable-time prefetch and a zoom-out that
  /// arrives while it runs must share one round-trip, not race two.
  Future<void>? _geometryRequest;
  Future<void>? _summariesRequest;

  @override
  TifoDistrictsState build() => const TifoDistrictsState();

  TifoApi get _api => ref.read(tifoApiProvider);

  /// Loads the district geometry unless it is already cached. Cheap to call on
  /// every viewport event — a warm cache returns without touching the network.
  Future<void> ensureGeometry() {
    if (state.hasGeometry) {
      return Future<void>.value();
    }
    return _geometryRequest ??= _loadGeometry();
  }

  /// Refreshes the standings (e.g. on entering the district tier, or after a
  /// capture) without refetching geometry.
  Future<void> refreshSummaries() => _summariesRequest ??= _loadSummaries();

  /// Warms both halves in parallel, for the layer-enable path: by the time the
  /// player pinches out to the district tier, geometry is already in memory.
  Future<void> prefetch() => Future.wait([ensureGeometry(), refreshSummaries()]);

  Future<void> _loadGeometry() async {
    state = state.copyWith(isLoadingGeometry: true, error: null);
    try {
      final districts = await _api.getDistricts();
      if (!ref.mounted) {
        return;
      }
      logger.log('[tifo] districts geometry loaded: ${districts.length}');
      state = state.copyWith(districts: districts, isLoadingGeometry: false);
    } catch (e) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        isLoadingGeometry: false,
        error: e is TifoApiException ? e.message : e.toString(),
      );
    } finally {
      // Cleared even on failure, so the next zoom-out retries instead of
      // awaiting a future that already completed.
      _geometryRequest = null;
    }
  }

  Future<void> _loadSummaries() async {
    state = state.copyWith(isLoadingSummaries: true);
    try {
      final summaries = await _api.getDistrictsSummary();
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(summaries: summaries, isLoadingSummaries: false);
    } catch (_) {
      // Keep stale standings — a dropped poll must not un-color the map.
      if (ref.mounted) {
        state = state.copyWith(isLoadingSummaries: false);
      }
    } finally {
      _summariesRequest = null;
    }
  }
}

final tifoDistrictsProvider = NotifierProvider<TifoDistrictsController, TifoDistrictsState>(
  TifoDistrictsController.new,
);
