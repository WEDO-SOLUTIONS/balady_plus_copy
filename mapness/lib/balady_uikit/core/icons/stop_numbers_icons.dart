// Place fonts/system_icons.ttf in your fonts/ directory and
// add the following to your pubspec.yaml
// flutter:
//   fonts:
//    - family: system_icons
//      fonts:
//       - asset: fonts/system_icons.ttf
import 'package:flutter/widgets.dart';

import 'constants.dart';

// TODO(Loskutov): update assets with font file from this package as well when migrating
// to uikit and package param to each constant

class StopNumbersIcons {
  StopNumbersIcons._();

  static const String _fontFamily = 'numbers_icons';

  static const IconData $01 = IconData(0xe915, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData $02 = IconData(0xe916, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData $03 = IconData(0xe917, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData $04 = IconData(0xe918, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData $05 = IconData(0xe919, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData $06 = IconData(0xe90c, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData $07 = IconData(0xe90d, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData $08 = IconData(0xe90e, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData $09 = IconData(0xe90f, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData $10 = IconData(0xe910, fontFamily: _fontFamily, fontPackage: packageName);

  static IconData? fromIndex(int index) => switch (index) {
        1 => $01,
        2 => $02,
        3 => $03,
        4 => $04,
        5 => $05,
        6 => $06,
        7 => $07,
        8 => $08,
        9 => $09,
        10 => $10,
        _ => null,
      };
}
