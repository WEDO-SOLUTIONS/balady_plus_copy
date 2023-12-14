import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';

class RouteTypeSwitch extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String iconAsset;
  final bool isChoosed;

  const RouteTypeSwitch({
    super.key,
    required this.onPressed,
    required this.title,
    required this.iconAsset,
    required this.isChoosed,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor =
        isChoosed ? const Color(0xff1E2A36) : const Color(0xff8E949A);

    return Material(
      color: isChoosed ? const Color(0x0D1E2A36) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 12,
            top: 6,
            bottom: 6,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                iconAsset,
                height: 30,
                package: PackageConfig.packageName,
                colorFilter: ColorFilter.mode(
                  titleColor,
                  BlendMode.srcATop,
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                title,
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .accentS
                    .copyWith(
                      color: titleColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
