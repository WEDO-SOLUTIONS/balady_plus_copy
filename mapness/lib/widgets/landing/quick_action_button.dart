import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class QuickActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  static const buttonSize = 73.0;

  const QuickActionButton({required this.text, required this.icon, required this.onTap, super.key});

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
              color: context.colors.backgroundSurface1,
              boxShadow: Shadows.s,
            ),
            child: Center(
              child: Icon(icon, size: Spacing.$6x + Spacing.$1x, color: context.colors.accentDefault),
            ),
          ),
        ),
      ),
      SizedBox(
        width: buttonSize,
        child: Padding(
          padding: const EdgeInsets.only(top: Spacing.$1x + Spacing.$0_5x),
          child: Text(
            text,
            style: context.textStyles.captionSmallMedium.copyWith(color: context.colors.foregroundDefault),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ],
  );
}
