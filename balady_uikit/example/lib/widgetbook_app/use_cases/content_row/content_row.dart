import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: '12. ContentRow',
  type: Widget,
)
Widget contentRowDemo(BuildContext context) {
  // Locale
  const ltr = TextDirection.ltr;

  final textDirection = Directionality.of(context);

  // Texts
  final titleTxt = context.knobs.string(
    label: 'Title with base highlights and red highlights',
    initialValue: textDirection == ltr ? 'Title with base and red' : 'عنوان',
  );
  final subtitleTxt = context.knobs.string(
    label: 'Subtitle',
    initialValue: textDirection == ltr ? 'Subtitle' : 'العنوان الفرعي',
  );
  final subtitleExtraTxt = context.knobs.string(
    label: 'SubtitleExtra',
    initialValue: textDirection == ltr ? 'Subtitle extra' : 'العنوان الفرعي [إضافي]',
  );
  final actionTxt = context.knobs.string(
    label: 'Action text',
    initialValue: textDirection == ltr ? 'Action' : 'عمل',
  );

  // Devider
  final dividerEnabled = context.knobs.boolean(label: 'Divider');

  // Wrapper
  final wrapperEnabled = context.knobs.boolean(
    label: 'Wrapper',
  );

  // Enable second and first sides
  final firstIconEnabled = context.knobs.boolean(label: 'Enable first side', initialValue: true);
  final secondIconEnabled = context.knobs.boolean(label: 'Enable second side', initialValue: true);

  // Enable title, subtitle and subtitleExtra
  final titleEnabled = context.knobs.boolean(
    label: 'Enable title',
    initialValue: true,
  );
  final subtitleEnabled = context.knobs.boolean(
    label: 'Enable subtitle',
    initialValue: true,
  );
  final extraSubtitleEnabled = context.knobs.boolean(
    label: 'Enable subtitleExtra',
    initialValue: true,
  );

  // Title config
  final titleBold = context.knobs.boolean(
    label: 'Bold title',
  );

  // Action toggle, icon and text enabled
  final actionIconEnabled = context.knobs.boolean(
    label: 'Enable action icon',
    initialValue: true,
  );
  final actionTextEnabled = context.knobs.boolean(
    label: 'Enable action text',
    initialValue: true,
  );
  final toggleEnabled = context.knobs.boolean(
    label: 'Enable toggle (if Toggle enable action icon and text will be hidden)',
  );

  final sizeSlider = context.knobs.int.slider(
    label: 'Component Size',
    min: 250,
    max: 1024,
    initialValue: 375,
  );

  bool isEnabled = true;

  return Scaffold(
    backgroundColor: context.colors.backgroundSurface1,
    body: Padding(
      padding: const EdgeInsets.only(top: 24),
      child: SizedBox(
        width: sizeSlider.toDouble(),
        child: Container(
          padding: const EdgeInsets.all(8),
          color: wrapperEnabled ? context.colors.backgroundSurface5 : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatefulBuilder(builder: (context, setState) {
                return ContentRow(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  onTap: () {},
                  leading: firstIconEnabled
                      ? AppIcons(
                          color: context.colors.accentDefault,
                          iconData: GeneralIcons.placeholder,
                        )
                      : null,
                  text: ContentRowTextOptions(
                    title: titleEnabled ? titleTxt : null,
                    titleOptions: ContentRowTextOption(
                      isBold: titleBold,
                      matchedParts: [
                        // Zero values
                        const UIMarkedUpTextSpan(length: 0, offset: 0),
                        // Not right order + highlight color
                        const UIMarkedUpTextSpan(length: 3, offset: 20, highlightColor: Colors.red),
                        const UIMarkedUpTextSpan(length: 4, offset: 11),
                        // Huge overflow
                        const UIMarkedUpTextSpan(length: 50, offset: 100),
                      ],
                    ),
                    subtitle: subtitleEnabled ? subtitleTxt : null,
                    subtitleOptions: const ContentRowTextOption(
                      matchedParts: [
                        UIMarkedUpTextSpan(length: 2, offset: 0),
                        UIMarkedUpTextSpan(length: 5, offset: 5),
                      ],
                    ),
                    subtitleExtra: extraSubtitleEnabled ? subtitleExtraTxt : null,
                  ),
                  trailing: !secondIconEnabled
                      ? null
                      : toggleEnabled
                          ? ContentRowToggleTrailingOptions(
                              value: isEnabled,
                              onChanged: (value) {
                                setState(() {
                                  isEnabled = value;
                                });
                              })
                          : ContentRowTextTrailingOptions(
                              text: actionTextEnabled ? actionTxt : null,
                              icon: actionIconEnabled ? GeneralIcons.placeholder : null,
                              iconColor: context.colors.foregroundSoft,
                              onPressed: () => {},
                            ),
                  isDividerEnabled: dividerEnabled,
                );
              }),
              ContentRow(
                onTap: () {
                  if (kDebugMode) {
                    print('Tap 1');
                  }
                },
                options: ContentRowOptions(
                  title: titleEnabled ? titleTxt : null,
                  titleMatchedParts: [
                    // Zero values
                    const UIMarkedUpTextSpan(length: 0, offset: 0),
                    // Not right order + highlight color
                    const UIMarkedUpTextSpan(length: 3, offset: 20, highlightColor: Colors.red),
                    const UIMarkedUpTextSpan(length: 4, offset: 11),
                    // Huge overflow
                    const UIMarkedUpTextSpan(length: 50, offset: 100),
                  ],
                  titleStyle:
                      titleBold ? context.textStyles.buttonL.copyWith(color: context.colors.foregroundDefault) : null,
                  subtitle: subtitleEnabled ? subtitleTxt : null,
                  subtitleMatchedParts: [
                    const UIMarkedUpTextSpan(length: 2, offset: 0),
                    const UIMarkedUpTextSpan(length: 5, offset: 5),
                  ],
                  subtitleExtra: extraSubtitleEnabled ? subtitleExtraTxt : null,
                  leadingIcon: firstIconEnabled
                      ? AppIcons(
                          color: context.colors.accentDefault,
                          iconData: GeneralIcons.placeholder,
                        )
                      : null,
                  dividerEnabled: dividerEnabled,
                  wrapperEnabled: wrapperEnabled,
                  actionWidget: secondIconEnabled
                      ? ContentRowActionOptions(
                          actionIcon: toggleEnabled == false && actionIconEnabled
                              ? AppIcons(
                                  iconData: GeneralIcons.placeholder,
                                  color: context.colors.foregroundSoft,
                                )
                              : null,
                          actionText: toggleEnabled == false && actionTextEnabled ? actionTxt : null,
                          actionPressed: () {
                            if (kDebugMode) {
                              print('Tap 2');
                            }
                          },
                          enabledToggle: toggleEnabled == true ? toggleEnabled : null,
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
