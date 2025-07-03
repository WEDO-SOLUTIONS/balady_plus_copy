import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/cupertino.dart';

/// [ContentRowExpandableTmp] is a temporary widget to replace [ContentRowExpandable]
/// We must to move it to UIKit and replace it.
class ContentRowExpandableTmp extends StatelessWidget {
  const ContentRowExpandableTmp({
    required this.content,
    this.expandIconColor,
    this.leading,
    this.text,
    this.trailing,
    this.supportTitleRTL = true,
    this.onTitleTap,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.only(top: Spacing.$3x),
    this.count,
    super.key,
  });

  final Widget? leading;
  final ContentRowTextOptions? text;
  final Widget? trailing;
  final Color? expandIconColor;
  final bool supportTitleRTL;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final void Function()? onTitleTap;
  final Widget content;
  final int? count;

  @override
  Widget build(BuildContext context) => Padding(
        padding: margin,
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Padding(
              padding: padding,
              child: ExpansionWidget(
                duration: const Duration(milliseconds: 100),
                titleBuilder: (animationValue, easeInValue, isExpanded, toggleFunction) => ContentRow(
                  text: const ContentRowTextOptions(title: ''),
                  trailing: ContentRowCustomTrailingOptions(
                    builder: (context) => CupertinoButton(
                      onPressed: toggleFunction,
                      padding: const EdgeInsets.symmetric(vertical: Spacing.$3x, horizontal: Spacing.$4x),
                      minSize: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (count != null)
                            Text(
                              count.toString(),
                              style: context.textStyles.bodySmallSemiBold.copyWith(
                                color: context.colors.foregroundMuted,
                              ),
                            ),
                          if (trailing != null) trailing!,
                          Transform.rotate(
                            angle: pi * animationValue,
                            child: Icon(
                              SystemIcons.arrowCornerDownSmall,
                              size: AppSizes.xxs,
                              color: expandIconColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                content: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(RadiusBorder.baseSharp),
                    ),
                  ),
                  child: content,
                ),
              ),
            ),
            Padding(
              // padding + text + icon + padding
              padding: const EdgeInsetsDirectional.only(end: Spacing.$4x + Spacing.$2x + AppSizes.xxs + Spacing.$4x),
              child: ContentRow(
                supportTitleRTL: supportTitleRTL,
                onTap: onTitleTap,
                leading: leading,
                text: text,
              ),
            ),
          ],
        ),
      );
}
