import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/features/favorite_lists/data/models/icon_code.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_pin_marker_bitmap.g.dart';

/// Runtime composer for favorite-list pin markers. Draws the pin frame
/// (white disc + tinted ring) programmatically via `dart:ui`, then composes
/// the selected [FavoriteIconCode] glyph on top — tinted with the same
/// color via `SvgTheme.currentColor` — and rasterizes the result to PNG
/// bytes for `PngBytesMarkerIcon`. Results are cached per `(tint, icon)` so
/// repeat combinations are free.
///
/// Pattern mirrors `DynamicPoiMarkerBitmap`
/// (`features/dynamic_poi/dynamic_poi_marker_bitmap.dart`).
class FavoritePinMarkerBitmap {
  FavoritePinMarkerBitmap();

  static const String _packageName = 'mapness';
  static const double _logicalSize = 24;
  static const double _strokeWidth = 2;
  static const double _glyphSize = 14;

  final Map<_CacheKey, Uint8List> _cache = {};

  Future<Uint8List> render({
    required Color tint,
    required FavoriteIconCode icon,
    required double devicePixelRatio,
  }) async {
    final key = _CacheKey(tint: tint, icon: icon);
    final cached = _cache[key];
    if (cached != null) {
      return cached;
    }

    final loader = SvgAssetLoader(
      icon.getIcon().path,
      packageName: _packageName,
      theme: SvgTheme(currentColor: tint),
    );
    final info = await vg.loadPicture(loader, null);

    final px = (_logicalSize * devicePixelRatio).round();
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, Rect.fromLTWH(0, 0, px.toDouble(), px.toDouble()))..scale(devicePixelRatio);

    _paintFrame(canvas, tint);

    final glyphScale = _glyphSize / info.size.width;
    const glyphOffset = (_logicalSize - _glyphSize) / 2;
    canvas
      ..save()
      ..translate(glyphOffset, glyphOffset)
      ..scale(glyphScale)
      ..drawPicture(info.picture)
      ..restore();

    final picture = recorder.endRecording();
    final image = await picture.toImage(px, px);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    picture.dispose();
    image.dispose();
    info.picture.dispose();
    if (bytes == null) {
      throw StateError('Failed to encode favorite pin marker bitmap for tint=$tint, icon=$icon');
    }
    final out = bytes.buffer.asUint8List();
    _cache[key] = out;
    return out;
  }

  void _paintFrame(ui.Canvas canvas, Color tint) {
    const center = Offset(_logicalSize / 2, _logicalSize / 2);
    const radius = _logicalSize / 2 - 1;

    final fill = ui.Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = ui.PaintingStyle.fill;
    canvas.drawCircle(center, radius, fill);

    final stroke = ui.Paint()
      ..color = tint
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;
    canvas.drawCircle(center, radius, stroke);
  }
}

@immutable
class _CacheKey {
  const _CacheKey({required this.tint, required this.icon});

  final Color tint;
  final FavoriteIconCode icon;

  @override
  bool operator ==(Object other) => other is _CacheKey && other.tint == tint && other.icon == icon;

  @override
  int get hashCode => Object.hash(tint, icon);
}

@Riverpod(keepAlive: true)
FavoritePinMarkerBitmap favoritePinMarkerBitmap(Ref ref) => FavoritePinMarkerBitmap();
