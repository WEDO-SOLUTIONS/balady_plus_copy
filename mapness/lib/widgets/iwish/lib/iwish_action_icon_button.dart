import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';

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
      color: const Color(0xffF4F4F5),
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
