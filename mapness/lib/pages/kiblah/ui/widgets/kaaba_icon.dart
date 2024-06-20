import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';

class KaabaIcon extends StatelessWidget {
  const KaabaIcon({required this.isCorrect, super.key});

  final bool isCorrect;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: isCorrect ? NonThemeColor.color3 : context.color.strokeAccent,
          borderRadius: BorderRadius.circular(CornerRadius.baseContainer),
        ),
        width: 32,
        height: 32,
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/svg/ic_kiblah.svg',
            height: 16,
            width: 16,
            package: PackageConfig.packageName,
          ),
        ),
      );
}
