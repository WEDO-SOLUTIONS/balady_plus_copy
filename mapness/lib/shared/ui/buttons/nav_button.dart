import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// TODO: rewrite according to UIKit
class NavButton extends StatelessWidget {
  const NavButton({
    required this.onTap,
    required this.icon,
    super.key,
  });

  final void Function() onTap;
  final String icon;

  @override
  Widget build(BuildContext context) => GestureDetector(
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
            colorFilter: ColorFilter.mode(
              context.color.textAndIconsBasePrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
      );
}
