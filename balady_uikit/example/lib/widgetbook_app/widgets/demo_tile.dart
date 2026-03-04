import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class DemoTile extends StatelessWidget {
  final String title;
  const DemoTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Spacing.$0_5x, horizontal: Spacing.$4x),
      decoration: BoxDecoration(
        color: context.colors.backgroundSurface2,
        border: Border.all(color: context.colors.borderMuted),
        borderRadius: BorderRadius.circular(RadiusBorder.m),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: context.textStyles.bodyLargeMedium.copyWith(color: context.colors.foregroundSoft),
      ),
    );
  }
}
