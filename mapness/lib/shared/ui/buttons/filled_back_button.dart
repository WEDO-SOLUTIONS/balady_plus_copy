import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FilledBackButton extends StatelessWidget {
  final VoidCallback onClose;
  const FilledBackButton({required this.onClose, super.key});

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Material(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onClose,
            child: Container(
              constraints: const BoxConstraints(minWidth: 48),
              height: 48,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/svg/ic_chevron_left.svg',
                    height: 24,
                    width: 24,
                    matchTextDirection: true,
                    package: PackageConfig.packageName,
                    colorFilter: ColorFilter.mode(
                      context.color.text_and_icons_base_primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          )));
}
