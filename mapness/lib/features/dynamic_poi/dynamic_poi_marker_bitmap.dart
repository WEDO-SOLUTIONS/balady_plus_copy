import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_marker_size.dart';

/// Background / stroke / glyph tint for one map theme.
///
/// Colors are picked from the design spec and depend purely on the app's
/// dark-mode state. Selection is not encoded here — selected POIs are
/// promoted to [DynamicPoiMarkerSize.large] for visual feedback, the colors
/// stay tied to the theme.
@immutable
class DynamicPoiMarkerColors {
  const DynamicPoiMarkerColors({required this.fill, required this.stroke, required this.glyph});

  final Color fill;
  final Color stroke;
  final Color glyph;

  static const darkTheme = DynamicPoiMarkerColors(
    fill: Color(0xFF31CDC2),
    stroke: Color(0xFF0AB0A4),
    glyph: Color(0xFFFFFFFF),
  );

  static const lightTheme = DynamicPoiMarkerColors(
    fill: Color(0xFF307457),
    stroke: Color(0xFF638476),
    glyph: Color(0xFFFFFFFF),
  );

  static DynamicPoiMarkerColors forTheme({required bool isDark}) => isDark ? darkTheme : lightTheme;
}

/// Runtime composer for Dynamic POI markers. Produces a transparent PNG for
/// `PngBytesMarkerIcon`, drawn from a per-rubric glyph SVG and a theme-
/// dependent rounded-square background. Results are cached per
/// `(rubricId, size, isDark)` so repeat combinations are free.
///
/// Pattern mirrors the runtime-bytes approach used by ETA avatars
/// (`features/share_eta/providers/eta_geo_subscriber.dart:394`).
class DynamicPoiMarkerBitmap {
  DynamicPoiMarkerBitmap();

  final Map<_CacheKey, Uint8List> _cache = {};

  /// Logical width of the rendered marker — pass as `MarkerIconMessage.width`
  /// so the SDK scales the bitmap correctly. The bitmap itself is rendered
  /// at `width * devicePixelRatio` so retina stays crisp.
  double logicalWidthOf(DynamicPoiMarkerSize size) => _specFor(size).width;

  /// Anchor (0..1) — the geo coordinate sits at this fraction of the bitmap.
  /// For [DynamicPoiMarkerSize.large] the anchor falls on the accent dot
  /// below the body (computed from the spec, not 1.0, because the bitmap is
  /// square — the DGis iOS SDK forces `height = width` when consuming raw
  /// PNG bytes, so we pad the bitmap horizontally and anchor inside it).
  ({double x, double y}) anchorFor(DynamicPoiMarkerSize size) {
    final spec = _specFor(size);
    if (spec.hasAccentDot) {
      final dotCentreY = spec.bodyHeight + spec.dotGap + spec.dotRadius;
      return (x: 0.5, y: dotCentreY / spec.height);
    }
    return (x: 0.5, y: 0.5);
  }

  Future<Uint8List> render({
    required String glyphAssetPath,
    required String glyphPackageName,
    required String rubricId,
    required DynamicPoiMarkerSize size,
    required bool isDark,
    required double devicePixelRatio,
  }) async {
    final key = _CacheKey(rubricId: rubricId, size: size, isDark: isDark);
    final cached = _cache[key];
    if (cached != null) {
      return cached;
    }

    final colors = DynamicPoiMarkerColors.forTheme(isDark: isDark);
    final spec = _specFor(size);
    final pxW = (spec.width * devicePixelRatio).round();
    final pxH = (spec.height * devicePixelRatio).round();

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, Rect.fromLTWH(0, 0, pxW.toDouble(), pxH.toDouble()))..scale(devicePixelRatio);

    _paintBackground(canvas, spec, colors);
    if (spec.glyphSide > 0) {
      await _paintGlyph(canvas, spec, glyphAssetPath, glyphPackageName, colors.glyph);
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(pxW, pxH);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    picture.dispose();
    image.dispose();
    if (bytes == null) {
      throw StateError('Failed to encode Dynamic POI marker bitmap for $rubricId/$size/isDark=$isDark');
    }
    final out = bytes.buffer.asUint8List();
    _cache[key] = out;
    return out;
  }

  void _paintBackground(ui.Canvas canvas, _MarkerSpec spec, DynamicPoiMarkerColors c) {
    final fill = ui.Paint()
      ..color = c.fill
      ..style = ui.PaintingStyle.fill;
    final stroke = ui.Paint()
      ..color = c.stroke
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = spec.strokeWidth;

    // Body occupies `bodyWidth × bodyHeight`, centred horizontally inside the
    // bitmap. For sizes without an accent dot the bitmap matches the body,
    // for `large` the bitmap is wider (square) so the accent dot below stays
    // within bounds when the SDK forces square aspect.
    final inset = spec.strokeWidth / 2;
    final bodyLeft = (spec.width - spec.bodyWidth) / 2 + inset;
    final bodyRect = Rect.fromLTWH(bodyLeft, inset, spec.bodyWidth - inset * 2, spec.bodyHeight - inset * 2);
    final body = ui.RRect.fromRectAndRadius(bodyRect, Radius.circular(spec.cornerRadius));
    canvas.drawRRect(body, fill);
    if (spec.strokeWidth > 0) {
      canvas.drawRRect(body, stroke);
    }

    if (spec.hasAccentDot) {
      final dotFill = ui.Paint()
        ..color = c.fill
        ..style = ui.PaintingStyle.fill;
      final dotStroke = ui.Paint()
        ..color = c.stroke
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = spec.dotStrokeWidth;
      final cx = spec.width / 2;
      final dotCentreY = spec.bodyHeight + spec.dotGap + spec.dotRadius;
      // Pull the stroke radius inwards by half-stroke so the visible disc
      // matches `dotRadius * 2` (otherwise Flutter centres the stroke on the
      // path, blowing the outer diameter past the target).
      final strokeR = spec.dotRadius - spec.dotStrokeWidth / 2;
      canvas.drawCircle(Offset(cx, dotCentreY), spec.dotRadius, dotFill);
      if (spec.dotStrokeWidth > 0 && strokeR > 0) {
        canvas.drawCircle(Offset(cx, dotCentreY), strokeR, dotStroke);
      }
    }
  }

  Future<void> _paintGlyph(
    ui.Canvas canvas,
    _MarkerSpec spec,
    String assetPath,
    String packageName,
    Color tint,
  ) async {
    final loader = SvgAssetLoader(
      assetPath,
      packageName: packageName,
      theme: SvgTheme(currentColor: tint),
    );
    final info = await vg.loadPicture(loader, null);
    final scale = spec.glyphSide / info.size.width;
    final dx = (spec.width - spec.glyphSide) / 2;
    // Centre vertically inside the body (top-aligned in the bitmap).
    final dy = (spec.bodyHeight - spec.glyphSide) / 2;
    canvas
      ..save()
      ..translate(dx, dy)
      ..scale(scale)
      ..drawPicture(info.picture)
      ..restore();
    info.picture.dispose();
  }

  _MarkerSpec _specFor(DynamicPoiMarkerSize size) {
    switch (size) {
      case DynamicPoiMarkerSize.small:
        // 12×12 rounded square, no glyph. Pure marker without label — used at
        // overview zoom where individual icons would not be readable.
        return const _MarkerSpec(
          width: 12,
          height: 12,
          bodyWidth: 12,
          bodyHeight: 12,
          cornerRadius: 3,
          strokeWidth: 2,
          glyphSide: 0,
        );
      case DynamicPoiMarkerSize.medium:
        // 22×22 with glyph filling the inner ~16×16.
        return const _MarkerSpec(
          width: 22,
          height: 22,
          bodyWidth: 22,
          bodyHeight: 22,
          cornerRadius: 5,
          strokeWidth: 2,
          glyphSide: 14,
        );
      case DynamicPoiMarkerSize.large:
        // 40×40 body + 6×6 accent dot below. The bitmap is 54×54 (square)
        // because DGis iOS clamps `height = width` for raw PNG bytes; we pad
        // horizontally so the dot fits inside square bounds. Anchor lands on
        // the accent dot — see [anchorFor].
        return const _MarkerSpec(
          width: 54,
          height: 54,
          bodyWidth: 40,
          bodyHeight: 40,
          cornerRadius: 10,
          strokeWidth: 4,
          glyphSide: 24,
          hasAccentDot: true,
          dotRadius: 3,
          dotStrokeWidth: 1,
          dotGap: 4,
        );
    }
  }
}

class _MarkerSpec {
  const _MarkerSpec({
    required this.width,
    required this.height,
    required this.bodyWidth,
    required this.bodyHeight,
    required this.cornerRadius,
    required this.strokeWidth,
    required this.glyphSide,
    this.hasAccentDot = false,
    this.dotRadius = 0,
    this.dotStrokeWidth = 0,
    this.dotGap = 0,
  });

  /// Bitmap width — the value passed to `MarkerIconMessage.width`. The DGis
  /// iOS SDK then renders the image into a `width × width` square box.
  final double width;

  /// Bitmap height — kept equal to [width] so the SDK doesn't squish the image.
  final double height;

  /// Body (rounded square) width inside the bitmap. May be smaller than
  /// [width] to leave room around the body for an accent dot or padding.
  final double bodyWidth;

  /// Body (rounded square) height inside the bitmap.
  final double bodyHeight;

  final double cornerRadius;
  final double strokeWidth;
  final double glyphSide;
  final bool hasAccentDot;
  final double dotRadius;
  final double dotStrokeWidth;
  final double dotGap;
}

@immutable
class _CacheKey {
  const _CacheKey({required this.rubricId, required this.size, required this.isDark});
  final String rubricId;
  final DynamicPoiMarkerSize size;
  final bool isDark;

  @override
  bool operator ==(Object other) =>
      other is _CacheKey && other.rubricId == rubricId && other.size == size && other.isDark == isDark;

  @override
  int get hashCode => Object.hash(rubricId, size, isDark);
}
