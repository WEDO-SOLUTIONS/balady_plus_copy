import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/shared/config/package_config.dart';

class CenterCompassWidget extends StatelessWidget {
  const CenterCompassWidget({required this.backgroundColor, super.key});

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: SvgPicture.asset(
            'assets/icons/svg/ic_arrow_compass.svg',
            package: PackageConfig.packageName,
          ),
        ),
      );
}
