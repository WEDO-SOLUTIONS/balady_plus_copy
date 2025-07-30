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

@riverpod
class BssService extends _$BssService {
  int ordinalId = 0;

  @override
  void build() {}

  Future<void> sendEvent(BssRequest request) async {
    final visibleRect = ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect;

    try {
      final dio = await ref.read(bssDioProvider.future);
      final common = await ref.read(bssCommonProvider.future);
      var requestWithRegion = request;
      if (request.payload?.placeItem != null) {
        final searchRegion = await SearchRegionService.instance.getRegion(
          latitude: ((visibleRect?.northEastLat ?? 0) + (visibleRect?.southWestLat ?? 0)) / 2,
          longitude: ((visibleRect?.northEastLon ?? 0) + (visibleRect?.southWestLon ?? 0)) / 2,
        );
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
        map: visibleRect?.toBssMap() ?? emptyBssMap,
      );
      debugPrint('BSS REQUEST: $requestJson');
      await dio.post('/bss/3', data: requestJson);
      ordinalId++;
    } catch (e) {
      debugPrint('Error sending event: $e');
    }
  }
}
