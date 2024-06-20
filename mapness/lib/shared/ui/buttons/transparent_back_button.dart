import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';

class TransparentBackButton extends StatelessWidget {
  const TransparentBackButton({required this.onClose, super.key});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType.transparency,
        color: Colors.transparent,
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
                  package: PackageConfig.packageName,
                  matchTextDirection: true,
                  colorFilter: ColorFilter.mode(
                    context.color.surfaceBaseTertiary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
