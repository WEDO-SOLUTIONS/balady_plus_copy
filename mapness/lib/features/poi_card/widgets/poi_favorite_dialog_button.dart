import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';

class PoiFavoriteDialogButton extends StatelessWidget {
  const PoiFavoriteDialogButton({
    required this.onTap,
    required this.iconAsset,
    required this.title,
    required this.showBorder,
    super.key,
  });

  final VoidCallback onTap;
  final String title;
  final String iconAsset;
  final bool showBorder;

  @override
  Widget build(BuildContext context) => ContentRow(
        onTap: onTap,
        options: ContentRowOptions(
          dividerEnabled: showBorder,
          title: title,
          actionWidget: ContentRowActionOptions(
            actionIcon: AppIcons(
              iconPath: iconAsset,
            ),
          ),
        ),
      );
}
