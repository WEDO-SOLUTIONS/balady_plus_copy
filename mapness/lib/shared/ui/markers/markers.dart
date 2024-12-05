import 'package:dgis_map/library.dart';

class Markers {
  static const double defaultWidth = 58;
  static const double defaultHeight = 58;

  static Marker pinMarker(
    GeoPointWithElevationMessage position, {
    String? id,
    String? icon,
    double? width,
    double? height,
  }) =>
      Marker(
        id: id ?? 'PIN-MARKER',
        options: MarkerOptionsMessage(
          position: position,
          icon: SvgMarkerIcon(
            svgPath: icon ?? 'packages/mapness/assets/icons/svg/ic_pin.svg',
            width: width ?? defaultWidth,
          ),
          anchor: MarkerAnchorMessage(x: 0.5, y: 1),
          animatedAppearance: true,
          zIndex: 50,
        ),
      );
}
