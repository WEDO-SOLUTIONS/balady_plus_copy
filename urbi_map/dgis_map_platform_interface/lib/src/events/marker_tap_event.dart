import 'package:dgis_map_platform_interface/src/events/models/lat_lng.dart';

/// Reports a tap on a map marker that carries a photo, such as a panorama
/// entry point.
class MarkerWithPhotoTapEvent {
  /// Creates the event for the marker at [latLng] holding [photoData].
  const MarkerWithPhotoTapEvent({required this.latLng, required this.photoData});

  /// Name of the platform channel event this is decoded from.
  static const name = "onMarkerWithPhotoTap";

  /// Where on the map the tapped marker sits.
  final LatLng latLng;

  /// The photo the tapped marker stands for.
  final PhotoData photoData;
}

/// The photo behind a [MarkerWithPhotoTapEvent].
class PhotoData {
  /// Creates the photo description.
  const PhotoData({required this.photoUrl, required this.isPanoramic, required this.azimuth});

  /// Address the image itself is loaded from.
  final String photoUrl;

  /// Whether the image is a panorama rather than a flat photo.
  final bool isPanoramic;

  /// Direction the camera was facing, in degrees clockwise from north.
  final double azimuth;
}
