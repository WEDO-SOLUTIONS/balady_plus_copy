import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/balady_analytics/events/tifo_events.dart';
import 'package:mapness/features/tifo/data/tifo_api.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/tifo_buildings_map_layer.dart';
import 'package:mapness/shared/providers/app_language.dart';
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

  /// Round-trip of every district request so far — geometry and standings together, since the
  /// tier paints once both have answered. Read once, at first paint, for
  /// `tifo_surface_viewed`; null while served entirely from memory. Never logged.
  final TifoRequestTiming _timing = TifoRequestTiming();

  DateTime? _lastDataAt;

  /// Backend locale the cached geometry was fetched with. District *names*
  /// ride inside that otherwise once-per-run payload, so without this the
  /// sheet keeps showing the previous language until an app restart
  /// (BALADY-3959). Compared against [_locale] on every [ensureGeometry].
  String? _geometryLocale;

  /// See [_timing].
  Duration? get requestDuration => _timing.total;

  /// When the payload that gates the mosaic (`/districts` geometry) finished
  /// parsing into [state] — the start of the render clock. Standings do not
  /// move it: they only re-tint polygons that are already on the map.
  DateTime? get lastDataAt => _lastDataAt;

  @override
  TifoDistrictsState build() => const TifoDistrictsState();

  TifoApi get _api => ref.read(tifoApiProvider);

  /// Same code `TifoApi` puts on the query string — read per call, never
  /// watched, so a language switch does not rebuild the notifier (and wipe
  /// the geometry cache) behind the map's back.
  String get _locale => ref.read(appLanguageProvider).baladyCompat;

  /// Loads the district geometry unless it is already cached in the current
  /// app language. Cheap to call on every viewport event — a warm cache
  /// returns without touching the network.
  Future<void> ensureGeometry() {
    if (state.hasGeometry && _geometryLocale == _locale) {
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

  /// Re-fetches both halves in the app's current language, called from
  /// `AppLanguage.update` alongside the roster refresh. Named strings only
  /// live in the payloads, so nothing short of a refetch re-localizes them.
  /// No-op until something has been loaded: an untouched cache is filled by
  /// the next [ensureGeometry] in the new locale anyway.
  Future<void> forceRefresh() {
    if (!state.hasGeometry && state.summaries.isEmpty) {
      return Future<void>.value();
    }
    // Polygons stay on screen while the new payload lands — only the names
    // are stale, the rings and the standings are locale-independent.
    return Future.wait([ensureGeometry(), refreshSummaries()]);
  }

  Future<void> _loadGeometry() async {
    // Captured before the round-trip: a switch made while it is in flight must
    // leave the cache marked with the locale the response actually carries, so
    // the next `ensureGeometry` refetches instead of trusting it.
    final locale = _locale;
    state = state.copyWith(isLoadingGeometry: true, error: null);
    try {
      final districts = await _api.getDistricts(timing: _timing);
      if (!ref.mounted) {
        return;
      }
      logger.log('[tifo] districts geometry loaded: ${districts.length} (locale: $locale)');
      _lastDataAt = DateTime.now();
      _geometryLocale = locale;
      state = state.copyWith(districts: districts, isLoadingGeometry: false);
    } catch (e) {
      if (!ref.mounted) {
        return;
      }
      // `tifo_blocked {reason: error, surface: district}`: without geometry the mosaic paints
      // nothing — the one district failure worth an event (a dropped summary poll self-heals
      // every 20 s, see [_loadSummaries]). Layer-off excluded: a fetch can outlive the toggle.
      if (ref.read(tifoBuildingsMapLayerProvider)) {
        unawaited(TifoEvents.blocked(reason: TifoBlockReason.error, surface: TifoSurface.district));
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
      final summaries = await _api.getDistrictsSummary(timing: _timing);
      if (!ref.mounted) {
        return;
      }
      // Only when geometry has not answered yet: a standings poll must not
      // restart the render clock of a mosaic that is already painted.
      _lastDataAt ??= DateTime.now();
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
