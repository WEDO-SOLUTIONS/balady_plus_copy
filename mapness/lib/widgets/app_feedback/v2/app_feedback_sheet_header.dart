import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class AppFeedbackSheetHeader extends StatelessWidget {
  final VoidCallback? onBackTap;
  final String title;

  const AppFeedbackSheetHeader({
    required this.title,
    this.onBackTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => BaladyTopBar(
        onLeadingPressed: onBackTap,
        leading: Semantics(
          label: context.l10n.a11yBack,
          button: true,
          child: ExcludeSemantics(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: Spacing.$4x),
                Icon(SystemIcons.arrowCornerLeftLarge),
                SizedBox(width: Spacing.$4x),
              ],
            ),
          ),
        ),
        title: title,
        useSafeArea: false,
      );
}
