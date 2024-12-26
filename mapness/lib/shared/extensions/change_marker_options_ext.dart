import 'package:dgis_map/library.dart';

extension ChangeMarkerOptionsExt on MarkerOptionsMessage {
  ChangeMarkerOptionsMessage copyWith({
    GeoPointWithElevationMessage? position,
    MarkerIconMessage? icon,
    MarkerAnchorMessage? anchor,
    String? text,
    MarkerTextStyleMessage? textStyle,
    bool? animatedAppearance,
    int? zIndex,
    bool? isVisible,
  }) =>
      ChangeMarkerOptionsMessage(
        position: position ?? this.position,
        icon: icon ?? this.icon,
        anchor: anchor ?? this.anchor,
        text: text ?? this.text,
        textStyle: textStyle ?? this.textStyle,
        animatedAppearance: animatedAppearance ?? this.animatedAppearance,
        zIndex: zIndex ?? this.zIndex,
        isVisible: isVisible ?? this.isVisible,
      );
}
