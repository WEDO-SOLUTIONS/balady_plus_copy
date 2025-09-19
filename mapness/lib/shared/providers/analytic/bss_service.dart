import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:mapness/features/search/providers/search_region.dart';
import 'package:mapness/shared/providers/analytic/bss_common.dart';
import 'package:mapness/shared/providers/analytic/bss_dio.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/map_ext.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_entity.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bss_service.g.dart';

@Riverpod(keepAlive: true)
class BssService extends _$BssService {
  int ordinalId = 0;
  final Duration _sendInterval = const Duration(seconds: 5);
  final Queue<BssRequest> _eventStack = Queue<BssRequest>();
  Timer? _sendTimer;

  @override
  void build() {
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
    final visibleRect = ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect;

    try {
      if (visibleRect == null) {
        throw Exception('Visible rect is null');
      }

      final dio = await ref.read(bssDioProvider.future);
      final common = await ref.read(bssCommonProvider.future);
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
                entity: request.payload?.placeItem?.entity
                    .copyWith(segmentInfo: searchRegion != null ? BssSegmentInfo(segmentId: searchRegion.id) : null),
              ),
            ),
          );
        }

        final requestJson = requestWithRegion.toJson(
          eventOrdinal: ordinalId,
          common: common,
          map: visibleRect.toBssMap(),
        );
        requestJsons.add(requestJson);
      }
      debugPrint('BSS REQUEST: $requestJsons');
      final validateResponse = await dio.post('/bss/validate/3', data: requestJsons);
      debugPrint('BSS VALIDATE RESPONSE: $validateResponse');
      await dio.post('/bss/3', data: requestJsons);
      ordinalId++;
    } catch (e) {
      debugPrint('Error sending event: $e');
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
