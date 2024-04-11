import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class IwishActionDriveButton extends StatelessWidget {

  const IwishActionDriveButton({
    required this.label, super.key,
    this.onPressed,
  });
  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) => Material(
      color: context.color.strokeAccent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/svg/ic_car.svg',
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
                package: PackageConfig.packageName,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: Theme.of(context).extension<ThemeTextStyles>()!.text.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
}
