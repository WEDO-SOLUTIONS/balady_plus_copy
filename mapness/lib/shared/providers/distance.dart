import 'package:dgis_map/library.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'distance.g.dart';

@riverpod
Future<double?> getDistanceToObject(Ref ref, int objectId, {int? entranceId}) async {
  final location = ref.read(locationProvider);
  if (location == null) {
    return null;
  }
  final dgisController = await ref.read(dgisControllerProvider.future);
  final object = await dgisController.searchByObjectId(
    DgisObjectIdMessage(objectId: objectId, entranceId: entranceId ?? 0),
  );

  final markerPosition = object.markerPosition;
  if (markerPosition == null) {
    return null;
  }

  return CommonFunctions.distance(
    location.latitude,
    location.longitude,
    markerPosition.latitude,
    markerPosition.longitude,
  );
}
