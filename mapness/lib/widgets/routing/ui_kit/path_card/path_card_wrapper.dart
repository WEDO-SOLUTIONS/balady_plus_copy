import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:flutter/material.dart';

/// This widget is used to wrap the child content with a decoration, padding and alignment
///
/// It is used only for simplification of the code. It is not necessary to use it and it is not reflected in the design
///
/// Example:
/// ```dart
/// PathCardWrapper(
///    child: Column(...),
///   alignment: Alignment.center,
/// )
/// ```
class PathCardWrapper extends StatelessWidget {
  final Widget child;
  final AlignmentGeometry? alignment;

  const PathCardWrapper({
    required this.child,
    super.key,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) => Container(
        alignment: alignment,
        padding: const EdgeInsets.all(Spacing.$3x),
        decoration: ShapeDecoration(
          shape: smoothBorder(RadiusBorder.l),
          color: context.colors.backgroundSurface4,
        ),
        child: child,
      );
}
