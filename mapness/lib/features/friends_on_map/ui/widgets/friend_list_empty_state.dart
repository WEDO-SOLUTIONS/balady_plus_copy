import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';

/// R-46. The add-friend action is required by the requirement even though
/// it isn't wired to a real flow yet — S-07 (invite link/QR) is a later
/// slice. It shows a "coming soon" toast rather than silently doing
/// nothing or being omitted.
class FriendListEmptyState extends StatelessWidget {
  const FriendListEmptyState({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(Spacing.$4x),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.l10n.friendListEmptyTitle,
          textAlign: TextAlign.center,
          style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
        ),
        const SizedBox(height: Spacing.$2x),
        Text(
          context.l10n.friendListEmptyBody,
          textAlign: TextAlign.center,
          style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundMuted),
        ),
        const SizedBox(height: Spacing.$4x),
        AppButton(
          buttonColorScheme: ButtonColorScheme.accentSecondary,
          size: ButtonSize.large,
          primaryLabel: context.l10n.friendListEmptyAddCta,
          // TODO(BE-213): wire to the real add-friend flow once S-07 lands.
          onTap: () => ToastOverlay.of(context).show(title: context.l10n.friendListAddFriendComingSoonToast),
        ),
      ],
    ),
  );
}
