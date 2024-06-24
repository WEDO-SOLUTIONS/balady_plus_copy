import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// unused for now but may be required after first demo
class _AdditionalManeuver extends StatelessWidget {
  const _AdditionalManeuver({
    required this.instruction,
    required this.iconPath,
  });
  final String instruction;
  final String iconPath;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          color: context.color.surfaceBasePrimary,
        ),
        child: Column(
          children: [
            const SizedBox(height: 25),
            Row(
              children: [
                Text(
                  instruction,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                SvgPicture.asset(
                  iconPath,
                  width: 28,
                  height: 28,
                  colorFilter: const ColorFilter.mode(
                    NonThemeColor.color61,
                    BlendMode.srcATop,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
