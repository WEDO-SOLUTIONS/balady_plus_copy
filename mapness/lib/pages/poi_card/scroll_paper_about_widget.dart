import 'package:flutter/material.dart';
import 'package:mapness/pages/poi_card/scroll_about_widget.dart';

class ScrollPaper extends StatefulWidget {
  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double roughness;

  const ScrollPaper({
    required this.child,
    super.key,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.roughness = 1.7,
  });

  @override
  State<ScrollPaper> createState() => _ScrollPaperState();
}

class _ScrollPaperState extends State<ScrollPaper> {
  double _childHeight = 0;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;

      final bodyTop = ScrollPainter.topVisualBottomForWidth(width);

      final rollLeft = ScrollPainter.rollLeftForWidth(width);
      final rollRight = ScrollPainter.rollRightForWidth(width);

      final stroke = ScrollPainter.strokeWidthForWidth(width);
      final visualInset = stroke / 2 + ScrollPainter.maxRoughnessInset(width, widget.roughness);

      final bodyLeft = rollLeft + visualInset;
      final bodyRight = rollRight - visualInset;
      final bodyWidth = bodyRight - bodyLeft;

      return Padding(
        padding: widget.padding,
        child: Stack(
          children: [
            Offstage(
              child: _MeasureSize(
                onChange: (size) {
                  if (size.height != _childHeight) {
                    setState(() => _childHeight = size.height);
                  }
                },
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: bodyWidth),
                  child: Padding(padding: widget.margin, child: widget.child),
                ),
              ),
            ),

            if (_childHeight > 0)
              SizedBox(
                width: width,
                height: bodyTop + _childHeight,
                child: CustomPaint(
                  painter: ScrollPainter(roughness: widget.roughness),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: bodyTop),

                      Padding(
                        padding: widget.margin,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: bodyWidth - widget.margin.horizontal),
                            child: widget.child,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}

class _MeasureSize extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onChange;

  const _MeasureSize({required this.child, required this.onChange});

  @override
  State<_MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<_MeasureSize> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = context.size;
      if (size != null && size != _oldSize) {
        _oldSize = size;
        widget.onChange(size);
      }
    });

    return widget.child;
  }
}
