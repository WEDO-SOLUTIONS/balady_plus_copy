import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActivityLocation extends Equatable {
  final LatLng latLng;
  final String address;

  const ActivityLocation({
    required this.latLng,
    required this.address,
  });

  @override
  List<Object> get props => [latLng, address];
}
