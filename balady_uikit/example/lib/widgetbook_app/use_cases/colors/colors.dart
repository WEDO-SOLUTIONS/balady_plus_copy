import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/app_theme.dart' as app_theme;
import 'package:balady_uikit/core/colorsV2/base_colors.dart' as base_colors;
import 'package:balady_uikit/core/colorsV2/values/value_color_list.dart' as values_list;
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

enum ColorTypes {
  dark,
  light,
  saudiDay,
}

extension ColorTypesExt on ColorTypes {
  List<Widget>? palette() {
    return switch (this) {
      ColorTypes.light => app_theme.AppColorsThemeV3.palette(
          themes: BaladyAppThemes.light,
        ).colorList().map((colorInfo) => container(colorInfo)).toList(),
      ColorTypes.dark => app_theme.AppColorsThemeV3.palette(
          themes: BaladyAppThemes.dark,
        ).colorList().map((colorInfo) => container(colorInfo)).toList(),
      ColorTypes.saudiDay => app_theme.AppColorsThemeV3.palette(
          themes: BaladyAppThemes.saudiDay,
        ).colorList().map((colorInfo) => container(colorInfo)).toList(),
    };
  }
}

@widgetbook.UseCase(
  name: '001. colorsDemo',
  type: Widget,
)
Widget colorsDemo(BuildContext context) {
  final list = context.knobs.list(label: 'COLORS', options: [
    ColorTypes.light,
    ColorTypes.dark,
    ColorTypes.saudiDay,
  ]);

  return SingleChildScrollView(
    child: ColoredBox(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                const Divider(),
                const SizedBox(height: 12),
                const Text('Base colors', style: TextStyle(fontSize: 18, color: Colors.black)),
                ...base_colors.BaseColors.colorList().map((c) => containerBase(c)).toList(),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 12),
                const Text('Values', style: TextStyle(fontSize: 18, color: Colors.black)),
                ...values_list.ValuesColorList.list().map((c) => containerBase(c)).toList(),
                const SizedBox(height: 24),
                Text(
                  list.name,
                  style: const TextStyle(fontSize: 24, color: Colors.black),
                ),
                ...?list.palette(),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

AppColorsThemeExt palette() {
  return AppColorsThemeExt.palette(isDark: true);
}

Widget container(app_theme.ColorInfo colorInfo) => Builder(
    builder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(colorInfo.name,
                        style: context.textStyles.bodyLargeRegular.copyWith(
                          color: context.colors.foregroundDefault,
                        )),
                    SelectableText('Opacity: ${colorInfo.opacity}%',
                        style: context.textStyles.bodySmallRegular.copyWith(
                          color: context.colors.foregroundMuted,
                        )),
                    SelectableText(colorInfo.hex,
                        style: context.textStyles.bodySmallRegular.copyWith(
                          color: context.colors.foregroundMuted,
                        )),
                    SelectableText(colorInfo.parent,
                        style: context.textStyles.bodySmallRegular.copyWith(
                          color: context.colors.foregroundMuted,
                        )),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(12),
                    color: colorInfo.color,
                  ),
                  alignment: Alignment.center,
                  height: 50,
                  width: 200,
                ),
              ),
            ],
          ),
        ));

Widget containerBase(base_colors.ColorInfo colorInfo) => Builder(
    builder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(colorInfo.name,
                        style: context.textStyles.bodyLargeRegular.copyWith(
                          color: context.colors.foregroundDefault,
                        )),
                    SelectableText('Opacity: ${colorInfo.opacity}%',
                        style: context.textStyles.bodySmallRegular.copyWith(
                          color: context.colors.foregroundMuted,
                        )),
                    SelectableText(colorInfo.hex,
                        style: context.textStyles.bodySmallRegular.copyWith(
                          color: context.colors.foregroundMuted,
                        )),
                    SelectableText(colorInfo.parent,
                        style: context.textStyles.bodySmallRegular.copyWith(
                          color: context.colors.foregroundMuted,
                        )),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(12),
                    color: colorInfo.color,
                  ),
                  alignment: Alignment.center,
                  height: 50,
                  width: 200,
                ),
              ),
            ],
          ),
        ));
