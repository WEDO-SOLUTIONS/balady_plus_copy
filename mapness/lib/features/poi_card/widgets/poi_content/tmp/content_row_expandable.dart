import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';

/// [ContentRowExpandableTmp] is a temporary widget to replace [ContentRowExpandable]
/// We must to move it to UIKit and replace it.
class ContentRowExpandableTmp extends StatefulWidget {
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
    this.onTitleTapExpand = false,
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
  final bool onTitleTapExpand;

  @override
  State<ContentRowExpandableTmp> createState() => _ContentRowExpandableTmpState();
}

class _ContentRowExpandableTmpState extends State<ContentRowExpandableTmp> {
  dynamic Function({bool animated})? _toggleFunction;

  @override
  Widget build(BuildContext context) => Padding(
    padding: widget.margin,
    child: Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Padding(
          padding: widget.padding,
          child: ExpansionWidget(
            duration: const Duration(milliseconds: 100),
            titleBuilder: (animationValue, easeInValue, isExpanded, toggleFunction) {
              _toggleFunction ??= toggleFunction;
              return ContentRow(
                text: const ContentRowTextOptions(title: ''),
                trailing: ContentRowCustomTrailingOptions(
                  builder: (context) => CupertinoButton(
                    onPressed: toggleFunction,
                    padding: const EdgeInsets.symmetric(vertical: Spacing.$3x, horizontal: Spacing.$4x),
                    minSize: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (widget.count != null)
                          Text(
                            context.digits(widget.count.toString()),
                            style: context.textStyles.bodySmallSemiBold.copyWith(color: context.colors.foregroundMuted),
                          ),
                        if (widget.trailing != null) widget.trailing!,
                        Transform.rotate(
                          angle: pi * animationValue,
                          child: Icon(
                            SystemIcons.arrowCornerDownSmall,
                            size: AppSizes.xxs,
                            color: widget.expandIconColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            content: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(RadiusBorder.baseSharp)),
              ),
              child: widget.content,
            ),
          ),
        ),
        Padding(
          // padding + text + icon + padding
          padding: const EdgeInsetsDirectional.only(end: Spacing.$4x + Spacing.$2x + AppSizes.xxs + Spacing.$4x),
          child: ContentRow(
            supportTitleRTL: widget.supportTitleRTL,
            onTap: () {
              if (widget.onTitleTapExpand) {
                _toggleFunction?.call();
              }
              widget.onTitleTap?.call();
            },
            leading: widget.leading,
            text: widget.text,
          ),
        ),
      ],
    ),
  );
}
