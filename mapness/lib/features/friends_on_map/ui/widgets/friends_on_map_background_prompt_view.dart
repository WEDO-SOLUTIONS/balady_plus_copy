import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// R-04: optional step shown after foreground permission is granted, before
/// activation completes.
class FriendsOnMapBackgroundPromptView extends StatelessWidget {
  final VoidCallback onEnable;
  final VoidCallback onSkip;

  const FriendsOnMapBackgroundPromptView({required this.onEnable, required this.onSkip, super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(Spacing.$4x),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.l10n.friendsOnMapBackgroundPromptTitle,
                textAlign: TextAlign.center,
                style: context.textStyles.h3SemiBold.copyWith(color: context.colors.foregroundDefault),
              ),
              const SizedBox(height: Spacing.$2x),
              Text(
                context.l10n.friendsOnMapBackgroundPromptBody,
                textAlign: TextAlign.center,
                style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundMuted),
              ),
            ],
          ),
        ),
        AppButton(
          buttonColorScheme: ButtonColorScheme.accentSecondary,
          size: ButtonSize.large,
          primaryLabel: context.l10n.friendsOnMapEnableCta,
          onTap: onEnable,
        ),
        const SizedBox(height: Spacing.$2x),
        AppButton(
          buttonColorScheme: ButtonColorScheme.accentSecondary,
          buttonType: ButtonType.secondary,
          size: ButtonSize.large,
          primaryLabel: context.l10n.friendsOnMapSkipCta,
          onTap: onSkip,
        ),
      ],
    ),
  );
}
