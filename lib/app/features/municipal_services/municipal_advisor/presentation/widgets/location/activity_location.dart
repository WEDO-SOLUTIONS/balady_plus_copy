import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';


import '../../../../../vd/vd_exports.dart' show GISResponse;

class ActivityLocation extends Equatable {
  final LatLng latLng;
  final GISResponse gisResponse;

  const ActivityLocation({
    required this.latLng,
    required this.gisResponse,
  });

  @override
  List<Object> get props => [latLng, gisResponse];
}
