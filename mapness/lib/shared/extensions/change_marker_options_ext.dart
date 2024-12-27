import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';

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

extension ChagneMarkerIconMessage on MarkerIconMessage {
  MarkerIconMessage copyWith({
    String? svgPath,
    Uint8List? pngData,
    String? pngPath,
    double? width,
    double? iconOpacity,
    MarkerAzimuthMessage? iconMapDirection,
  }) =>
      MarkerIconMessage(
        width: width ?? this.width,
        svgPath: svgPath ?? this.svgPath,
        pngData: pngData ?? this.pngData,
        pngPath: pngPath ?? this.pngPath,
        iconOpacity: iconOpacity ?? this.iconOpacity,
        iconMapDirection: iconMapDirection ?? this.iconMapDirection,
      );
}
