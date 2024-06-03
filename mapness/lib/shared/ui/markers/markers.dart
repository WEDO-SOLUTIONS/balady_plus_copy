import 'package:dgis_map/library.dart';

class Markers {
  static const double defaultWidth = 24;
  static const double defaultHeight = 48;
  
  static Marker pinMarker(
    GeoPointWithElevationMessage position, {
    String? id,
    String? icon,
    double? width,
  }) =>
      Marker(
        id: id ?? 'PIN-MARKER',
        options: MarkerOptionsMessage(
          position: position,
          icon: MarkerIconMessage(
            path: icon ?? 'packages/mapness/assets/icons/svg/ic_pin.svg',
            width: width ?? defaultWidth,
          ),
          anchor: MarkerAnchorMessage(x: 0.5, y: 1),
          animatedAppearance: true,
          zIndex: 50,
        ),
      );
}
