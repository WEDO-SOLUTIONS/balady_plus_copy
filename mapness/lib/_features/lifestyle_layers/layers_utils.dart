import 'package:dgis_map/library.dart';

abstract class LayersSvgPaths {
  static const favourites =
      'packages/mapness/assets/icons/svg/layers/ic_fav_pin.svg';
  static const home =
      'packages/mapness/assets/icons/svg/layers/ic_fav_home.svg';
  static const work =
      'packages/mapness/assets/icons/svg/layers/ic_fav_work.svg';

  static const joyPark =
      'packages/mapness/assets/icons/svg/layers/ic_joy_pin.svg';
  static const parking =
      'packages/mapness/assets/icons/svg/layers/ic_parking_pin.svg';
  static const building =
      'packages/mapness/assets/icons/svg/layers/ic_building_pin.svg';
  static const fancy =
      'packages/mapness/assets/icons/svg/layers/ic_fancy_pin.svg';
  static const invest =
      'packages/mapness/assets/icons/svg/layers/ic_invest_pin.svg';
}

extension MarkerIconMessageExtension on String {
  /// Returns a [MarkerIconMessage] with the given [width].
  ///
  /// WARNING: Use it only with SVG icons and String that represents the path to the icon.
  MarkerIconMessage markerIcon({double width = 24}) => MarkerIconMessage(
        path: this,
        width: width,
      );
}
