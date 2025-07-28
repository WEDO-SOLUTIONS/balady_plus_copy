import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_entity.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';

extension BssPlaceItemExt on DirectoryObjectMessage {
  BssPlaceItem? toBss(int index) {
    if (id?.objectId == null) {
      return null;
    }
    return BssPlaceItem(
      entity: BssEntity(
        id: id!.objectId.toString(),
        type: types.firstOrNull?.type.name ?? 'unknown',
      ),
      position: index + 1,
      geoPosition: markerPosition != null
          ? BssGeoPosition(
              latitude: markerPosition!.latitude,
              longitude: markerPosition!.longitude,
            )
          : null,
      contextRubric: rubricIds.map((e) => e.toString()).toList(),
      adsSearch: false,
    );
  }
}

extension BssPlaceItemExt2 on ItemMarkerInfoMessage? {
  BssPlaceItem? toBss(int index) {
    final data = this;
    if (data == null) {
      return null;
    }
    return BssPlaceItem(
      entity: BssEntity(
        id: data.objectId!.objectId.toString(),
        type: '',
      ),
      position: index + 1,
      geoPosition: BssGeoPosition(
        latitude: data.geoPoint.latitude,
        longitude: data.geoPoint.longitude,
      ),
      contextRubric: data.rubricIds?.map((e) => e.toString()).toList(),
      adsSearch: false,
    );
  }
}
