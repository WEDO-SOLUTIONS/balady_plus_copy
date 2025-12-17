import 'package:dgis_map/library.dart';

extension MarkerIconMessageExtension on String {
  /// Returns a [MarkerIconMessage] with the given [size].
  ///
  /// WARNING: Use it only with SVG icons and String that represents the path to the icon.
  MarkerIconMessage markerIcon({double size = 24}) => SvgMarkerIcon(
        svgPath: this,
        width: size,
      );

  /// Returns a [MarkerIconMessage] with the given [size].
  ///
  /// WARNING: Use it only with PNG icons and String that represents the path to the icon.
  MarkerIconMessage resolvedMarkerIcon({double size = 24}) {
    final ext = split('.').last;

    return switch (ext) {
      'svg' => SvgMarkerIcon(
          svgPath: this,
          width: size,
        ),
      'png' => PngMarkerIcon(
          pngPath: this,
          width: size,
        ),
      _ => PngMarkerIcon(
          pngPath: this,
          width: size,
        ),
    };
  }
}
