import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/cupertino.dart';

class RoutingPublicExpandable extends StatefulWidget {
  const RoutingPublicExpandable({
    required this.content,
    required this.leading,
    required this.firstText,
    this.secondText,
    this.padding = const EdgeInsets.only(top: Spacing.$3x),
    this.onTitleTap,
    super.key,
  });
  // ignore: avoid_positional_boolean_parameters
  final Widget Function(bool isExpanded) leading;
  final String firstText;
  final String? secondText;
  final EdgeInsetsGeometry padding;
  final void Function()? onTitleTap;
  final Widget content;

  @override
  State<RoutingPublicExpandable> createState() => _RoutingPublicExpandableState();
}

class _RoutingPublicExpandableState extends State<RoutingPublicExpandable> {
  dynamic Function({bool animated})? _toggleFunction;

  @override
  Widget build(BuildContext context) => Padding(
        padding: widget.padding,
        child: ExpansionWidget(
          duration: const Duration(milliseconds: 100),
          titleBuilder: (animationValue, easeInValue, isExpanded, toggleFunction) {
            _toggleFunction ??= toggleFunction;
            return Row(
              children: [
                widget.leading(isExpanded),
                Spacing.$3x.widthBox,
                CupertinoButton(
                  onPressed: _toggleFunction,
                  minSize: 0,
                  padding: const EdgeInsetsDirectional.only(
                    top: Spacing.$3x,
                    bottom: Spacing.$3x,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    decoration: BoxDecoration(
                      color: context.colors.neutralContainerDefault,
                      borderRadius: BorderRadius.circular(RadiusBorder.s),
                    ),
                    child: Row(
                      children: [
                        Spacing.$1x.widthBox,
                        Text(
                          widget.firstText,
                          style: context.textStyles.bodySmallRegular.copyWith(
                            color: context.colors.foregroundSoft,
                          ),
                        ),
                        if (widget.secondText != null) ...[
                          Spacing.$1x.widthBox,
                          Text(
                            widget.secondText!,
                            style: context.textStyles.bodySmallRegular.copyWith(
                              color: context.colors.foregroundSoft,
                            ),
                          ),
                        ],
                        Spacing.$1_5x.widthBox,
                        Transform.rotate(
                          angle: pi * animationValue,
                          child: Icon(
                            SystemIcons.arrowCornerDownSmall,
                            size: AppSizes.xxs,
                            color: context.colors.foregroundSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          content: SizedBox(
            width: double.infinity,
            child: widget.content,
          ),
        ),
      );
}
