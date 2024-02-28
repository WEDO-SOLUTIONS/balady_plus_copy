import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PathNavEndTripButton extends StatelessWidget {
  const PathNavEndTripButton({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: NonThemeColor.color1,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: SizedBox(
            height: 56,
            child: Center(
              child: Text(
                context.l10n.endTrip,
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .accentM
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
}
