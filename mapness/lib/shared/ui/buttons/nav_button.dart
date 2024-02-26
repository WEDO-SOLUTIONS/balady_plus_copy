import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

// TODO: rewrite according to UIKit
class NavButton extends StatelessWidget {
  const NavButton({
    required this.onTap, required this.icon, super.key,
  });

  final void Function() onTap;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          color: NonThemeColor.color11,
        ),
        padding: const EdgeInsets.all(8),
        child: SvgPicture.asset(
          icon,
          package: PackageConfig.packageName,
          color: context.color.text_and_icons_base_primary,
          // colorFilter: ColorFilter.mode(
          //   context.color.text_and_icons_base_primary,
          //   BlendMode.srcATop,
          // ),
        ),
      ),
    );
  }
}
