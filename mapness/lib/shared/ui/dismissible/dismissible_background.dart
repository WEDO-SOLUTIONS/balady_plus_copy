import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// Custom background for Dismissible widget
class AppDismissibleBackground extends StatelessWidget {
  /// For border radius and right drawing
  final bool isFirst;

  /// For border radius and right drawing
  final bool isLast;

  /// The radius of the background if it is the first or last item
  static const radius = Radius.circular(RadiusBorder.xl);

  const AppDismissibleBackground({
    required this.isFirst,
    required this.isLast,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: context.staticColor.surfaceStatusNegative,
          borderRadius: BorderRadius.only(
            topRight: isFirst && context.isLTR ? radius : Radius.zero,
            topLeft: isFirst && !context.isLTR ? radius : Radius.zero,
            bottomRight: isLast && context.isLTR ? radius : Radius.zero,
            bottomLeft: isLast && !context.isLTR ? radius : Radius.zero,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Spacing.$8x.widthBox,
            Text(
              context.l10n.delete,
              style: context.textStyle.footNoteBold.copyWith(color: Colors.white),
            ),
            Spacing.$8x.widthBox,
          ],
        ),
      );
}
