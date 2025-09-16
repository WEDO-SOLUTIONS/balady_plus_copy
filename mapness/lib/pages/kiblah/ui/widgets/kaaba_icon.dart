import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

class KaabaIcon extends StatelessWidget {
  const KaabaIcon({required this.isCorrect, super.key});

  final bool isCorrect;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: isCorrect ? NonThemeColor.color3 : context.colors.accentOnContainer,
          borderRadius: BorderRadius.circular(RadiusBorder.xl),
        ),
        width: 32,
        height: 32,
        child: Center(
          child: SvgPicture.asset(
            Assets.icons.svg.icKiblah.keyName,
            height: 16,
            width: 16,
          ),
        ),
      );
}
