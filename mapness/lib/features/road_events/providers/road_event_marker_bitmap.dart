import 'dart:ui' as ui;

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/road_events/domain/road_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'road_event_marker_bitmap.g.dart';

@Riverpod(keepAlive: true)
RoadEventMarkerBitmap roadEventMarkerBitmap(Ref ref) => RoadEventMarkerBitmap();

/// Runtime composer for road-event markers whose `RoadEventType` has no
/// dedicated marker SVG (only a font-glyph `IconData` used for the small
/// circular badge in `road_event_type_label.dart`). Draws a colored circle +
/// centered glyph and rasterizes to PNG for `PngBytesMarkerIcon`, mirroring
/// `DynamicPoiMarkerBitmap`'s Canvas-compositing pattern. Results are cached
/// per `(type, devicePixelRatio)`.
class RoadEventMarkerBitmap {
  RoadEventMarkerBitmap();

  /// Logical marker size — matches `String.markerIcon()`'s default width, so
  /// these composited markers stay the same size as the existing congestion
  /// SVG marker.
  static const double size = 24;

  static const _glyphColor = Color(0xFFFFFFFF);

  final Map<_CacheKey, Uint8List> _cache = {};

  Future<Uint8List> render({required RoadEventType type, required double devicePixelRatio}) async {
    final key = _CacheKey(type: type, devicePixelRatio: devicePixelRatio);
    final cached = _cache[key];
    if (cached != null) {
      return cached;
    }

    final glyph = _glyphFor(type);
    final background = _backgroundColorFor(type);
    final px = (size * devicePixelRatio).round();

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, Rect.fromLTWH(0, 0, px.toDouble(), px.toDouble()))
      ..scale(devicePixelRatio)
      ..drawCircle(const Offset(size / 2, size / 2), size / 2, ui.Paint()..color = background);
    _paintGlyph(canvas, glyph);

    final picture = recorder.endRecording();
    final image = await picture.toImage(px, px);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    picture.dispose();
    image.dispose();
    if (bytes == null) {
      throw StateError('Failed to encode road event marker bitmap for $type');
    }
    final out = bytes.buffer.asUint8List();
    _cache[key] = out;
    return out;
  }

  void _paintGlyph(ui.Canvas canvas, IconData glyph) {
    const glyphSize = size * 0.58;
    final painter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(glyph.codePoint),
        style: TextStyle(
          fontSize: glyphSize,
          fontFamily: glyph.fontFamily,
          package: glyph.fontPackage,
          color: _glyphColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, Offset((size - painter.width) / 2, (size - painter.height) / 2));
  }

  /// Only the five `RoadEventType`s whose `.icon()` resolves to a
  /// `ToastIconData` reach this bitmap — `congestion` keeps using its own
  /// pre-made SVG marker (see `road_events_markers.dart`) and never calls
  /// `render()`.
  IconData _glyphFor(RoadEventType type) => switch (type) {
    RoadEventType.accident => TransportIcons.accident,
    RoadEventType.construction => TransportIcons.repair,
    RoadEventType.police => PlacesIcons.police,
    RoadEventType.camera => GeneralIcons.photoSolid,
    RoadEventType.danger => GeneralIcons.warning,
    RoadEventType.congestion => throw ArgumentError('$type has a dedicated SVG marker, not a composited one'),
  };

  /// Mirrors `RoadEventTypeLabelEx.color()`'s semantic mapping using fixed
  /// hex values (`errorDefault`/`warningDefault`/`staticBlack` are
  /// theme-invariant in `balady_uikit`), since no `BuildContext`/theme is
  /// available inside this provider.
  Color _backgroundColorFor(RoadEventType type) => switch (type) {
    RoadEventType.accident || RoadEventType.danger => const Color(0xFFE0373D),
    RoadEventType.congestion || RoadEventType.construction => const Color(0xFFF29100),
    RoadEventType.police || RoadEventType.camera => const Color(0xFF1B1B1B),
  };
}

@immutable
class _CacheKey {
  const _CacheKey({required this.type, required this.devicePixelRatio});

  final RoadEventType type;
  final double devicePixelRatio;

  @override
  bool operator ==(Object other) =>
      other is _CacheKey && other.type == type && other.devicePixelRatio == devicePixelRatio;

  @override
  int get hashCode => Object.hash(type, devicePixelRatio);
}
