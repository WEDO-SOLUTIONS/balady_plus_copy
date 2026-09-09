import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:mapness/features/road_events/data/road_events_datasource.dart';
import 'package:mapness/features/road_events/data/road_events_dio.dart';
import 'package:mapness/features/road_events/domain/road_event.dart';
import 'package:mapness/features/road_events/providers/road_events_config.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/road_event_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'road_events_repository.g.dart';

/// Extra debounce on top of the dgis controller's own 1s, coalescing rapid
/// pinch/pan transitions before hitting the Road Event Service.
const Duration _viewportDebounce = Duration(milliseconds: 400);

/// Reasonable padding for the viewport: 25% of the visible rect on each side.
const double _bboxGap = 0.25;

/// How long an optimistically-added local event is re-merged into each bbox
/// refresh if the server hasn't returned it yet (read-after-write lag).
/// After this, we stop force-including it.
const Duration _pendingLocalGrace = Duration(seconds: 60);

@Riverpod(keepAlive: true)
class RoadEventsRepository extends _$RoadEventsRepository {
  CancelToken? _cancelToken;
  CancelToken? _deltaCancelToken;
  StreamSubscription? _subscription;
  Timer? _pollTimer;

  /// Delta-sync cursor for `fetchChanges` — reset whenever a fresh bbox
  /// snapshot lands, since the cursor and the bbox it was scoped to must stay
  /// in sync (see `_refresh`).
  String? _cursor;

  /// The bbox `_refresh` last fetched successfully — `_poll` scopes its
  /// `fetchChanges` call to it, and won't run before it's set.
  RoadEventsBbox? _lastBbox;

  /// Events inserted via `addLocal` that the server hasn't confirmed yet —
  /// re-merged into each `_refresh` snapshot until confirmed or expired (see
  /// `_pendingLocalGrace`), so a bbox refresh racing the backend's
  /// read-after-write lag can't silently drop a just-created event.
  final Map<String, (RoadEvent event, DateTime addedAt)> _pendingLocalEvents = {};

  @override
  Future<List<RoadEvent>> build() async {
    final isVisible = ref.watch(roadEventSourceControlProvider);
    final config = await ref.watch(roadEventsConfigProvider.future);

    ref.onDispose(() {
      _cancelActiveRequests('RoadEventsRepository disposed');
      _subscription?.cancel();
      _pollTimer?.cancel();
    });

    _subscription?.cancel();
    _pollTimer?.cancel();
    _cancelActiveRequests('road events layer hidden');
    _cursor = null;
    _lastBbox = null;

    if (!isVisible) {
      return state.value ?? const [];
    }

    final dio = await ref.watch(roadEventsDioProvider.future);
    final datasource = RoadEventsDatasource(dio: dio);
    final controller = ref.watch(dgisControllerProvider.notifier);

    _subscription = controller.visibleRectSubject
        .whereNotNull()
        .debounceTime(_viewportDebounce)
        .distinct(_sameViewport)
        .listen((event) async {
          await _refresh(datasource, event.visibleRect);
        });

    _pollTimer = Timer.periodic(config.pollInterval, (_) => unawaited(_poll(datasource)));

    return state.value ?? const [];
  }

  void _cancelActiveRequests(String reason) {
    final token = _cancelToken;
    if (token != null && !token.isCancelled) {
      token.cancel(reason);
    }
    final deltaToken = _deltaCancelToken;
    if (deltaToken != null && !deltaToken.isCancelled) {
      deltaToken.cancel(reason);
    }
  }

  Future<void> _refresh(RoadEventsDatasource datasource, VisibleRect visibleRect) async {
    final oldDeltaToken = _deltaCancelToken;
    if (oldDeltaToken != null && !oldDeltaToken.isCancelled) {
      oldDeltaToken.cancel('superseded by viewport refresh');
    }

    final oldToken = _cancelToken;
    if (oldToken != null && !oldToken.isCancelled) {
      oldToken.cancel('superseded');
    }
    final cancel = _cancelToken = CancelToken();

    final dLat = (visibleRect.northEastLat - visibleRect.southWestLat).abs() * _bboxGap;
    final dLon = (visibleRect.northEastLon - visibleRect.southWestLon).abs() * _bboxGap;
    final bbox = RoadEventsBbox(
      minLng: visibleRect.southWestLon - dLon,
      minLat: visibleRect.southWestLat - dLat,
      maxLng: visibleRect.northEastLon + dLon,
      maxLat: visibleRect.northEastLat + dLat,
    );

    try {
      final events = await datasource.fetchByBbox(bbox: bbox, cancelToken: cancel);
      if (!ref.mounted || cancel.isCancelled || !identical(_cancelToken, cancel)) {
        return;
      }

      final fetchedIds = events.map((e) => e.id).toSet();
      final now = DateTime.now();
      // Confirmed by the server, or given up on after the grace period —
      // either way, stop tracking it.
      _pendingLocalEvents.removeWhere(
        (id, entry) => fetchedIds.contains(id) || now.difference(entry.$2) > _pendingLocalGrace,
      );
      final stillPending = _pendingLocalEvents.values.map((entry) => entry.$1);

      state = AsyncData([...events, ...stillPending]);
      // Fresh full snapshot for this bbox — the delta cursor from the
      // previous bbox is no longer meaningful, restart delta-sync from it.
      _lastBbox = bbox;
      _cursor = null;
    } on Object {
      if (cancel.isCancelled) {
        return;
      }
      // Keep prior data on transient failure to avoid a blank flash.
    }
  }

  /// Polls `/events/changes` for updates since `_cursor`, scoped to the last
  /// bbox `_refresh` fetched — coalesces upserts/removals between viewport
  /// changes without a full bbox re-fetch. No-ops until `_refresh` has run at
  /// least once (nothing to scope the delta to yet).
  Future<void> _poll(RoadEventsDatasource datasource) async {
    final bbox = _lastBbox;
    if (bbox == null) {
      return;
    }

    final oldToken = _deltaCancelToken;
    if (oldToken != null && !oldToken.isCancelled) {
      oldToken.cancel('superseded');
    }
    final cancel = _deltaCancelToken = CancelToken();

    try {
      final page = await datasource.fetchChanges(cursor: _cursor, bbox: bbox, cancelToken: cancel);
      if (!ref.mounted || cancel.isCancelled || !identical(_deltaCancelToken, cancel)) {
        return;
      }
      _mergeChanges(page);
      _cursor = page.nextCursor ?? _cursor;
    } on DioException catch (e) {
      if (cancel.isCancelled) {
        return;
      }
      final status = e.response?.statusCode;
      if (status != null && status >= 400 && status < 500) {
        // The Road Event Service doesn't document a dedicated "stale cursor"
        // error — treat any 4xx as an invalid cursor and restart delta-sync
        // from scratch on the next tick, rather than retrying the same
        // request forever.
        _cursor = null;
      }
      // 5xx/timeout/no-response: transient — retry with the same cursor on
      // the next tick.
    } on Object {
      if (cancel.isCancelled) {
        return;
      }
    }
  }

  /// Applies a delta page to the current list by `id` — upserts overwrite,
  /// removals drop. Safe to call with an empty/idempotent page.
  void _mergeChanges(RoadEventsChangesPage page) {
    if (page.upserts.isEmpty && page.removedIds.isEmpty) {
      return;
    }
    final current = state.value ?? const [];
    final removedIds = page.removedIds.toSet();
    final upsertIds = page.upserts.map((e) => e.id).toSet();
    state = AsyncData([
      ...current.where((e) => !removedIds.contains(e.id) && !upsertIds.contains(e.id)),
      ...page.upserts,
    ]);
  }

  /// Optimistically inserts a just-created event so it shows up immediately,
  /// without waiting for the next bbox tick.
  void addLocal(RoadEvent event) {
    final current = state.value ?? const [];
    state = AsyncData([...current.where((e) => e.id != event.id), event]);
    _pendingLocalEvents[event.id] = (event, DateTime.now());
  }

  /// Merges a refreshed event card (e.g. after `GET /events/{id}`) into the
  /// current list, keeping other markers untouched.
  void updateLocal(RoadEvent event) => addLocal(event);

  static bool _sameViewport(VisibleRectEvent a, VisibleRectEvent b) {
    const epsilon = 0.001;
    final aRect = a.visibleRect;
    final bRect = b.visibleRect;
    return (aRect.northEastLat - bRect.northEastLat).abs() < epsilon &&
        (aRect.northEastLon - bRect.northEastLon).abs() < epsilon &&
        (aRect.southWestLat - bRect.southWestLat).abs() < epsilon &&
        (aRect.southWestLon - bRect.southWestLon).abs() < epsilon;
  }
}
