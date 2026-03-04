import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: '14. Bottom Action Bar',
  type: Widget,
)
Widget bottomActionBarWork(BuildContext context) {
  final widthBottomNavBar = context.knobs.double.slider(
    label: 'Size Bottom Bar',
    initialValue: 375,
    min: 375,
    max: 800,
    divisions: 5,
  );

  return SizedBox(
    width: widthBottomNavBar,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Spacing.$3x),
        Text('POI', style: context.textStyles.h1Medium),
        const SizedBox(height: Spacing.$2x),
        BottomActionBar(
          items: [
            ItemActionBar(
              label: '32 min',
              icon: TransportIcons.car,
              onPressed: () {},
              buttonType: ButtonType.primary,
              innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
            ),
            ItemActionBar(
              label: 'Call',
              icon: GeneralIcons.phoneLTR,
              onPressed: () {},
              buttonType: ButtonType.secondary,
              innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
            ),
            ItemActionBar(
              label: 'Save',
              icon: SystemIcons.bookmark,
              onPressed: () {},
              buttonType: ButtonType.secondary,
              innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
            ),
            ItemActionBar(
              label: 'Share',
              icon: SystemIcons.share,
              onPressed: () {},
              buttonType: ButtonType.secondary,
              innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
            ),
          ],
        ),
      ],
    ),
  );
}
