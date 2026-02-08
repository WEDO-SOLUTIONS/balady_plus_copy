import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/typedef/app_typedef.dart';
import 'package:balady_uikit/src/components/content_row/widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:urbi_utils/urbi_utils.dart';

part 'v2/content_row_trailing_options.dart';
part 'v2/content_row_trailing.dart';
part 'v2/content_row_text.dart';
part 'v2/content_row_text_options.dart';

part 'options/content_row_options.dart';
part 'widgets/content_row_action.dart';
part 'widgets/content_row_item.dart';

/// The [ContentRow] is a component that can be used to collect various UI elements. For more details, see the component specification in Figma.
///
/// Params:
/// - [onTap]: A callback function that is triggered when the row is tapped.
/// - [leading]: The leading widget to display at the start of the row (e.g., an icon or image).
/// - [text]: provides options for configuring the main and subtitle text of the row.
/// - [trailing]: provides options for configuring the trailing widget (e.g., an action or indicator).
/// - [isDividerEnabled]: determines whether a divider is shown below the row.
/// - [supportTitleRTL]: specifies if the title should support right-to-left text direction.
/// - [crossAxisAlignment]: controls the vertical alignment of the row's children.
/// - [backgroundColor]: sets the background color of the row.
///
/// See also:
/// * [Figma Design](https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=1986-28646&mode=design&t=3xPoBtyh46POlIeb-4) for design specifications.
class ContentRow extends StatelessWidget {
  // base paddings for the row
  static const startPadding = EdgeInsetsDirectional.only(start: Spacing.$4x);
  static const verticalPadding = EdgeInsetsDirectional.symmetric(vertical: Spacing.$2x);
  static const endPadding = EdgeInsetsDirectional.only(end: Spacing.$4x);

  final Widget? leading;
  final ContentRowTextOptions? text;
  final ContentRowTrailingOptions? trailing;
  final bool isDividerEnabled;
  final OnTap? onTap;
  final bool? supportTitleRTL;
  final CrossAxisAlignment? crossAxisAlignment;
  final Color? backgroundColor;
  final bool? wrapperEnabled;
  final Color? wrapperColor;

  ContentRow({
    super.key,
    Widget? leading,
    ContentRowTextOptions? text,
    ContentRowTrailingOptions? trailing,
    this.onTap,
    bool isDividerEnabled = false,
    bool? supportTitleRTL,
    CrossAxisAlignment? crossAxisAlignment,
    this.backgroundColor,
    @Deprecated('Use text and trailing options instead') ContentRowOptions? options,
    @Deprecated('Use trailing toggle options instead') ValueChanged<bool>? onToggle,
  })  : assert(
          leading != null || text != null || trailing != null || options != null,
          'At least one of the following should be provided: leading, text, trailing',
        ),

        /// TODO: Remove all this then [options] and [onToggle] removed.
        supportTitleRTL = options?.supportTitleRTL ?? supportTitleRTL,
        isDividerEnabled = options?.dividerEnabled ?? isDividerEnabled,
        crossAxisAlignment = crossAxisAlignment ?? options?.crossAxisAlignment,
        wrapperEnabled = options?.wrapperEnabled,
        wrapperColor = options?.wrapperColor,
        text = options != null
            ? ContentRowTextOptions(
                title: options.title,
                titleOptions: options.titleMatchedParts != null ||
                        options.titleBuilder != null ||
                        options.titleStyle?.fontWeight != null ||
                        options.titleStyle?.color != null ||
                        options.titleMaxlines != null
                    ? ContentRowTextOption(
                        isBold: options.titleStyle?.fontWeight?.value != null &&
                            options.titleStyle!.fontWeight!.value >= FontWeight.w500.value,
                        maxLines: options.titleMaxlines,
                        baseColor: options.titleStyle?.color,
                        builder: options.titleBuilder,
                        matchedParts: options.titleMatchedParts,
                      )
                    : null,
                subtitle: options.subtitle,
                subtitleOptions: options.subtitleMatchedParts != null ||
                        options.subtitleBuilder != null ||
                        options.subtitleStyle?.fontWeight != null ||
                        options.subtitleStyle?.color != null ||
                        options.subtitleMaxlines != null
                    ? ContentRowTextOption(
                        isBold: options.subtitleStyle?.fontWeight?.value != null &&
                            options.subtitleStyle!.fontWeight!.value >= FontWeight.w500.value,
                        maxLines: options.subtitleMaxlines,
                        baseColor: options.subtitleStyle?.color,
                        builder: options.subtitleBuilder,
                        matchedParts: options.subtitleMatchedParts,
                      )
                    : null,
                subtitleExtra: options.subtitleExtra,
                subtitleExtraOptions: options.subtitleExtraBuilder != null ||
                        options.subtitleExtraStyle?.fontWeight != null ||
                        options.subtitleExtraStyle?.color != null ||
                        options.subtitleExtraMaxlines != null
                    ? ContentRowTextOption(
                        isBold: options.subtitleExtraStyle?.fontWeight?.value != null &&
                            options.subtitleExtraStyle!.fontWeight!.value >= FontWeight.w500.value,
                        maxLines: options.subtitleExtraMaxlines,
                        baseColor: options.subtitleExtraStyle?.color,
                        builder: options.subtitleExtraBuilder,
                      )
                    : null,
              )
            : text,
        leading = options?.leadingIcon ?? leading,
        trailing = (options?.customActionWidget != null
            ? ContentRowCustomTrailingOptions(builder: (_) => options!.customActionWidget!)
            : onToggle != null || options?.actionWidget != null
                ? ContentRowCustomTrailingOptions(
                    builder: (_) => Padding(
                          padding: verticalPadding + endPadding + startPadding,
                          child: ContentRowAction(actionOptions: options?.actionWidget, onToggle: onToggle),
                        ))
                : trailing);

  @override
  Widget build(BuildContext context) {
    final trailing = this.trailing;
    final text = this.text;

    // leading padding for the right layout
    final leadingPadding = leading != null ? (verticalPadding + startPadding) : null;

    // trailing padding for the right layout. We use it to add padding to the trailing widget to expand tappble area
    final trailingPadding = verticalPadding + endPadding + startPadding;

    final contentRow = Material(
      color: backgroundColor ?? Colors.transparent,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minSize: 0,
        onPressed: onTap,
        child: Row(
          children: [
            if (leading != null)
              Padding(
                padding: leadingPadding ?? EdgeInsets.zero,
                child: leading,
              ),
            if (text != null || trailing != null)
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
                      children: [
                        if (text != null)
                          Expanded(
                            child: ContentRowText(
                              supportTitleRTL: supportTitleRTL ?? false,
                              options: text,
                              isLeadingExist: leading != null,
                              isTrailingExist: trailing != null,
                            ),
                          ),
                        if (trailing != null)
                          switch (trailing) {
                            ContentRowTextTrailingOptions() => ContentRowTrailingText(
                                options: trailing,
                                padding: trailingPadding,
                              ),
                            ContentRowToggleTrailingOptions() => ContentRowTrailingToggle(
                                options: trailing,
                                padding: trailingPadding,
                              ),
                            ContentRowCustomTrailingOptions() => trailing.builder(context),
                          },
                      ],
                    ),
                    if (isDividerEnabled)
                      Divider(
                        color: context.colors.borderSoft,
                        height: 0.5,
                        thickness: 0.5,
                      ),
                  ],
                ),
              ),
          ].insertBetween(Spacing.$3x.widthBox).toList(),
        ),
      ),
    );
    if (wrapperEnabled ?? false) {
      return ContentWrapper.single(
        child: contentRow,
        color: wrapperColor ?? context.colors.backgroundSurface1,
      );
    }
    return contentRow;
  }
}
