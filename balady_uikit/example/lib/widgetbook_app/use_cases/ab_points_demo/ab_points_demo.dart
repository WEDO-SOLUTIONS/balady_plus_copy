import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: '20. ABPoints',
  type: Widget,
)
Widget abPointsDemo(BuildContext context) {
  return ColoredBox(
    color: context.colors.backgroundSurface1,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Change = on',
                style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
              ),
              const SizedBox(height: 8),
              ABPoints(
                locations: const ['Start', 'Finish'],
                change: ABPointsChange.off,
                onTap: () {},
              ),
              const SizedBox(height: 16),
              Text(
                'Change = off',
                style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
              ),
              const SizedBox(height: 8),
              ABPoints(
                locations: const ['Start', 'Finish'],
                change: ABPointsChange.on,
                onTap: () {},
              ),
              const SizedBox(height: 16),
              Text(
                'Change = none',
                style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
              ),
              const SizedBox(height: 8),
              ABPoints(
                locations: const ['Start', 'Finish'],
                change: ABPointsChange.none,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
