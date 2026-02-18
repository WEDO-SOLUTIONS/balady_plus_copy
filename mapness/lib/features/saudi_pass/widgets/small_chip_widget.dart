import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/widgets/decorated_smooth_radius.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class SmallChipWidget extends StatelessWidget {
  final String title;
  final bool isHighlighted;
  final VoidCallback? onTap;

  const SmallChipWidget({required this.isHighlighted, required this.title, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textColor = isHighlighted ? colors.accentOnAccent : colors.foregroundDefault;
    final textStyle = context.isLTR ? context.textStyleV3.bodySmallMedium : context.textStyleV3.bodySmallSemiBold;

    return DecoratedSmoothRadius(
      borderRadius: RadiusBorder.m,
      color: isHighlighted ? colors.accentSecondaryDefault : colors.neutralContainerDefault,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.color.surfaceOverlayPressed,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$3x),
          child: SizedBox(
            height: AppSizes.xs,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  textHeightBehavior: TextHeightBehavior(
                    applyHeightToLastDescent: Directionality.of(context) == TextDirection.ltr,
                  ),
                  style: textStyle.copyWith(color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
