import 'dart:async';
import 'dart:collection';

import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/features/search/providers/search_region.dart';
import 'package:mapness/shared/providers/analytic/models/bss_common.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/map_ext.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_entity.dart';
import 'package:rxdart/rxdart.dart';

class BssService {
  /// The one instance for the whole app. Dart initialises a `static final`
  /// on first access, so this stays as lazy as the getter it replaces while
  /// no longer looking like a factory method.
  static final BssService instance = BssService._internal();

  BssService._internal();

  int ordinalId = 0;
  final Duration _sendInterval = const Duration(seconds: 5);
  final Queue<BssRequest> _eventStack = Queue<BssRequest>();
  Timer? _sendTimer;

  // Dependencies that will be injected via init method
  Dio? _dio;
  BssCommon? _common;
  ValueStream<VisibleRectEvent?>? _visibleRectStream;

  /// Initialize the service with all required dependencies
  void init({
    required Dio dio,
    required BssCommon common,
    required ValueStream<VisibleRectEvent?> visibleRectStream,
  }) {
    _dio = dio;
    _common = common;
    _visibleRectStream = visibleRectStream;
    _startEventSendingTimer();
  }

  void _startEventSendingTimer() {
    _sendTimer?.cancel();
    _sendTimer = Timer.periodic(_sendInterval, (_) {
      _processEventStack();
    });
  }

  void _processEventStack() {
    if (_eventStack.isEmpty) {
      return; // No events to send
    }

    // Process all events in the stack
    final eventsToSend = List<BssRequest>.from(_eventStack);
    _eventStack.clear();

    // Send each event
    _sendEventImmediately(eventsToSend);
  }

  Future<void> _sendEventImmediately(List<BssRequest> requests) async {
    if (_dio == null || _common == null || _visibleRectStream == null) {
      if (kDebugMode) {
        debugPrint('BssService not initialized. Call init() first.');
      }
      return;
    }

    final visibleRect = _visibleRectStream!.valueOrNull?.visibleRect;

    try {
      if (visibleRect == null) {
        throw Exception('Visible rect is null');
      }

      final List<Map<String, dynamic>> requestJsons = [];
      final searchRegion = await SearchRegionService.instance.getRegion(
        latitude: (visibleRect.northEastLat + visibleRect.southWestLat) / 2,
        longitude: (visibleRect.northEastLon + visibleRect.southWestLon) / 2,
      );
      for (final request in requests) {
        var requestWithRegion = request;
        if (request.payload?.placeItem != null) {
          requestWithRegion = request.copyWith(
            payload: request.payload?.copyWith(
              placeItem: request.payload?.placeItem?.copyWith(
                entity: request.payload?.placeItem?.entity.copyWith(
                  segmentInfo: searchRegion != null ? BssSegmentInfo(segmentId: searchRegion.id) : null,
                ),
              ),
            ),
          );
        }

        final requestJson = requestWithRegion.toJson(
          eventOrdinal: ordinalId,
          common: _common!,
          map: visibleRect.toBssMap(),
        );
        requestJsons.add(requestJson);
      }
      if (kDebugMode) {
        debugPrint('BSS REQUEST: $requestJsons');
      }
      final validateResponse = await _dio!.post('/bss/validate/3', data: requestJsons);
      if (kDebugMode) {
        debugPrint('BSS VALIDATE RESPONSE: $validateResponse');
      }
      await _dio!.post('/bss/3', data: requestJsons);
      ordinalId++;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error sending event: $e');
      }
    }
  }

  Future<void> sendEvent(BssRequest request) async {
    // Add event to the stack instead of sending immediately
    _eventStack.add(request);
  }

  void dispose() {
    _sendTimer?.cancel();
  }
}
