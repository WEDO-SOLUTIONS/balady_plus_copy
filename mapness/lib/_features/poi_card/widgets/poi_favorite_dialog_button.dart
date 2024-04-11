import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PoiFavoriteDialogButton extends StatelessWidget {

  const PoiFavoriteDialogButton({
    required this.onTap, required this.iconAsset, required this.title, required this.showBorder, super.key,
  });
  final VoidCallback onTap;
  final String title;
  final String iconAsset;
  final bool showBorder;

  @override
  Widget build(BuildContext context) => Ink(
      decoration: showBorder
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: context.color.surfaceBasePrimary,
                ),
              ),
            )
          : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 14,
            top: 12,
            left: 16,
            right: 16,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).extension<ThemeTextStyles>()?.text,
                ),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset(
                iconAsset,
                package: PackageConfig.packageName,
                height: 24,
                width: 24,
                colorFilter: const ColorFilter.mode(
                  NonThemeColor.color16,
                  BlendMode.srcATop,
                ),
              ),
            ],
          ),
        ),
      ),
    );
}
