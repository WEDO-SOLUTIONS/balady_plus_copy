import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class QuickActionButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Widget? widget;
  final VoidCallback onTap;

  static const buttonSize = 73.0;

  const QuickActionButton({
    required this.text,
    required this.onTap,
    this.icon,
    this.widget,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          InkWell(
            onTap: onTap,
            child: SizedBox(
              height: buttonSize,
              width: buttonSize,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(RadiusBorder.xl),
                  color: context.colorsV3.backgroundSurface1,
                  boxShadow: Shadows.s,
                ),
                child: Center(
                  child: widget ??
                      Icon(
                        icon,
                        size: Spacing.$6x + Spacing.$1x,
                        color: context.colorsV3.accentDefault,
                      ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: Spacing.$1x + Spacing.$0_5x),
            child: Text(
              text,
              style: context.textStyleV3.captionSmallMedium,
            ),
          ),
        ],
      );
}
