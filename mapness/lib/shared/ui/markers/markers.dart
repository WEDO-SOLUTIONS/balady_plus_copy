import 'package:dgis_map/library.dart';

class Markers {
  static const double defaultWidth = 58;
  static const double defaultHeight = 58;
  static const defaultPin = 'packages/mapness/assets/icons/lottie/pin_logo_animated.json';

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
            svgPath: icon ?? defaultPin,
            width: width ?? defaultWidth,
          ),
          anchor: MarkerAnchorMessage(x: 0.5, y: 1),
          animatedAppearance: true,
          zIndex: 50,
        ),
      );
}
