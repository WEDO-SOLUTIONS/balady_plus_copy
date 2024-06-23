import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';

class CloseHappinessButton extends StatelessWidget {
  const CloseHappinessButton({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: context.color.surfaceBasePrimary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(
            'assets/icons/svg/ic_close.svg',
            height: 16,
            width: 16,
            package: PackageConfig.packageName,
            colorFilter: const ColorFilter.mode(
              NonThemeColor.color40,
              BlendMode.srcIn,
            ),
          ),
        ),
      );
}
