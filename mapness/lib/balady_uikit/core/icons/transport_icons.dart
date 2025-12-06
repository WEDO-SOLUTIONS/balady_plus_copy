// Place fonts/transport_icons.ttf in your fonts/ directory and
// add the following to your pubspec.yaml
// flutter:
//   fonts:
//    - family: driving_and_transport
//      fonts:
//       - asset: fonts/mapness_icons/transport_icons.ttf
import 'package:flutter/widgets.dart';

import 'constants.dart';

// TODO(Loskutov): update assets with font file from this package as well when migrating
// to uikit and package param to each constant
class TransportIcons {
  TransportIcons._();

  static const String _fontFamily = 'transport_icons';

  static const IconData accident = IconData(0xe90a, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData addStop = IconData(0xe910, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData bicycleLTR = IconData(0xe95a, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData bicycleRTL = IconData(0xe95b, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData bus = IconData(0xe900, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData cableway = IconData(0xe95d, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData car = IconData(0xe95e, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData carError = IconData(0xe90d, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData carFilled = IconData(0xe902, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData charge = IconData(0xe9d1, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData chargePlug = IconData(0xe95f, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData freeRoam = IconData(0xe903, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData horizontalChange = IconData(0xe960, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData locationDirection = IconData(0xe961, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData locationDirectionNavigator =
      IconData(0xe962, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData locationFullLTR = IconData(0xe963, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData locationFullRTL = IconData(0xe964, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData locationLTR = IconData(0xe965, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData locationQuestionLTR = IconData(0xe904, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData locationQuestionRTL = IconData(0xe905, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData locationRTL = IconData(0xe966, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData metroStation = IconData(0xe907, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData overlap = IconData(0xe978, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData parkingActive = IconData(0xe908, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData parkingEnable = IconData(0xe909, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData pedestrianErrorLTR = IconData(0xe90e, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData pedestrianErrorRTL = IconData(0xe90f, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData pedestrianLTR = IconData(0xe96a, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData pedestrianRTL = IconData(0xe96b, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData repair = IconData(0xe90b, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData routeThrough = IconData(0xe906, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData scooterLTR = IconData(0xe96c, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData scooterRTL = IconData(0xe96d, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData ship = IconData(0xe96e, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData taxi = IconData(0xe96f, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData tram = IconData(0xe973, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData tramError = IconData(0xe90c, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData trolley = IconData(0xe901, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData truckLTR = IconData(0xe975, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData truckRTL = IconData(0xe976, fontFamily: _fontFamily, fontPackage: packageName);
  static const IconData verticalChange = IconData(0xe977, fontFamily: _fontFamily, fontPackage: packageName);
}
