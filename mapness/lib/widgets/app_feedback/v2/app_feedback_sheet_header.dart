import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
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
  Widget build(BuildContext context) => Stack(
        children: [
          const SizedBox(
            height: 46,
            width: double.infinity,
          ),
          PositionedDirectional(
            start: 0,
            top: 0,
            bottom: 0,
            child: AppButton(
              buttonColorScheme: ButtonColorScheme.onColor,
              padding: EdgeInsets.zero,
              onTap: onBackTap,
              primaryIcon: SystemIcons.arrowCornerLeftLarge,
              iconColor: context.colors.foregroundDefault,
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: context.textStyles.bodyLargeSemiBold.copyWith(
                  color: context.colors.foregroundDefault,
                ),
              ),
            ),
          ),
        ],
      );
}
