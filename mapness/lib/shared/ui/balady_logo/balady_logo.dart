import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class BaladyLogo extends StatelessWidget {
  final double? height;
  final double? width;

  const BaladyLogo({
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height ?? Spacing.$10x,
        width: width ?? 95,
        child: SvgPicture.asset(
          context.isLTR ? 'assets/images_svg/en_balady_logo.svg' : 'assets/images_svg/ar_balady_logo.svg',
          fit: BoxFit.cover,
          package: PackageConfig.packageName,
        ),
      );
}
