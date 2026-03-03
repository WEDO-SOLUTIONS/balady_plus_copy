import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: '13. Tabs',
  type: Widget,
)
Widget tabsDemo(BuildContext context) {
  final isSelected = context.knobs.boolean(label: 'Selected');
  final isIconDisplayed = context.knobs.boolean(label: 'Display icon');
  final counterValue = context.knobs.intOrNull.input(label: 'Counter value', initialValue: 2);
  final title = context.knobs.string(label: 'Title', initialValue: 'Label');

  final showFirst = context.knobs.boolean(label: 'Show first tab');
  final tabsCount = context.knobs.int.slider(
    label: 'Number of tabs',
    initialValue: 3,
    max: 6,
    divisions: 6,
  );

  final noPaddingForIndex = context.knobs.intOrNull.slider(
    label: 'No padding for item',
    max: 3,
  );

  final widthSize = context.knobs.double.slider(
    label: 'Width of the tabs row',
    initialValue: 1,
    min: 0.1,
    max: 1,
  );

  final isLtr = Directionality.of(context) == TextDirection.ltr;

  return Padding(
    padding: const EdgeInsets.only(top: 40),
    child: SizedBox(
      width: 440,
      child: ColoredBox(
        color: context.colors.backgroundSurface1,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Single tab:',
                style: context.textStyles.bodyLargeSemiBold.copyWith(
                  color: context.colors.foregroundDefault,
                ),
              ),
              const SizedBox(height: 10),
              Tabs(
                onTap: () {},
                title: title,
                isSelected: isSelected,
                icon: isIconDisplayed ? GeneralIcons.placeholder : null,
                counterValue: counterValue,
              ),
              const SizedBox(height: 20),
              Text(
                'Tabs row:',
                style: context.textStyles.bodyLargeSemiBold.copyWith(
                  color: context.colors.foregroundDefault,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: widthSize < 1
                    ? BoxDecoration(
                        border: Border.all(color: Colors.red),
                      )
                    : null,
                width: widthSize * 400,
                child: TabsRow(
                  showFirstTab: showFirst,
                  tabs: [
                    TabContent(title: isLtr ? 'Info' : 'معلومات', isExpanded: noPaddingForIndex != 0),
                    TabContent(title: isLtr ? 'Photos' : 'صور', counterValue: 248, isExpanded: noPaddingForIndex != 1),
                    TabContent(title: isLtr ? 'Menu' : 'مينيو', isExpanded: noPaddingForIndex != 2),
                    TabContent(title: isLtr ? 'Organization' : 'المنظمات', counterValue: 248),
                    TabContent(title: title),
                    TabContent(title: title),
                  ].take(tabsCount).toList(),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
}
