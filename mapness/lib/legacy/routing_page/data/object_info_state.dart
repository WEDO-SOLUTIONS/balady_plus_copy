import 'package:dgis_map/library.dart';

class ObjectInfoState {
  const ObjectInfoState({
    required this.dgisObjectId,
    required this.latLng,
  });

  final DgisObjectId dgisObjectId;
  final LatLng latLng;
}
