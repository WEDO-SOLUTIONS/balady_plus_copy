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

extension ChangeTextStyleExt on MarkerTextStyleMessage {
  MarkerTextStyleMessage copyWith({
    double? fontSize,
    int? color,
    double? strokeWidth,
    int? strokeColor,
    MarkerTextPlacementMessage? textPlacement,
    double? textOffset,
    String? fontName,
    bool? suppressOnOverlap,
  }) =>
      MarkerTextStyleMessage(
        fontSize: fontSize ?? this.fontSize,
        color: color ?? this.color,
        strokeWidth: strokeWidth ?? this.strokeWidth,
        strokeColor: strokeColor ?? this.strokeColor,
        textPlacement: textPlacement ?? this.textPlacement,
        textOffset: textOffset ?? this.textOffset,
        fontName: fontName ?? this.fontName,
        suppressOnOverlap: suppressOnOverlap ?? this.suppressOnOverlap,
      );
}

extension ChagneMarkerIconMessage on MarkerIconMessage {
  MarkerIconMessage copyWith({
    String? svgPath,
    Uint8List? pngData,
    String? pngPath,
    double? width,
    double? iconOpacity,
    MapDirectionMessage? iconMapDirection,
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
