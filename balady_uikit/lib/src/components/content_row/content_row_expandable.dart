import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';

class ContentRowExpandable extends StatelessWidget {
  final ContentRowOptions? options;
  final Color? expandIconColor;
  final EdgeInsetsGeometry? padding;
  final Widget content;
  final Widget? leading;
  final ContentRowTextOptions? text;
  final ContentRowTrailingOptions? trailing;
  final bool isDividerEnabled;
  final bool? supportTitleRTL;
  final CrossAxisAlignment? crossAxisAlignment;
  final Color? backgroundColor;

  const ContentRowExpandable({
    required this.content,
    @Deprecated('Use text and trailing options instead') this.options,
    this.backgroundColor,
    this.isDividerEnabled = false,
    this.expandIconColor,
    this.padding,
    this.leading,
    this.text,
    this.trailing,
    this.supportTitleRTL,
    this.crossAxisAlignment,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding ?? EdgeInsets.zero,
        child: ExpansionWidget(
          duration: const Duration(milliseconds: 100),
          titleBuilder: (animationValue, easeInValue, isExpanded, toggleFunction) => ContentRow(
            onTap: toggleFunction,
            leading: leading,
            text: text,
            trailing:
                trailing ??
                ContentRowCustomTrailingOptions(
                  builder: (_) => Padding(
                    padding:
                        ContentRow.verticalPadding +
                        const EdgeInsetsDirectional.only(end: Spacing.$4x),
                    child: Align(
                      alignment: Alignment.center,
                      child: Transform.rotate(
                        angle: pi * animationValue,
                        child: Icon(
                          SystemIcons.arrowCornerDownSmall,
                          size: 24,
                          color: expandIconColor,
                        ),
                      ),
                    ),
                  ),
                ),
            supportTitleRTL: supportTitleRTL,
            isDividerEnabled: isDividerEnabled,
            crossAxisAlignment: crossAxisAlignment,
            backgroundColor: backgroundColor,
            options: options,
          ),
          content: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: content,
          ),
        ),
      );
}
