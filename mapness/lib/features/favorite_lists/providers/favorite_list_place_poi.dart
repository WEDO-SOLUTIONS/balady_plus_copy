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
// todo(claude): remove this file?
Future<DirectoryObjectMessage?> favoriteListPlacePoi(Ref ref, int objectId) async {
  final controller = await ref.watch(dgisControllerProvider.future);
  try {
    return await controller
        .searchByObjectId(DgisObjectIdMessage(objectId: objectId, entranceId: 0))
        .timeout(const Duration(seconds: 10));
  } catch (e) {
    rethrow;
  }
}
