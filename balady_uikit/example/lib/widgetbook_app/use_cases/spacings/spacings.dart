import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: '003. spacingsDemo',
  type: Widget,
)
Widget spacingsDemo(BuildContext context) {
  return SingleChildScrollView(
    child: ColoredBox(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(children: [
              const Text(
                'Paddings',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              ...spacingDemoInfoList.map(
                (spacing) => Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Text(
                        spacing.name,
                        style: context.textStyles.bodyLargeMedium,
                      ),
                      const SizedBox(width: 32),
                      Container(
                        width: spacing.value,
                        height: 24,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Border Radiuses, square: 48 x 48',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              ...borderRadiusDemoInfoList.map(
                (spacing) => Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Text(
                        spacing.name,
                        style: context.textStyles.bodyLargeMedium,
                      ),
                      const SizedBox(width: 32),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(spacing.value),
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    ),
  );
}

List<SpacingDemoInfo> get spacingDemoInfoList {
  return [
    SpacingDemoInfo(name: 'Value: none', value: Spacing.none, type: SpacingDemoType.padding),
    SpacingDemoInfo(name: 'Value: 01px', value: Spacing.px, type: SpacingDemoType.padding),
    SpacingDemoInfo(name: 'Value: 02px', value: Spacing.$0_5x, type: SpacingDemoType.padding),
    SpacingDemoInfo(name: 'Value: 04px', value: Spacing.$1x, type: SpacingDemoType.padding),
    SpacingDemoInfo(name: 'Value: 08px', value: Spacing.$2x, type: SpacingDemoType.padding),
    SpacingDemoInfo(name: 'Value: 12px', value: Spacing.$3x, type: SpacingDemoType.padding),
    SpacingDemoInfo(name: 'Value: 16px', value: Spacing.$4x, type: SpacingDemoType.padding),
    SpacingDemoInfo(name: 'Value: 20px', value: Spacing.$5x, type: SpacingDemoType.padding),
    SpacingDemoInfo(name: 'Value: 24px', value: Spacing.$6x, type: SpacingDemoType.padding),
    SpacingDemoInfo(name: 'Value: 28px', value: Spacing.$8x, type: SpacingDemoType.padding),
    SpacingDemoInfo(name: 'Value: 32px', value: Spacing.$10x, type: SpacingDemoType.padding),
    SpacingDemoInfo(name: 'Value: 48px', value: Spacing.$12x, type: SpacingDemoType.padding),
    SpacingDemoInfo(name: 'Value: 64px', value: Spacing.$16x, type: SpacingDemoType.padding),
  ];
}

List<SpacingDemoInfo> get borderRadiusDemoInfoList {
  return [
    SpacingDemoInfo(name: 'Value: baseSharp, 8px', value: RadiusBorder.baseSharp, type: SpacingDemoType.borderRadius),
    SpacingDemoInfo(name: 'Value: full, 999px', value: RadiusBorder.full, type: SpacingDemoType.borderRadius),
    SpacingDemoInfo(name: 'Value: none', value: RadiusBorder.none, type: SpacingDemoType.borderRadius),
    SpacingDemoInfo(name: 'Value: xxs, 2px', value: RadiusBorder.xxs, type: SpacingDemoType.borderRadius),
    SpacingDemoInfo(name: 'Value: xs, 4px', value: RadiusBorder.xs, type: SpacingDemoType.borderRadius),
    SpacingDemoInfo(name: 'Value: s, 6px', value: RadiusBorder.s, type: SpacingDemoType.borderRadius),
    SpacingDemoInfo(name: 'Value: m, 8px', value: RadiusBorder.m, type: SpacingDemoType.borderRadius),
    SpacingDemoInfo(name: 'Value: ml, 10px', value: RadiusBorder.ml, type: SpacingDemoType.borderRadius),
    SpacingDemoInfo(name: 'Value: l, 12px', value: RadiusBorder.l, type: SpacingDemoType.borderRadius),
    SpacingDemoInfo(name: 'Value: xl, 16px', value: RadiusBorder.xl, type: SpacingDemoType.borderRadius),
    SpacingDemoInfo(name: 'Value: xxl, 24px', value: RadiusBorder.xxl, type: SpacingDemoType.borderRadius),
  ];
}

enum SpacingDemoType {
  padding,
  borderRadius,
}

class SpacingDemoInfo {
  final String name;
  final double value;
  final SpacingDemoType type;

  SpacingDemoInfo({
    required this.name,
    required this.value,
    required this.type,
  });
}
