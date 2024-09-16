import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/feedback/feedback_icon.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FeedbackTypeItemWidget extends ConsumerWidget {
  final String title;
  final FeedbackIcon icon;
  final VoidCallback onTap;

  const FeedbackTypeItemWidget({
    required this.title,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => ContentRow(
        onTap: onTap,
        options: ContentRowOptions(
          leadingIcon: Icon(
            icon.iconData(isLTR: context.isLTR),
            color: context.colorsV2.accentDefault,
          ),
          title: title,
          titleStyle: context.textStyleV3.bodyLargeRegular,
          titleMaxlines: 2,
          actionWidget: ContentRowActionOptions(
            actionIcon: AppIcons(
              iconData: context.isLTR ? SystemIcons.arrowCornerRightLarge : SystemIcons.arrowCornerLeftLarge,
              color: context.colorsV2.neutralDefault,
            ),
          ),
        ),
      );
}
