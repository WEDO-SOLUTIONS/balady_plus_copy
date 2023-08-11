import 'package:dgis_map/library.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;

class PointLayersData {
  final String id;
  final String name;
  final String description;
  final String type;

  final GeoPointWithElevationMessage? latLng;

  PointLayersData({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.latLng,
  });
}

enum LayersType {
  layersOne,
  layersTow,
  layersThree,
  layersFourth, //الحفريات
  layersFifth,
  layersSixth,
  layersSeventh,
}

//, ,  and

List<GeoPointMessage> getList(List list) {
  final List<GeoPointMessage> paths = [];
  for (var pointList in list) {
    for (var point in pointList) {
      paths.add(
        GeoPointMessage(
          latitude: double.parse(point[1].toString()),
          longitude: double.parse(point[0].toString()),
        ),
      );
    }
  }
  return paths;
}

List<GeoPointMessage> getPolyLines(List list) {
  final List<GeoPointMessage> paths = [];
  for (var pointList in list) {
    final List<GeoPointMessage> inside = [];
    for (var point in pointList) {
      paths.add(
        GeoPointMessage(
          latitude: double.parse(point[1].toString()),
          longitude: double.parse(point[0].toString()),
        ),
      );
    }
  }
  return paths;
}

List<List<gm.LatLng>> getGoogleList(List list) {
  final List<List<gm.LatLng>> paths = [];
  for (var pointList in list) {
    final List<gm.LatLng> inside = [];

    for (var point in pointList) {
      inside.add(
        gm.LatLng(
          double.parse(point[1].toString()),
          double.parse(point[0].toString()),
        ),
      );
    }
    paths.add(inside);
  }

  return paths;
}
