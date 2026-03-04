import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/typedef/app_typedef.dart';
import 'package:flutter/material.dart';
import 'package:urbi_utils/urbi_utils.dart';

/// This widget is used in [ContentRow] and allow us to show trailing information to the user
/// On the other side we can use [Toggle].
///
/// This widget has [actionText] and [actionIcon]. And [actionPressed] to use it as button
class ActionWidget extends StatelessWidget {
  final String? actionText;
  final TextStyle? actionTextStyle;
  final Widget? actionIcon;
  final OnTap? actionPressed;
  final EdgeInsetsDirectional? padding;

  const ActionWidget({
    super.key,
    this.actionText,
    this.actionIcon,
    this.actionTextStyle,
    this.actionPressed,
    this.padding,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: actionPressed,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Row(
            children: [
              if (actionText != null)
                Text(
                  actionText!,
                  style: actionTextStyle ??
                      context.textStyles.bodySmallSemiBold.copyWith(
                        color: context.colors.foregroundSoft,
                      ),
                ),
              if (actionIcon != null) actionIcon!,
            ].insertBetween(Spacing.$1x.widthBox).toList(),
          ),
        ),
      );
}
