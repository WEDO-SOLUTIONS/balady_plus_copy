import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:mapness/features/road_events/data/road_events_datasource.dart';
import 'package:mapness/features/road_events/data/road_events_dio.dart';
import 'package:mapness/features/road_events/domain/road_event.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'road_events_repository.g.dart';

/// Extra debounce on top of the dgis controller's own 1s, coalescing rapid
/// pinch/pan transitions before hitting the Road Event Service.
const Duration _viewportDebounce = Duration(milliseconds: 400);

/// Reasonable padding for the viewport: 25% of the visible rect on each side.
const double _bboxGap = 0.25;

@Riverpod(keepAlive: true)
class RoadEventsRepository extends _$RoadEventsRepository {
  CancelToken? _cancelToken;
  StreamSubscription? _subscription;

  @override
  Future<List<RoadEvent>> build() async {
    final dio = await ref.watch(roadEventsDioProvider.future);
    final datasource = RoadEventsDatasource(dio: dio);
    final controller = ref.watch(dgisControllerProvider.notifier);

    ref.onDispose(() {
      final token = _cancelToken;
      if (token != null && !token.isCancelled) {
        token.cancel('RoadEventsRepository disposed');
      }
      _subscription?.cancel();
    });

    _subscription?.cancel();
    _subscription = controller.visibleRectSubject
        .whereNotNull()
        .debounceTime(_viewportDebounce)
        .distinct(_sameViewport)
        .listen((event) async {
          await _refresh(datasource, event.visibleRect);
        });

    return const [];
  }

  Future<void> _refresh(RoadEventsDatasource datasource, VisibleRect visibleRect) async {
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
      state = AsyncData(events);
    } on Object {
      if (cancel.isCancelled) {
        return;
      }
      // Keep prior data on transient failure to avoid a blank flash.
    }
  }

  /// Optimistically inserts a just-created event so it shows up immediately,
  /// without waiting for the next bbox tick.
  void addLocal(RoadEvent event) {
    final current = state.value ?? const [];
    state = AsyncData([...current.where((e) => e.id != event.id), event]);
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
