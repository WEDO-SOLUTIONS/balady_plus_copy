import 'package:flutter/material.dart';

/// Identifies the "?" help control on the dashboard so the tutorial can cut a
/// window for it out of its scrim.
///
/// Lives in its own file rather than on `TifoHelpControl`: `tifo_control.dart`
/// already imports the tutorial to launch it, so hanging the key off the
/// control would close an import cycle.
final GlobalKey tifoHelpControlKey = GlobalKey(debugLabel: 'tifoHelpControl');

/// Full-screen dim with a rounded window punched out around [target].
///
/// Figma draws this step by laying a `#000000 @40%` rectangle over the whole
/// dashboard and then re-drawing the help button on top of it. Cutting a hole
/// instead keeps the *live* control visible — it stays in whatever position
/// the real layout gave it, so the window can't drift out of alignment the way
/// a replica pinned to the design's coordinates would.
///
/// With no [target] mounted (the TIFO layer off, so no help control on screen)
/// this degrades to a plain dim rather than pointing at nothing.
class TifoSpotlight extends StatelessWidget {
  const TifoSpotlight({required this.target, super.key});

  /// Scrim opacity from the design.
  static const Color _scrim = Color(0x66000000);

  /// `MapButton` rounds its corners by 10; the window follows suit.
  static const Radius _radius = Radius.circular(10);

  final GlobalKey? target;

  /// Global bounds of [target], or null when it is not currently on screen.
  Rect? _targetRect() {
    final box = target?.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      return null;
    }
    return box.localToGlobal(Offset.zero) & box.size;
  }

  @override
  Widget build(BuildContext context) =>
      // Taps are already swallowed by the tour's own barrier; this must not
      // add a second opaque layer over the control it is highlighting.
      IgnorePointer(child: CustomPaint(size: Size.infinite, painter: _ScrimPainter(_targetRect())));
}

class _ScrimPainter extends CustomPainter {
  const _ScrimPainter(this.hole);

  final Rect? hole;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = TifoSpotlight._scrim;
    final window = hole;
    if (window == null) {
      canvas.drawRect(Offset.zero & size, paint);
      return;
    }
    // Even-odd fill: the scrim covers everything the window does not.
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRRect(RRect.fromRectAndRadius(window, TifoSpotlight._radius));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ScrimPainter oldDelegate) => oldDelegate.hole != hole;
}
