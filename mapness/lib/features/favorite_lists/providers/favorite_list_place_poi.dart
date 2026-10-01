import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_list_place_poi.g.dart';

/// Fetches a place's directory info by its numeric DGIS object id.
///
/// Calls the SDK directly instead of `pointOfInterestProvider`, which also
/// drops a pin/highlight on the map — side effects that don't belong to a
/// plain text list.
@riverpod
Future<DirectoryObjectMessage?> favoriteListPlacePoi(Ref ref, int objectId) async {
  // Bounded: if the map controller never initializes in this context (e.g. no map widget is
  // currently mounted on the phone screen while this is triggered from a native car-app bridge
  // call), this would otherwise hang forever and, with it, the whole favorite-lists build.
  final controller = await ref.watch(dgisControllerProvider.future).timeout(const Duration(seconds: 5));
  try {
    return await controller
        .searchByObjectId(DgisObjectIdMessage(objectId: objectId, entranceId: 0))
        .timeout(const Duration(seconds: 10));
  } catch (e) {
    rethrow;
  }
}
