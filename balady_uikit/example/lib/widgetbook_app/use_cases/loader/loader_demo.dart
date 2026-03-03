import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: '06. Loader',
  type: Widget,
)
Widget loadingWidgetDemo(BuildContext context) {
  const containerPadding = 12.0;

  final isHorizontal = context.knobs.boolean(label: 'Horizontal');
  final isDisplayTitle = context.knobs.boolean(label: 'Display title');
  final size = context.knobs.double.slider(label: 'Size', initialValue: 48, min: 24, max: 48, divisions: 2);
  final title = context.knobs.string(label: 'Title', initialValue: 'Loading');

  return Padding(
    padding: const EdgeInsets.only(left: containerPadding * 2),
    child: SizedBox(
      width: 330,
      child: Column(
        children: [
          Text(
            Directionality.of(context).name,
            textAlign: TextAlign.center,
            style: context.textStyles.h1Medium,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(containerPadding),
                child: Loading(
                  title: title,
                  isDisplayTitle: isDisplayTitle,
                  orientation: isHorizontal ? Axis.horizontal : Axis.vertical,
                  size: size == 24
                      ? LoaderSize.small
                      : size == 48
                          ? LoaderSize.large
                          : LoaderSize.medium,
                ),
              ),
              ColoredBox(
                color: context.colors.accentContainerDefault,
                child: Padding(
                  padding: const EdgeInsets.all(containerPadding),
                  child: Loading(
                    title: title,
                    style: Brightness.light,
                    isDisplayTitle: isDisplayTitle,
                    orientation: isHorizontal ? Axis.horizontal : Axis.vertical,
                    size: size == 24
                        ? LoaderSize.small
                        : size == 48
                            ? LoaderSize.large
                            : LoaderSize.medium,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
