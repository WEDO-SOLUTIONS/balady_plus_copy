import 'dart:typed_data';

import 'package:dgis_map/library.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/shared/extensions/string_ext.dart';

class Markers {
  static const double defaultWidth = 70;
  static const double defaultHeight = 58;
  static final defaultPin = Assets.icons.lottie.pinLogoAnimated;
  static final defaultPinNew = Assets.icons.svg.placesBigNew.old.icPinNew.keyName;
  static final defaultPinNewSaudiDay = Assets.icons.svg.icPinNewSaudiDay.keyName;
  static final defaultPinNewFoundingDay = Assets.icons.svg.placesNewFoundingDay.icDefault.keyName;

  static Marker pinMarker(
    GeoPointWithElevationMessage position, {
    String? id,
    String? icon,
    Uint8List? iconBytes,
    double? width,
    double? height,
    String? text,
    MarkerTextStyleMessage? textStyle,
    int maxCharsPerLine = 40,
    CityEventType? activeCityEvent,
    bool isDark = false,
    MarkerAnchorMessage? anchor,
  }) => Marker(
    id: id ?? 'PIN-MARKER',
    options: MarkerOptionsMessage(
      position: position,
      icon: iconBytes != null
          ? PngBytesMarkerIcon(pngData: iconBytes, width: width ?? defaultWidth)
          : (icon ?? activeCityEvent?.defaultPin(isDark: isDark) ?? defaultPinNew).resolvedMarkerIcon(
              size: width ?? defaultWidth,
            ),
      text: text?.breakMarkerLabel(maxCharsPerLine: maxCharsPerLine),
      textStyle: textStyle,
      anchor: anchor ?? MarkerAnchorMessage(x: 0.5, y: 1),
      animatedAppearance: true,
      zIndex: 50,
    ),
  );
}
