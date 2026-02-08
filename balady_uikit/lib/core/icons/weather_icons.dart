// Place fonts/weather_icons.ttf in your fonts/ directory and
// add the following to your pubspec.yaml
// flutter:
//   fonts:
//    - family: weather
//      fonts:
//       - asset: fonts/mapness_icons/weather_icons.ttf
import 'package:balady_uikit/core/utils/constants.dart';
import 'package:flutter/widgets.dart';

class WeatherIcons {
  WeatherIcons._();

  static const String _fontFamily = 'weather_icons';

  static const IconData cloudy = IconData(0xe901, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData humidity = IconData(0xe9b8, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData partlyCloudy = IconData(0xe902, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData pressure = IconData(0xe900, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData sun = IconData(0xe903, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData sunset = IconData(0xe904, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData thermometerEmpty = IconData(0xe9b9, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData umbrellaEmpty = IconData(0xe9b7, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData wind = IconData(0xe9b6, fontFamily: _fontFamily, fontPackage: packageName);
}
