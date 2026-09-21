import 'package:balady_uikit/balady_uikit.dart';
import 'package:mapness/widgets/common/network_svg.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class FeedbackTypeItemWidget extends ConsumerWidget {
  final String title;
  final String? iconUrl;
  final VoidCallback onTap;

  const FeedbackTypeItemWidget({
    required this.title,
    required this.iconUrl,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => ContentRow(
    onTap: onTap,
    options: ContentRowOptions(
      leadingIcon: iconUrl == null
          ? null
          : NetworkSvg(
              iconUrl!,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                context.colors.accentDefault,
                BlendMode.srcIn,
              ),
            ),
      title: title,
      titleStyle: context.textStyles.bodyLargeRegular,
      titleMaxlines: 2,
      actionWidget: ContentRowActionOptions(
        actionIcon: AppIcons(
          iconData: SystemIcons.arrowCornerRightSmall,
          color: context.colors.neutralDefault,
        ),
      ),
    ),
  );
}
