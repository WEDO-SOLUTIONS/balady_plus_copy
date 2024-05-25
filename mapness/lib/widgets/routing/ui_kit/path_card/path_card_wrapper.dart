import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.horizontalContentPaddingChipsRow,
          vertical: Spacing.horizontalContentPaddingChipsRow,
        ),
        decoration: ShapeDecoration(
          shape: smoothBorder(CornerRadius.smallContainer),
          color: context.color.surfaceBaseSecondary,
        ),
        child: child,
      );
}
