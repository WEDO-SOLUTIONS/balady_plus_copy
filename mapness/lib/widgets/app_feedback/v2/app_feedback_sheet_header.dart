import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';

class AppFeedbackSheetHeader extends StatelessWidget {
  final VoidCallback? onBackTap;
  final String title;

  const AppFeedbackSheetHeader({
    required this.title,
    this.onBackTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => BaladyTopBar.iconAndText(
        leading: ActionModel(icon: SystemIcons.arrowCornerLeftLarge, onPressed: onBackTap),
        title: title,
        useSafeArea: false,
      );
}
