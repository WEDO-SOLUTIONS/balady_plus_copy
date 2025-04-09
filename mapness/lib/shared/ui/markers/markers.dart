import 'package:dgis_map/library.dart';

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
          text: breakText(text),
          textStyle: textStyle,
          anchor: MarkerAnchorMessage(x: 0.5, y: 1),
          animatedAppearance: true,
          zIndex: 50,
        ),
      );

  static String? breakText(String? text, {int maxCharsPerLine = 40}) {
    if (text == null || text.trim().isEmpty) {
      return null;
    }

    final words = text.trim().split(RegExp(r'\s+'));
    final buffer = StringBuffer();
    int charCount = 0;

    for (int i = 0; i < words.length; i++) {
      final word = words[i];

      if (charCount + word.length > maxCharsPerLine) {
        if (charCount > 0) {
          buffer.write('\n');
        }
        buffer.write(word);
        charCount = word.length;
      } else {
        if (charCount > 0) {
          buffer.write(' ');
          charCount++;
        }
        buffer.write(word);
        charCount += word.length;
      }
    }
    return buffer.toString();
  }
}
