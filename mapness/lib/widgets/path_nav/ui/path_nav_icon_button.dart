import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';

class PathNavIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String iconPath;

  const PathNavIconButton({
    super.key,
    required this.onPressed,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xffF4F4F5),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Container(
          height: 40,
          width: 40,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            package: PackageConfig.packageName,
            colorFilter: const ColorFilter.mode(
              Color(0xff1A1A1A),
              BlendMode.srcATop,
            ),
          ),
        ),
      ),
    );
  }
}
