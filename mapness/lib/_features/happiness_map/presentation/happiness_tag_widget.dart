import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class HappinessTagWidget extends StatelessWidget {

  const HappinessTagWidget({
    required this.onPressed, required this.isSelected, required this.title, required this.iconAsset, required this.tagSizeGroup, super.key,
  });
  final String title;
  final String iconAsset;
  final void Function() onPressed;
  final bool isSelected;
  final AutoSizeGroup tagSizeGroup;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color:
            isSelected ? context.color.stroke_accent : context.color
                .surface_base_primary,
            width: 2,),
        color: NonThemeColor.color37,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                iconAsset,
                package: PackageConfig.packageName,
              ),
              const Spacer(),
              AutoSizeText(
                title,
                maxLines: 2,
                wrapWords: false,
                minFontSize: 8,
                group: tagSizeGroup,
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .accentXS
                    .copyWith(color: context.color.text_and_icons_base_primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
