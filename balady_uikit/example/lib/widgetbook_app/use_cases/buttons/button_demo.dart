import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:urbi_utils/urbi_utils.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: '07. Buttons',
  type: Widget,
)
Widget buttonsDemo(BuildContext context) {
  context.knobs.list(label: 'STATE', options: ButtonState.values, initialOption: ButtonState.defaultState);

  final showLeadingIcon = context.knobs.boolean(
    label: 'showLeadingIcon',
    initialValue: true,
  );

  final showTrailingIcon = context.knobs.boolean(
    label: 'showTrailingIcon',
    initialValue: true,
  );
  final showCounter = context.knobs.boolean(
    label: 'showCounter',
    initialValue: true,
  );

  final primaryLabel = context.knobs.string(
    label: 'primaryLabel',
    initialValue: Directionality.of(context) == TextDirection.ltr ? 'primary' : 'ثانوي',
    maxLines: 2,
  );
  final secondaryLabel = context.knobs.string(
    label: 'secondaryLabel',
    initialValue: Directionality.of(context) == TextDirection.ltr ? 'secondary' : 'ثانوي',
    maxLines: 2,
  );

  final primaryIcon = showLeadingIcon ? GeneralIcons.placeholder : null;
  final secondaryIcon = showTrailingIcon ? GeneralIcons.placeholder : null;
  final counter = showCounter
      ? const Counter(
          count: 1,
        )
      : null;
  Center buttonsColumn(ButtonColorScheme style) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(style.name.toUpperCase()),
              GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 8.0, crossAxisSpacing: 16.0, mainAxisExtent: 100),
                  shrinkWrap: true,
                  children: [
                    const Align(alignment: Alignment.center, child: Text('Primary')),
                    const Align(alignment: Alignment.center, child: Text('Secondary')),
                    row('Enabled:', ButtonState.defaultState, style, ButtonType.primary, primaryLabel, secondaryLabel,
                        primaryIcon, secondaryIcon, counter),
                    row('Enabled:', ButtonState.defaultState, style, ButtonType.secondary, primaryLabel, secondaryLabel,
                        primaryIcon, secondaryIcon, counter),
                    row('Pressed:', ButtonState.pressed, style, ButtonType.primary, primaryLabel, secondaryLabel,
                        primaryIcon, secondaryIcon, counter),
                    row('Pressed:', ButtonState.pressed, style, ButtonType.secondary, primaryLabel, secondaryLabel,
                        primaryIcon, secondaryIcon, counter),
                    row('Loading:', ButtonState.loading, style, ButtonType.primary, primaryLabel, secondaryLabel,
                        primaryIcon, secondaryIcon, counter),
                    row('Loading:', ButtonState.loading, style, ButtonType.secondary, primaryLabel, secondaryLabel,
                        primaryIcon, secondaryIcon, counter),
                    row('Disabled:', ButtonState.disabled, style, ButtonType.primary, primaryLabel, secondaryLabel,
                        primaryIcon, secondaryIcon, counter),
                    row('Disabled:', ButtonState.disabled, style, ButtonType.secondary, primaryLabel, secondaryLabel,
                        primaryIcon, secondaryIcon, counter),
                  ]),
            ].insertBetween(const SizedBox(height: 16.0)).toList(),
          ),
        ),
      );
  return Scaffold(
    backgroundColor: Colors.white,
    body: Directionality(
      textDirection: Directionality.of(context),
      child: PageView(
        clipBehavior: Clip.antiAlias,
        scrollBehavior: const ScrollBehavior(),
        controller: PageController(),
        children: [
          Center(
            child: AppButton(
              size: ButtonSize.large,
              primaryLabel: 'Button label',
              buttonColorScheme: ButtonColorScheme.accent,
              buttonState: ButtonState.loading,
              onTap: () {},
            ),
          ),
          buttonsColumn(ButtonColorScheme.accent),
          buttonsColumn(ButtonColorScheme.neutral),
          buttonsColumn(ButtonColorScheme.accentSecondary),
          buttonsColumn(ButtonColorScheme.error),
        ],
      ),
    ),
  );
}

Widget row(
  String title,
  ButtonState state,
  ButtonColorScheme style,
  ButtonType type,
  String primaryLabel,
  String secondaryLabel,
  IconData? primaryIcon,
  IconData? secondaryIcon,
  Counter? counter,
) {
  return DecoratedBox(
    decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1.0))),
    child: Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 100, child: Text(title)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const SizedBox(width: 50, child: Text('Size M:')),
                  AppButton(
                      key: UniqueKey(),
                      materialStatesController: state == ButtonState.pressed
                          ? WidgetStatesController(<WidgetState>{WidgetState.pressed})
                          : null,
                      primaryLabel: primaryLabel,
                      secondaryLabel: secondaryLabel,
                      primaryIcon: primaryIcon,
                      secondaryIcon: secondaryIcon,
                      buttonColorScheme: style,
                      trailing: state == ButtonState.disabled ? null : counter,
                      buttonState: state,
                      buttonType: type,
                      onTap: () {}),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const SizedBox(width: 50, child: Text('Size S:')),
                  AppButton(
                      materialStatesController: state == ButtonState.pressed
                          ? WidgetStatesController(<WidgetState>{WidgetState.pressed})
                          : null,
                      buttonState: state,
                      primaryLabel: primaryLabel,
                      secondaryLabel: secondaryLabel,
                      primaryIcon: primaryIcon,
                      secondaryIcon: secondaryIcon,
                      buttonColorScheme: style,
                      buttonType: type,
                      size: ButtonSize.small,
                      trailing: state == ButtonState.disabled ? null : counter,
                      onTap: () {}),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
