import 'package:dgis_map/library.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/features/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/shared/extensions/string_ext.dart';

class Markers {
  static const double defaultWidth = 70;
  static const double defaultHeight = 58;
  static final defaultPin = Assets.icons.lottie.pinLogoAnimated;
  static final defaultPinNew = Assets.icons.svg.placesBigNew.old.icPinNew.keyName;
  static final defaultPinNewSaudiDay = Assets.icons.svg.icPinNewSaudiDay.keyName;

  static Marker pinMarker(
    GeoPointWithElevationMessage position, {
    String? id,
    String? icon,
    double? width,
    double? height,
    String? text,
    MarkerTextStyleMessage? textStyle,
    int maxCharsPerLine = 40,
  }) => Marker(
    id: id ?? 'PIN-MARKER',
    options: MarkerOptionsMessage(
      position: position,
      icon:
          icon?.resolvedMarkerIcon(size: width ?? defaultWidth) ??
          SvgMarkerIcon(
            svgPath: (SaudiNationalDay.isNow()
                ? Assets.icons.svg.icPinNewSaudiDay.keyName
                : Assets.icons.svg.placesBigNew.old.icPinNew.keyName),
            width: width ?? defaultWidth,
          ),
      text: text?.breakMarkerLabel(maxCharsPerLine: maxCharsPerLine),
      textStyle: textStyle,
      anchor: MarkerAnchorMessage(x: 0.5, y: 1),
      animatedAppearance: true,
      zIndex: 50,
    ),
  );
}
