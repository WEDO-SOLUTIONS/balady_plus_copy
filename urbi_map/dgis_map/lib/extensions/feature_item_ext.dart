import 'package:dgis_map/wfs/data/feature_item.dart';

extension FeatureItemGeo on FeatureItem {
  bool hasSameCoordinates(
      {required double latitude, required double longitude}) {
    final coordinates = this.geometry.coordinates;
    if (coordinates.length < 2) {
      return false;
    }
    return this.latitude == latitude && this.longitude == longitude;
  }
}
