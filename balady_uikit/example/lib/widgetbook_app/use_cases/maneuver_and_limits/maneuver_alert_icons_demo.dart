// ignore_for_file: prefer_expression_function_bodies, prefer_const_constructors

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/utils/constants.dart';
import 'package:example/widgetbook_app/use_cases/maneuver_and_limits/demo_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ManeuverAlertIcons extends StatelessWidget {
  const ManeuverAlertIcons({super.key});

  @override
  Widget build(BuildContext context) {
    const values = BaladyManeuverInstruction.values;

    return DemoContainer(
      title: 'Maneuver-allert_icons',
      height: 400,
      child: ListView(
        children: values.map((e) => IconWidget(instruction: e)).toList(),
      ),
    );
  }
}

class IconWidget extends StatelessWidget {
  final BaladyManeuverInstruction? instruction;
  const IconWidget({
    required this.instruction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (instruction == BaladyManeuverInstruction.none) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (instruction?.iconPath != null)
            SvgPicture.asset(
              instruction!.iconPath!,
              package: packageName,
              width: 36,
              height: 36,
            ),
          if (instruction?.iconPath == null) const SizedBox(width: 36, height: 36, child: Placeholder()),
          const SizedBox(width: 8),
          Text(instruction?.name ?? '', style: context.textStyles.h4SemiBold),
        ],
      ),
    );
  }
}
