import 'package:dgis_map/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapness/features/parking_spot/model/parking_store_model.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

extension ParkingStoreModelExt on ParkingStoreModel {
  DirectoryObjectMessage convertToDirectoryObject(BuildContext context) => DirectoryObjectMessage(
        types: [],
        title: context.l10n.yourParkingSpot,
        titleAddition: '',
        subtitle: address,
        about: '',
        attributes: [],
        contextAttributes: [],
        contactInfos: [],
        buildingInfo: BuildingInfoMessage(),
        entrances: [],
        rubricIds: [],
        routeInfos: [],
        group: [],
        id: DgisObjectIdMessage(
          objectId: parkingObjectId,
          entranceId: 0,
        ),
        markerPosition: GeoPointWithElevationMessage(
          latitude: lat,
          longitude: lon,
          elevation: 0,
        ),
      );
}
