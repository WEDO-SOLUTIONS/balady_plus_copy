import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

class CenterCompassWidget extends StatelessWidget {
  final Color backgroundColor;

  const CenterCompassWidget({
    required this.backgroundColor,
    super.key,
  });

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
            Assets.icons.svg.icArrowCompass.keyName,
          ),
        ),
      );
}
