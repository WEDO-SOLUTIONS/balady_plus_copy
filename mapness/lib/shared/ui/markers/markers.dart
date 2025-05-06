import 'package:dgis_map/library.dart';
import 'package:mapness/shared/utils/common_function.dart';

class Markers {
  static const double defaultWidth = 70;
  static const double defaultHeight = 58;
  static const defaultPin = 'packages/mapness/assets/icons/lottie/pin_logo_animated.json';
  static const defaultPinNew = 'packages/mapness/assets/icons/svg/ic_pin_new.svg';

  static Marker pinMarker(
    GeoPointWithElevationMessage position, {
    String? id,
    String? icon,
    double? width,
    double? height,
    String? text,
    MarkerTextStyleMessage? textStyle,
  }) =>
      Marker(
        id: id ?? 'PIN-MARKER',
        options: MarkerOptionsMessage(
          position: position,
          icon: SvgMarkerIcon(
            svgPath: icon ?? defaultPinNew,
            width: width ?? defaultWidth,
          ),
          text: breakMarkerLabel(text),
          textStyle: textStyle,
          anchor: MarkerAnchorMessage(x: 0.5, y: 1),
          animatedAppearance: true,
          zIndex: 50,
        ),
      );
}
