import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class FeedbackScrollHandle extends StatelessWidget {
  const FeedbackScrollHandle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.$1_5x),
        child: Center(
          child: Container(
            height: Spacing.$1x,
            width: Spacing.$8x,
            decoration: BoxDecoration(
              color: context.color.surfaceContrastMid,
              borderRadius: BorderRadius.circular(RadiusBorder.full),
            ),
          ),
        ),
      );
}
