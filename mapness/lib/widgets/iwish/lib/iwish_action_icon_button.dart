import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class IwishActionIconButton extends StatelessWidget {
  final String iconAsset;
  final VoidCallback? onPressed;

  const IwishActionIconButton({
    super.key,
    required this.iconAsset,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.color.surface_base_primary,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          child: SvgPicture.asset(
            iconAsset,
            package: PackageConfig.packageName,
          ),
        ),
      ),
    );
  }
}
