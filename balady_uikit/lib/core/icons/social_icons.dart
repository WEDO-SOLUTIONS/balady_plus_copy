// Place fonts/social_icons.ttf in your fonts/ directory and
// add the following to your pubspec.yaml
// flutter:
//   fonts:
//    - family: social
//      fonts:
//       - asset: fonts/mapness_icons/social_icons.ttf
import 'package:balady_uikit/core/utils/constants.dart';
import 'package:flutter/widgets.dart';

class SocialIcons {
  SocialIcons._();

  static const String _fontFamily = 'social_icons';

  static const IconData facebook = IconData(0xe9b4, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData instagram = IconData(0xe9b3, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData linkedin = IconData(0xe9b5, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData telegram = IconData(0xe901, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData twitter = IconData(0xe900, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData whatsapp = IconData(0xe902, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData youtube = IconData(0xe9b2, fontFamily: _fontFamily, fontPackage: packageName);
}
