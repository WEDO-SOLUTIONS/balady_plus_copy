import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Tabs Row 2.0',
  type: Widget,
)
Widget tabsRowV2WidgetDemo(BuildContext context) {
  final widthSize = context.knobs.double.slider(
    label: 'Width of the chips row',
    initialValue: 0.5,
    min: 0.1,
    max: 1,
  );

  final tabsCount = context.knobs.int.slider(
    label: 'Number of tabs',
    initialValue: 3,
    max: 6,
    divisions: 6,
  );

  final isLtr = Directionality.of(context) == TextDirection.ltr;

  return ColoredBox(
    color: context.colors.backgroundSurface4,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Buttons List row:',
                  style: context.textStyles.h2SemiBold.copyWith(
                    color: context.colors.foregroundDefault,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: widthSize < 1 ? Border.all(color: Colors.red) : null,
                  ),
                  width: widthSize * 450,
                  child: TabsRow.v2(
                    onIndexChanged: (_) {},
                    tabsContent: [
                      TabsRowV2Content(
                        title: isLtr ? 'Info' : 'العودة إلى المنزل',
                      ),
                      TabsRowV2Content(
                        trailingIcon: TabsV2WidgetBuilder(
                            ({required isSelected}) => _trailingIcon(context, isSelected: isSelected)),
                        title: isLtr ? 'Photos' : 'للعمل',
                      ),
                      TabsRowV2Content(
                        title: isLtr ? 'Menu' : 'المساجد',
                      ),
                      TabsRowV2Content(
                        title: isLtr ? 'Label' : 'المساجد',
                      ),
                      TabsRowV2Content(
                        title: isLtr ? 'Label' : 'المساجد',
                      ),
                      TabsRowV2Content(
                        title: isLtr ? 'Label' : 'المساجد',
                      ),
                      TabsRowV2Content(
                        title: isLtr ? 'Label' : 'المساجد',
                      ),
                      TabsRowV2Content(
                        title: isLtr ? 'Label' : 'المساجد',
                      ),
                      TabsRowV2Content(
                        title: isLtr ? 'Label' : 'المساجد',
                      ),
                      TabsRowV2Content(
                        title: isLtr ? 'Label' : 'المساجد',
                      ),
                    ].take(tabsCount).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _trailingIcon(BuildContext context, {required bool isSelected}) {
  return const Counter(
    count: 28,
    colorScheme: CounterColorScheme.neutral,
  );
}
