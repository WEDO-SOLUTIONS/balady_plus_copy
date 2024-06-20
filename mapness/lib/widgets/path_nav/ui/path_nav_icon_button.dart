import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';

class PathNavIconButton extends StatelessWidget {
  const PathNavIconButton({
    required this.onPressed,
    required this.iconPath,
    super.key,
  });
  final VoidCallback onPressed;
  final String iconPath;

  @override
  Widget build(BuildContext context) => Material(
        color: context.color.surfaceBasePrimary,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              package: PackageConfig.packageName,
              colorFilter: const ColorFilter.mode(
                NonThemeColor.color62,
                BlendMode.srcATop,
              ),
            ),
          ),
        ),
      );
}
