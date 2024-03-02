import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';

class DeleteIcon extends StatelessWidget {
  const DeleteIcon({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onPressed,
      child: SvgPicture.asset(
        'assets/icons/svg/ic_minus_circle_red.svg',
        package: PackageConfig.packageName,
        width: 24,
        height: 24,
      ),
    );
}
