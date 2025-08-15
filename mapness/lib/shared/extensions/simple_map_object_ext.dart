import 'package:dgis_map/library.dart';

extension SimpleMapObjectListX on List<SimpleMapObjectModel> {
  List<Marker> toMarkers({
    void Function(String id)? onTap,
  }) => map((obj) {
      final centerLat = (obj.bounds.southWest.latitude + obj.bounds.northEast.latitude) / 2;
      final centerLng = (obj.bounds.southWest.longitude + obj.bounds.northEast.longitude) / 2;

      return Marker(
        id: obj.id ?? '',
        options: MarkerOptionsMessage(
          position: GeoPointWithElevationMessage(
            latitude: centerLat,
            longitude: centerLng,
            elevation: 0,
          ),
          isVisible: obj.isVisible,
          zIndex: obj.zIndex,
        ),
        onTap: onTap != null && obj.id != null
            ? () => onTap(obj.id!)
            : null,
      );
    }).toList();
}
