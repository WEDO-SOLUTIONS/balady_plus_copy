import 'package:dgis_map/library.dart';

abstract class LayersSvgPaths {
  static const favourites = 'packages/mapness/assets/icons/svg/layers/ic_fav_pin.svg';
  static const home = 'packages/mapness/assets/icons/svg/layers/ic_fav_home.svg';
  static const work = 'packages/mapness/assets/icons/svg/layers/ic_fav_work.svg';
  static const joyPark = 'packages/mapness/assets/icons/svg/layers/ic_joy_pin.svg';
  static const parking = 'packages/mapness/assets/icons/svg/layers/ic_parking_pin.svg';
  static const building = 'packages/mapness/assets/icons/svg/layers/ic_building_pin.svg';
  static const fancy = 'packages/mapness/assets/icons/svg/layers/ic_fancy_pin.svg';
  static const invest = 'packages/mapness/assets/icons/svg/layers/ic_invest_pin.svg';
  static const basicMarker = 'packages/mapness/assets/icons/svg/ic_marker_m_new.svg';
}

/// Deprecated paths to SVG icons. Used only for migration purposes.
/// For some reasons we didn't agree on the new paths and we should use the old ones.
/// This class should be removed after migration. But now it used for keep old paths in one place.
abstract class LayersSvgPathsDeprecated {
  static const joyParkCompleted = 'packages/mapness/assets/icons/svg/ic_iwish_marker_completed.svg';
  static const joyParkSelected = 'packages/mapness/assets/icons/svg/ic_iwish_marker_selected.svg';
  static const joyParkPlanned = 'packages/mapness/assets/icons/svg/ic_iwish_marker_planned.svg';
}

extension MarkerIconMessageExtension on String {
  /// Returns a [MarkerIconMessage] with the given [size].
  ///
  /// WARNING: Use it only with SVG icons and String that represents the path to the icon.
  MarkerIconMessage markerIcon({double size = 24}) => SvgMarkerIcon(
        svgPath: this,
        width: size,
      );
}
