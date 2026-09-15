import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/marker_tap_event.dart';
import 'package:dgis_map_platform_interface/src/events/models/lat_lng.dart';

/// Turns the native map's taps on photo markers into a Dart stream.
class MarkerTapEventHandler {
  /// Creates the handler.
  MarkerTapEventHandler();

  /// Every tap on a photo marker the map has reported.
  Stream<MarkerWithPhotoTapEvent> get markerWithPhotoTapEvents => _markerTapController.stream;

  final _markerTapController = StreamController<MarkerWithPhotoTapEvent>.broadcast();

  /// Decodes a marker tap off the platform channel and publishes it on
  /// [markerWithPhotoTapEvents].
  void markerWithPhotoTapEvent(Map<dynamic, dynamic> map) {
    final photoDataMap = map["photoData"];
    final latLngMap = map["latlng"];

    _markerTapController.sink.add(
      MarkerWithPhotoTapEvent(
        latLng: LatLng(latitude: latLngMap['latitude'], longitude: latLngMap['longitude']),
        photoData: PhotoData(
          photoUrl: photoDataMap['photoUrl'],
          isPanoramic: photoDataMap['isPanoramic'],
          azimuth: photoDataMap['azimuth'],
        ),
      ),
    );
  }

  /// Closes the marker tap stream.
  Future<void> dispose() async {
    await _markerTapController.close();
  }
}
