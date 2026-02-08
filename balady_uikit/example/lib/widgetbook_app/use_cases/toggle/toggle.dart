import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Toggle',
  type: Widget,
)
Widget toggleWork(BuildContext context) => const Align(
      alignment: Alignment.topLeft,
      child: ColoredBox(
        color: Colors.white,
        child: ToggleWork(),
      ),
    );

class ToggleWork extends StatefulWidget {
  const ToggleWork({super.key});

  @override
  ToggleWorkState createState() => ToggleWorkState();
}

class ToggleWorkState extends State<ToggleWork> {
  bool switchValue = true;

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return SizedBox(
      width: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isArabic)
            Text(
              'RTL',
              style: context.textStyles.h3SemiBold.copyWith(
                color: context.colors.foregroundDefault,
              ),
            )
          else
            Text(
              'LTR',
              style: context.textStyles.h3SemiBold.copyWith(
                fontSize: 19,
                color: context.colors.foregroundDefault,
              ),
            ),
          const SizedBox(height: Spacing.$12x),
          Text(
            'Component',
            style: context.textStyles.bodyLargeRegular.copyWith(
              fontWeight: FontWeight.w400,
              color: context.colors.foregroundDefault,
            ),
          ),
          const SizedBox(height: Spacing.$8x),
          Row(
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  'Activated',
                  style: context.textStyles.bodyLargeRegular,
                ),
              ),
              SizedBox(
                width: 100,
                child: Center(
                  child: Text(
                    'Yes',
                    style: context.textStyles.bodyLargeRegular,
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: Center(
                  child: Text(
                    'No',
                    style: context.textStyles.bodyLargeRegular,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.$8x),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 140,
                child: Text('Enable', style: context.textStyles.bodyLargeRegular),
              ),
              SizedBox(
                width: 100,
                child: Center(
                  child: Toggle(
                    value: true,
                    onChanged: (val) {},
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: Center(
                  child: Toggle(
                    value: false,
                    onChanged: (val) {},
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.$2x),
          Row(
            children: [
              SizedBox(
                width: 140,
                child: Text('Disable', style: context.textStyles.bodyLargeRegular),
              ),
              const SizedBox(
                width: 100,
                child: Center(child: Toggle(value: true)),
              ),
              const SizedBox(
                width: 100,
                child: Center(child: Toggle(value: false)),
              ),
            ],
          ),
          const SizedBox(height: Spacing.$16x),
          Row(
            children: [
              SizedBox(
                width: 140,
                child: Text('Pressed', style: context.textStyles.bodyLargeRegular),
              ),
              SizedBox(
                width: 100,
                child: Center(
                  child: Toggle(
                    value: switchValue,
                    onChanged: (val) {
                      setState(() {
                        switchValue = !switchValue;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
