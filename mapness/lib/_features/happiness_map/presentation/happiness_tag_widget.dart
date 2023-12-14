import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mapness/shared/config/package_config.dart';

class HappinessTagWidget extends StatelessWidget {
  final String title;
  final String iconAsset;
  final void Function() onPressed;
  final bool isSelected;

  const HappinessTagWidget({
    super.key,
    required this.onPressed,
    required this.isSelected,
    required this.title,
    required this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color:
                isSelected ? const Color(0xff4CA5B4) : const Color(0xffddeef1),
            width: 2),
        color: const Color(0x194CA5B4),
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
              Text(
                title,
                style: Theme.of(context).extension<ThemeTextStyles>()!.accentXS.copyWith(color: const Color(0xFF1D2A36)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
