import 'package:dgis_map_platform_interface/src/events/models/lat_lng.dart';

class MarkerWithPhotoTapEvent {
  const MarkerWithPhotoTapEvent({
    required this.latLng,
    required this.photoData,
  });

  static const name = "onMarkerWithPhotoTap";

  final LatLng latLng;
  final PhotoData photoData;
}

class PhotoData {
  const PhotoData({
    required this.photoUrl,
    required this.isPanoramic,
    required this.azimuth,
  });
  final String photoUrl;
  final bool isPanoramic;
  final double azimuth;
}
