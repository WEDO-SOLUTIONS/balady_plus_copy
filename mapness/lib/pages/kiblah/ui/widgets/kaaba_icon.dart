import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class KaabaIcon extends StatelessWidget {
  const KaabaIcon({required this.isCorrect, super.key});

  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    const _size = Size(32, 32);

    return Container(
      decoration: BoxDecoration(
        color: isCorrect ? NonThemeColor.color3 : context.color.strokeAccent,
        borderRadius: BorderRadius.circular(CornerRadius.baseContainer),
      ),
      width: _size.width,
      height: _size.height,
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
}
