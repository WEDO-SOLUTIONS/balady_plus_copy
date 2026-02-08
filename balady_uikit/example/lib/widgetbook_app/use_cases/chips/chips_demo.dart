// ignore_for_file: unused_import, avoid_print

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:example/widgetbook_app/widgets/demo_tile.dart';
import 'package:flutter/material.dart';
import 'package:urbi_utils/urbi_utils.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: '08. Chips',
  type: Widget,
)
Widget chipsWidgetWork(BuildContext context) {
  final title = context.knobs.stringOrNull(label: 'Title', initialValue: 'Title') ?? 'Title';
  final label = context.knobs.stringOrNull(label: 'Label', initialValue: 'Label');
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final isSelected = context.knobs.boolean(label: 'Selected', initialValue: false);
  final isTrailingPressedEnabled = context.knobs.boolean(label: 'Trailing pressed enabled', initialValue: true);
  final type = context.knobs.list(label: 'Chips type', options: ChipsType.values, initialOption: ChipsType.neutral);

  final widthSize = context.knobs.double.slider(
    label: 'Width of the chips row',
    initialValue: 0.5,
    min: 0.1,
    max: 1,
  );

  final isLtr = Directionality.of(context) == TextDirection.ltr;
  final textLTR = isLtr ? 'Left to right' : 'Right to left';
  final textForChips = isEnabled ? 'Default or Pressed' : 'Disabled';

  return SingleChildScrollView(
    clipBehavior: Clip.none,
    child: Center(
      child: ColoredBox(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DemoTile(title: type.name.capitalize()),
              const SizedBox(height: 30),
              DemoTile(title: textLTR),
              const SizedBox(height: 30),
              DemoTile(title: textForChips),
              const SizedBox(height: 30),
              Wrap(
                direction: Axis.horizontal,
                spacing: 16,
                runSpacing: 16,
                children: [
                  _ColumnOfChips(
                      textOfTitle: 'text',
                      isDisplayEnding: false,
                      isDisplayLeading: false,
                      isEnabled: isEnabled,
                      isSelected: isSelected,
                      title: title,
                      type: type,
                      isTrailingPressedEnabled: isTrailingPressedEnabled),
                  _ColumnOfChips(
                      textOfTitle: 'text text',
                      isDisplayEnding: false,
                      isDisplayLeading: false,
                      isEnabled: isEnabled,
                      isSelected: isSelected,
                      label: label,
                      title: title,
                      type: type,
                      isTrailingPressedEnabled: isTrailingPressedEnabled),
                  _ColumnOfChips(
                      textOfTitle: 'icon1st text',
                      isDisplayEnding: false,
                      isDisplayLeading: true,
                      isEnabled: isEnabled,
                      isSelected: isSelected,
                      title: title,
                      type: type,
                      isTrailingPressedEnabled: isTrailingPressedEnabled),
                  _ColumnOfChips(
                      textOfTitle: 'icon text icon',
                      isDisplayEnding: true,
                      isDisplayLeading: true,
                      isEnabled: isEnabled,
                      isSelected: isSelected,
                      title: title,
                      type: type,
                      isTrailingPressedEnabled: isTrailingPressedEnabled),
                  _ColumnOfChips(
                      textOfTitle: ' text icon2d',
                      isDisplayEnding: true,
                      isDisplayLeading: false,
                      isEnabled: isEnabled,
                      isSelected: isSelected,
                      title: title,
                      type: type,
                      isTrailingPressedEnabled: isTrailingPressedEnabled),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DemoTile(title: 'icon'),
                      const SizedBox(height: 8),
                      Chips(
                        options: ChipsIconOptions(
                          icon: ChipIconData(GeneralIcons.placeholder),
                        ),
                        isEnabled: isEnabled,
                        isSelected: isSelected,
                        onPressed: () {
                          print('Chips pressed');
                        },
                        type: type,
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Overview:', style: context.textStyles.h3Medium),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  Chips(type: ChipsType.neutral, options: const ChipsLabelOptions(labelFirst: 'Label')),
                  Chips(
                    type: ChipsType.neutral,
                    options: ChipsLabelOptions(
                      labelFirst: 'Car',
                      labelSecond: '15 min',
                      labelSecondColor: context.colors.accentDefault,
                    ),
                  ),
                  Chips(
                    type: ChipsType.neutral,
                    options: ChipsLabelOptions(
                      leadingIcon: ChipIconData(GeneralIcons.home),
                      labelFirst: '1 h 35 min',
                      labelFirstColor: context.colors.errorDefault,
                    ),
                  ),
                  Chips(
                    type: ChipsType.neutral,
                    options: ChipsLabelOptions(
                        leadingIcon: ChipIconData(TransportIcons.parkingActive),
                        leadingIconColor: context.colors.accentDefault,
                        labelFirst: 'Free'),
                  ),
                  Chips(
                    type: ChipsType.neutral,
                    options: ChipsIconOptions(
                      icon: ChipIconData(GeneralIcons.phoneLTR),
                      color: context.colors.successDefault,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Checked', style: context.textStyles.h3Medium),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  Chips(
                    type: ChipsType.neutral,
                    options: const ChipsLabelOptions(
                      labelFirst: 'Nearbly',
                    ),
                    isSelected: true,
                  ),
                  Chips(
                    type: ChipsType.neutral,
                    options: ChipsLabelOptions(
                      labelFirst: 'Rate',
                      trailingIcon: ChipIconData(SystemIcons.arrowCornerDownLarge),
                    ),
                    isSelected: true,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Pressure zone', style: context.textStyles.h3Medium),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  Chips(
                    type: ChipsType.neutral,
                    options: const ChipsLabelOptions(
                      labelFirst: '5 star',
                    ),
                    isSelected: true,
                  ),
                  Chips(
                    type: ChipsType.neutral,
                    options: ChipsLabelOptions(
                      labelFirst: '5 star',
                      trailingIcon: ChipIconData(SystemIcons.arrowCornerDownLarge),
                    ),
                    isSelected: true,
                  ),
                  Chips(
                    type: ChipsType.neutral,
                    options: ChipsLabelOptions(
                      leadingIcon: ChipIconData(GeneralIcons.crown),
                      labelFirst: '5 star',
                    ),
                    isSelected: true,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('In the non-selected state, the tap area and pressed state cover the entire width of the button',
                  style: context.textStyles.captionLargeRegular),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  Chips(
                    type: ChipsType.neutral,
                    options: ChipsLabelOptions(
                      labelFirst: '5 star',
                      trailingIcon: ChipIconData(GeneralIcons.clearCircleSolid),
                      trailingIconColor: context.colors.neutralMuted,
                      onTrailingIconPressed: () {},
                    ),
                    isSelected: true,
                  ),
                  Chips(
                    type: ChipsType.neutral,
                    options: ChipsLabelOptions(
                      leadingIcon: ChipIconData(GeneralIcons.crown),
                      labelFirst: '5 star',
                      trailingIcon: ChipIconData(GeneralIcons.clearCircleSolid),
                      trailingIconColor: context.colors.neutralMuted,
                      onTrailingIconPressed: () {},
                    ),
                    isSelected: true,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'When you click on the left side, Pressed state is standard for the entire button',
                style: context.textStyles.captionLargeRegular,
              ),
              Text(
                'Pressed state for the right side works on the principle of a link, that is, the icon becomes translucent: 60%',
                style: context.textStyles.captionLargeRegular,
              ),
              const SizedBox(height: 24),
              Text(
                'Quick filters',
                style: context.textStyles.h1SemiBold.copyWith(
                  color: context.colors.foregroundDefault,
                ),
              ),
              const SizedBox(height: 16),
              _ChipsRow(widthSize: widthSize, type: type),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ),
  );
}

extension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

class _ColumnOfChips extends StatelessWidget {
  final String textOfTitle;
  final String title;
  final String? label;
  final bool isDisplayLeading;
  final bool isDisplayEnding;
  final bool isEnabled;
  final bool isTrailingPressedEnabled;
  final ChipsType type;
  final bool isSelected;

  const _ColumnOfChips({
    required this.isDisplayLeading,
    required this.isDisplayEnding,
    required this.isEnabled,
    required this.type,
    required this.textOfTitle,
    required this.isSelected,
    required this.isTrailingPressedEnabled,
    required this.title,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DemoTile(title: textOfTitle),
        const SizedBox(height: 8),
        Chips(
          options: ChipsLabelOptions(
            labelFirst: title,
            labelSecond: label,
            leadingIcon: isDisplayLeading ? ChipIconData(GeneralIcons.placeholder) : null,
            trailingIcon: isDisplayEnding ? ChipIconData(GeneralIcons.placeholder) : null,
            onTrailingIconPressed: isTrailingPressedEnabled
                ? () {
                    print('Trailing icon pressed');
                  }
                : null,
          ),
          isEnabled: isEnabled,
          isSelected: isSelected,
          onPressed: () {
            print('Chips pressed');
          },
          type: type,
        )
      ],
    );
  }
}

class _ChipsRow extends StatefulWidget {
  final double widthSize;
  final ChipsType type;
  const _ChipsRow({
    required this.widthSize,
    required this.type,
  });

  @override
  State<_ChipsRow> createState() => __ChipsRowState();
}

class __ChipsRowState extends State<_ChipsRow> {
  int? selectedChips;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
      ),
      child: SizedBox(
        height: AppSizes.m + 8,
        width: widget.widthSize * MediaQuery.of(context).size.width,
        child: ListView(
          padding: const EdgeInsets.all(4),
          shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Chips(
              type: widget.type,
              options: ChipsIconOptions(
                icon: ChipIconData(SystemIcons.bookmark),
              ),
              isSelected: selectedChips == 0,
              onPressed: () {
                setState(() {
                  selectedChips = 0;
                });
              },
            ),
            Chips(
              type: widget.type,
              options: const ChipsLabelOptions(labelFirst: 'Home'),
              isSelected: selectedChips == 1,
              onPressed: () {
                setState(() {
                  selectedChips = 1;
                });
              },
            ),
            Chips(
              type: widget.type,
              options: const ChipsLabelOptions(labelFirst: 'Work'),
              isSelected: selectedChips == 2,
              onPressed: () {
                setState(() {
                  selectedChips = 2;
                });
              },
            ),
            Chips(
              type: widget.type,
              options: const ChipsLabelOptions(labelFirst: 'Eat out'),
              isSelected: selectedChips == 3,
              onPressed: () {
                setState(() {
                  selectedChips = 3;
                });
              },
            ),
            Chips(
              type: widget.type,
              options: const ChipsLabelOptions(labelFirst: 'Mosques'),
              isSelected: selectedChips == 4,
              onPressed: () {
                setState(() {
                  selectedChips = 4;
                });
              },
            ),
            Chips(
              type: widget.type,
              options: const ChipsLabelOptions(labelFirst: 'Markets'),
              isSelected: selectedChips == 5,
              onPressed: () {
                setState(() {
                  selectedChips = 5;
                });
              },
            ),
          ].insertBetween(const SizedBox(width: 8)).toList(),
        ),
      ),
    );
  }
}
