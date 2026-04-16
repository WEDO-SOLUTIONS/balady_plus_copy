import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class ArrowDragger extends StatelessWidget {
  final Color? draggerColor;
  final Color? backgroundColor;

  const ArrowDragger({
    this.draggerColor,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedColor = draggerColor ?? context.colors.backgroundSurface5;

    final resolvedBackground =
        backgroundColor ?? Theme.of(context).bottomSheetTheme.backgroundColor ?? Colors.transparent;

    return ColoredBox(
      color: resolvedBackground,
      child: SizedBox(
        width: double.infinity,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
            child: SizedBox(
              width: 32,
              height: 7,
              child: CustomPaint(
                painter: _CurvedArrowPainter(resolvedColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CurvedArrowPainter extends CustomPainter {
  final Color color;

  const _CurvedArrowPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const horizontalPadding = 4.0;

    const startX = horizontalPadding;
    final endX = size.width - horizontalPadding;

    final bottomY = size.height - 1;

    final controlX = size.width / 2;
    const controlY = 3.0;

    final path = Path()
      ..moveTo(startX, bottomY)
      ..lineTo(controlX, controlY)
      ..lineTo(endX, bottomY);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
