import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/marker_tap_event.dart';
import 'package:dgis_map_platform_interface/src/events/models/lat_lng.dart';

class MarkerTapEventHandler {
  MarkerTapEventHandler();

  Stream<MarkerWithPhotoTapEvent> get markerWithPhotoTapEvents => _markerTapController.stream;

  final _markerTapController = StreamController<MarkerWithPhotoTapEvent>.broadcast();

  void markerWithPhotoTapEvent(Map<dynamic, dynamic> map) {
    final photoDataMap = map["photoData"];
    final latLngMap = map["latlng"];

    _markerTapController.sink.add(MarkerWithPhotoTapEvent(
      latLng: LatLng(
        latitude: latLngMap['latitude'],
        longitude: latLngMap['longitude'],
      ),
      photoData: PhotoData(
        photoUrl: photoDataMap['photoUrl'],
        isPanoramic: photoDataMap['isPanoramic'],
        azimuth: photoDataMap['azimuth'],
      ),
    ));
  }

  Future<void> dispose() async {
    await _markerTapController.close();
  }
}
