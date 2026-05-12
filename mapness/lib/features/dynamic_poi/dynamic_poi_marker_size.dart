/// Discrete marker sizes used by the Dynamic POI layer.
///
/// The size at which a feature renders is chosen by [sizeForZoom] from the
/// continuous DGis camera zoom.
///
///   - [small]  — 12×12 square, no glyph, no label. Used at overview zoom.
///   - [medium] — 22×22 square with glyph and label.
///   - [large]  — 40×40 square with glyph, label, and an accent dot below
///                that marks the geo coordinate.
enum DynamicPoiMarkerSize { small, medium, large }

/// Lower-bound zoom for each size. A feature renders at the largest size whose
/// `minZoom <= currentZoom`.
class DynamicPoiSizeThresholds {
  const DynamicPoiSizeThresholds({required this.medium, required this.large});

  /// Zoom at which [DynamicPoiMarkerSize.medium] becomes the active size.
  final int medium;

  /// Zoom at which [DynamicPoiMarkerSize.large] becomes the active size.
  final int large;

  static const defaults = DynamicPoiSizeThresholds(medium: 16, large: 18);
}

/// Map continuous zoom to a discrete [DynamicPoiMarkerSize].
DynamicPoiMarkerSize sizeForZoom(
  double zoom, {
  DynamicPoiSizeThresholds thresholds = DynamicPoiSizeThresholds.defaults,
}) {
  if (zoom >= thresholds.large) {
    return DynamicPoiMarkerSize.large;
  }
  if (zoom >= thresholds.medium) {
    return DynamicPoiMarkerSize.medium;
  }
  return DynamicPoiMarkerSize.small;
}
