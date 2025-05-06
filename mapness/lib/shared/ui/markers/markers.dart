import 'package:dgis_map/library.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/utils/common_function.dart';

class Markers {
  static const double defaultWidth = 70;
  static const double defaultHeight = 58;
  static final defaultPin = Assets.icons.lottie.pinLogoAnimated;
  static final defaultPinNew = Assets.icons.svg.icPinNew.keyName;

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
            svgPath: icon ?? Assets.icons.svg.icPinNew.keyName,
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
