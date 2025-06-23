import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
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
    this.padding,
    super.key,
  });

  final Widget? leading;
  final ContentRowTextOptions? text;
  final Widget? trailing;
  final Color? expandIconColor;
  final bool supportTitleRTL;
  final EdgeInsetsGeometry? padding;
  final void Function()? onTitleTap;
  final Widget content;

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            ExpansionWidget(
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
