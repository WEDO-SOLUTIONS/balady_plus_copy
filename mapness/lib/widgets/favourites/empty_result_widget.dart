import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

class EmptyResultWidget extends StatelessWidget {
  const EmptyResultWidget({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SvgPicture.asset(
            Assets.imagesSvg.emptySearch.keyName,
            width: 240,
            height: 140,
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            style: context.textStyle.heading2.copyWith(
              color: context.color.textAndIconsBasePrimary,
            ),
          ),
        ],
      );
}
