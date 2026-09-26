import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:mapness/_generated/assets/assets.gen.dart';

/// Themed marker icon for a friend on the map — a purple squircle pin
/// containing one of a fixed set of illustrations, deterministically
/// assigned per friend (falcon, palm tree, camel, ...). Not the friend's
/// real profile photo — that's still used as-is everywhere else (list row,
/// request row, `FriendCardSheet` header); this is purely the map-pin
/// identity. Colors/sizes are copied verbatim from the Figma marker
/// (`.Elements/Marker`, node `492:9955`): external squircle `#9547E9`
/// 48x48, internal squircle `#AF74EE` 40x40, avatar rounded-rect (radius
/// 10) 38x38 — approximated here as plain rounded rects rather than true
/// squircles, and without the separate 6px tail dot (keeps the existing
/// 48x48 marker bounding box/anchor untouched — see `friend_markers.dart`).
/// ARGB, reused as `Color(kFriendMarkerOuterColor)` by
/// `ui/widgets/friend_marker_avatar.dart` (the Flutter-widget version of
/// this same frame, used in the friend list) so both places share one
/// source of truth for the exact hex values instead of restating them.
const kFriendMarkerOuterColor = 0xFF9547E9;
const kFriendMarkerInnerColor = 0xFFAF74EE;

/// Picks one of the bundled illustrations for a friend — a pure function of
/// [friendId], same hash-pick-from-a-fixed-list idiom already used in this
/// feature for fabricated request names/coordinate offsets
/// (`data/fake_friend_request_repository.dart`). No new `Friend` field, no
/// persistence — the assignment is stable within one process run because
/// `String.hashCode` is stable within a run, same as that precedent.
AssetGenImage illustrationAssetForFriend(String friendId) {
  final illustrations = Assets.images.friendAvatars.values;
  return illustrations[friendId.hashCode.abs() % illustrations.length];
}

/// Builds the composited marker icon for [friendId] at [size] (square).
/// Renders at 2x internally and downsamples with average interpolation for
/// free anti-aliasing on the procedurally-drawn rounded-rect edges — same
/// interpolation mode `EtaUtils.processImage` already uses for its own
/// marker compositing.
Future<img.Image> buildFriendMarkerIcon(String friendId, int size) async {
  const superSample = 2;
  final canvasSize = size * superSample;
  final canvas = img.Image(width: canvasSize, height: canvasSize, numChannels: 4);

  _fillRoundedRect(canvas, 0, 0, canvasSize, canvasSize, canvasSize * 0.375, kFriendMarkerOuterColor);

  final innerSize = (canvasSize * 40 / 48).round();
  final innerOffset = ((canvasSize - innerSize) / 2).round();
  _fillRoundedRect(canvas, innerOffset, innerOffset, innerSize, innerSize, innerSize * 0.375, kFriendMarkerInnerColor);

  final avatarSize = (canvasSize * 38 / 48).round();
  final avatarOffset = ((canvasSize - avatarSize) / 2).round();
  final avatarRadius = canvasSize * 10 / 48;

  final asset = illustrationAssetForFriend(friendId);
  final bytes = await rootBundle.load(asset.keyName);
  final illustration = img.decodeImage(bytes.buffer.asUint8List())!;
  final resizedIllustration = img.copyResize(
    illustration,
    width: avatarSize,
    height: avatarSize,
    interpolation: img.Interpolation.average,
  );
  _compositeRoundedRect(canvas, resizedIllustration, avatarOffset, avatarOffset, avatarRadius);

  return img.copyResize(canvas, width: size, height: size, interpolation: img.Interpolation.average);
}

void _fillRoundedRect(img.Image image, int x0, int y0, int w, int h, double radius, int argbColor) {
  final r = (argbColor >> 16) & 0xFF;
  final g = (argbColor >> 8) & 0xFF;
  final b = argbColor & 0xFF;
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      if (_insideRoundedRect(x + 0.5, y + 0.5, w.toDouble(), h.toDouble(), radius)) {
        image.setPixelRgba(x0 + x, y0 + y, r, g, b, 255);
      }
    }
  }
}

void _compositeRoundedRect(img.Image dst, img.Image src, int dstX, int dstY, double radius) {
  for (var y = 0; y < src.height; y++) {
    for (var x = 0; x < src.width; x++) {
      if (_insideRoundedRect(x + 0.5, y + 0.5, src.width.toDouble(), src.height.toDouble(), radius)) {
        final p = src.getPixel(x, y);
        dst.setPixelRgba(dstX + x, dstY + y, p.r, p.g, p.b, 255);
      }
    }
  }
}

/// Signed-distance-field rounded-rect membership test (Inigo Quilez's
/// `sdRoundBox`) — `package:image` 4.9.2 has no built-in rounded-rect
/// primitive (confirmed: only `fillCircle`/`drawCircle`, no stroke/rect
/// rounding), so the squircle-ish frame is filled with this simple
/// per-pixel test instead of an SVG/polygon path.
bool _insideRoundedRect(double px, double py, double w, double h, double radius) {
  final qx = (px - w / 2).abs() - (w / 2 - radius);
  final qy = (py - h / 2).abs() - (h / 2 - radius);
  final ax = qx > 0 ? qx : 0.0;
  final ay = qy > 0 ? qy : 0.0;
  final maxQ = qx > qy ? qx : qy;
  final dist = math.sqrt(ax * ax + ay * ay) + (maxQ < 0 ? maxQ : 0.0) - radius;
  return dist <= 0;
}
