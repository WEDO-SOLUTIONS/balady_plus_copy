import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/favorite_lists/data/models/icon_code.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_pin_marker_bitmap.g.dart';

/// Runtime composer for favorite-list pin markers. Loads the pin frame
/// (`ic_favorite_pin_frame.svg` — white disc + tinted rounded-square ring)
/// and the selected [FavoriteIconCode] glyph, both tinted with the same
/// color via `SvgTheme.currentColor`, composites the glyph on top, and
/// rasterizes the result to PNG bytes for `PngBytesMarkerIcon`. Results are
/// cached per `(tint, icon)` so repeat combinations are free.
///
/// Pattern mirrors `DynamicPoiMarkerBitmap`
/// (`features/dynamic_poi/dynamic_poi_marker_bitmap.dart`).
class FavoritePinMarkerBitmap {
  FavoritePinMarkerBitmap();

  static const String _packageName = 'mapness';
  static const double _logicalSize = 24;
  static const double _glyphSize = 14;

  // Geometry for renderTeardropPin — derived from ic_favorite_pin.svg's own
  // coordinates (viewBox 53x63): pin-tip dot centred at (26.08, 55), inner
  // white disc centred at ~(26, 24). The DGis iOS SDK forces height == width
  // for raw PNG marker bytes, so the non-square 53x63 content is padded
  // horizontally to a 63x63 square canvas and the anchor is computed inside
  // it (same technique as DynamicPoiMarkerBitmap for its "large" size).
  static const double _teardropContentWidth = 53;
  static const double _teardropContentHeight = 63;
  static const double _teardropCanvasSize = 63;
  static const double _teardropHorizontalInset = (_teardropCanvasSize - _teardropContentWidth) / 2;
  static const Offset _teardropGlyphCenter = Offset(26, 24);
  static const double _teardropGlyphSize = 20;
  static const double _teardropAnchorY = 55 / _teardropContentHeight;

  final Map<_CacheKey, Uint8List> _cache = {};
  final Map<_CacheKey, Uint8List> _teardropCache = {};

  /// Logical width/height of [renderTeardropPin] output — pass as
  /// `MarkerIconMessage.width`.
  double get teardropLogicalSize => _teardropCanvasSize;

  /// Anchor (0..1) — the geo coordinate sits at the pin-tip dot, not the
  /// bitmap centre (unlike [render]'s plain circle).
  ({double x, double y}) get teardropAnchor => (x: 0.5, y: _teardropAnchorY);

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

    final frameLoader = SvgAssetLoader(
      Assets.icons.svg.favorite.icFavoritePinFrame.path,
      packageName: _packageName,
      theme: SvgTheme(currentColor: tint),
    );
    final frameInfo = await vg.loadPicture(frameLoader, null);

    final loader = SvgAssetLoader(
      icon.getIcon().path,
      packageName: _packageName,
      theme: SvgTheme(currentColor: tint),
    );
    final info = await vg.loadPicture(loader, null);

    final px = (_logicalSize * devicePixelRatio).round();
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, Rect.fromLTWH(0, 0, px.toDouble(), px.toDouble()))
      ..scale(devicePixelRatio)
      ..save()
      ..scale(_logicalSize / frameInfo.size.width)
      ..drawPicture(frameInfo.picture)
      ..restore();

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
    frameInfo.picture.dispose();
    if (bytes == null) {
      throw StateError('Failed to encode favorite pin marker bitmap for tint=$tint, icon=$icon');
    }
    final out = bytes.buffer.asUint8List();
    _cache[key] = out;
    return out;
  }

  /// Renders the "teardrop" pin (`ic_favorite_pin.svg`) tinted with [tint],
  /// with [icon] composited on top of its inner white disc. Used only for
  /// the map-selected favorite POI marker — [render]'s plain circle is used
  /// everywhere else (favourites layer) and is left untouched.
  Future<Uint8List> renderTeardropPin({
    required Color tint,
    required FavoriteIconCode icon,
    required double devicePixelRatio,
  }) async {
    final key = _CacheKey(tint: tint, icon: icon);
    final cached = _teardropCache[key];
    if (cached != null) {
      return cached;
    }

    final frameLoader = SvgAssetLoader(
      Assets.icons.svg.favorite.icFavoritePin.path,
      packageName: _packageName,
      theme: SvgTheme(currentColor: tint),
    );
    final frameInfo = await vg.loadPicture(frameLoader, null);

    final glyphLoader = SvgAssetLoader(
      icon.getIcon().path,
      packageName: _packageName,
      theme: SvgTheme(currentColor: tint),
    );
    final glyphInfo = await vg.loadPicture(glyphLoader, null);

    final px = (_teardropCanvasSize * devicePixelRatio).round();
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, Rect.fromLTWH(0, 0, px.toDouble(), px.toDouble()))
      ..scale(devicePixelRatio)
      ..translate(_teardropHorizontalInset, 0)
      ..drawPicture(frameInfo.picture);

    final glyphScale = _teardropGlyphSize / glyphInfo.size.width;
    final glyphOffset = _teardropGlyphCenter - const Offset(_teardropGlyphSize / 2, _teardropGlyphSize / 2);
    canvas
      ..save()
      ..translate(glyphOffset.dx, glyphOffset.dy)
      ..scale(glyphScale)
      ..drawPicture(glyphInfo.picture)
      ..restore();

    final picture = recorder.endRecording();
    final image = await picture.toImage(px, px);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    picture.dispose();
    image.dispose();
    frameInfo.picture.dispose();
    glyphInfo.picture.dispose();
    if (bytes == null) {
      throw StateError('Failed to encode favorite teardrop pin bitmap for tint=$tint, icon=$icon');
    }
    final out = bytes.buffer.asUint8List();
    _teardropCache[key] = out;
    return out;
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
