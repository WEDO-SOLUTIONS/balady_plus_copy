import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

class MBCMood extends StatelessWidget {
  const MBCMood({this.color = Colors.white, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) => Row(
        children: CommonFunctions.isAppAR ? items(context).reversed.toList() : items(context),
      );

  List<Widget> items(BuildContext context) => [
        Assets.icons.svg.icMbcMood.svg(colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
        const SizedBox(width: 8),
        Text('MBC MOOD', style: context.textStyles.bodyLargeSemiBold.copyWith(color: color)),
      ];
}
