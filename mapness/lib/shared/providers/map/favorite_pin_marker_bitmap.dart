import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_pin_marker_bitmap.g.dart';

/// Runtime composer for favorite-list pin markers. Loads the single
/// `ic_fav_pin.svg` asset (drawn with `fill="currentColor"` /
/// `stroke="currentColor"`) and tints it per marker color via
/// `SvgTheme.currentColor`, then rasterizes it to PNG bytes for
/// `PngBytesMarkerIcon`. Results are cached per tint color so repeat colors
/// are free.
///
/// Pattern mirrors `DynamicPoiMarkerBitmap`
/// (`features/dynamic_poi/dynamic_poi_marker_bitmap.dart`).
class FavoritePinMarkerBitmap {
  FavoritePinMarkerBitmap();

  static const String _packageName = 'mapness';
  static const double _logicalSize = 24;

  final Map<Color, Uint8List> _cache = {};

  Future<Uint8List> render({required Color tint, required double devicePixelRatio}) async {
    final cached = _cache[tint];
    if (cached != null) {
      return cached;
    }

    final loader = SvgAssetLoader(
      Assets.icons.svg.layers.icFavPin.path,
      packageName: _packageName,
      theme: SvgTheme(currentColor: tint),
    );
    final info = await vg.loadPicture(loader, null);

    final px = (_logicalSize * devicePixelRatio).round();
    final recorder = ui.PictureRecorder();
    ui.Canvas(recorder, Rect.fromLTWH(0, 0, px.toDouble(), px.toDouble()))
      ..scale(px / info.size.width)
      ..drawPicture(info.picture);
    final picture = recorder.endRecording();

    final image = await picture.toImage(px, px);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    picture.dispose();
    image.dispose();
    info.picture.dispose();
    if (bytes == null) {
      throw StateError('Failed to encode favorite pin marker bitmap for tint=$tint');
    }
    final out = bytes.buffer.asUint8List();
    _cache[tint] = out;
    return out;
  }
}

@Riverpod(keepAlive: true)
FavoritePinMarkerBitmap favoritePinMarkerBitmap(Ref ref) => FavoritePinMarkerBitmap();
