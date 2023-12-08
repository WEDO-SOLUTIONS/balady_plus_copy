import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
