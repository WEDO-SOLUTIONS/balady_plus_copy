import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';

class StoryRefreshButton extends StatelessWidget {
  const StoryRefreshButton({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Center(
        child: AppButton(
          onTap: onPressed,
          buttonColorScheme: ButtonColorScheme.tertiary,
          size: ButtonSize.small,
          primaryIcon: Icons.refresh,
          innerPadding: const EdgeInsets.all(Spacing.verticalGapBetweenStories),
        ),
      );
}
