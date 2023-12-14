import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';

// TODO: rewrite according to UIKit
class NavButton extends StatelessWidget {
  const NavButton({
    super.key,
    required this.onTap,
    required this.icon,
  });

  final void Function() onTap;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          color: Color(0x0D1E2A36),
        ),
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          icon,
          package: PackageConfig.packageName,
          colorFilter: const ColorFilter.mode(
            Color(0xB21E2A36),
            BlendMode.srcATop,
          ),
        ),
      ),
    );
  }
}
