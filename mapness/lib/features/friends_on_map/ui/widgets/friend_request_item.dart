import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/friends_on_map/models/friend_request.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_avatar.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// R-36 (incoming: Accept/Decline/Block) / R-37 (outgoing: Cancel).
class FriendRequestItem extends StatelessWidget {
  final FriendRequest request;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onCancel;
  final VoidCallback? onBlock;

  const FriendRequestItem({
    required this.request,
    this.onAccept,
    this.onDecline,
    this.onCancel,
    this.onBlock,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Spacing.$2x, horizontal: Spacing.$4x),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FriendAvatar(displayName: request.displayName, profilePictureUrl: request.profilePictureUrl),
            const SizedBox(width: Spacing.$3x),
            Expanded(
              child: Text(
                request.displayName,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.bodyLargeMedium.copyWith(color: context.colors.foregroundDefault),
              ),
            ),
            const SizedBox(width: Spacing.$2x),
            if (request.direction == FriendRequestDirection.incoming) ...[
              AppButton(
                buttonColorScheme: ButtonColorScheme.accentSecondary,
                buttonType: ButtonType.secondary,
                size: ButtonSize.small,
                primaryLabel: context.l10n.friendRequestDeclineCta,
                onTap: onDecline,
              ),
              const SizedBox(width: Spacing.$1_5x),
              AppButton(
                buttonColorScheme: ButtonColorScheme.accentSecondary,
                size: ButtonSize.small,
                primaryLabel: context.l10n.friendRequestAcceptCta,
                onTap: onAccept,
              ),
            ] else
              AppButton(
                buttonColorScheme: ButtonColorScheme.accentSecondary,
                buttonType: ButtonType.secondary,
                size: ButtonSize.small,
                primaryLabel: context.l10n.friendRequestCancelCta,
                onTap: onCancel,
              ),
          ],
        ),
        // R-44: a small link rather than a third AppButton in the row above
        // — the row is already tight with an avatar, the name, and two
        // buttons; a third button risks overflow on narrow screens.
        if (request.direction == FriendRequestDirection.incoming)
          Padding(
            // start offset matches the default FriendAvatar diameter
            // (radius 20 → $10x) plus the row's own avatar-to-text gap.
            padding: const EdgeInsetsDirectional.only(start: Spacing.$10x + Spacing.$3x, top: Spacing.$1x),
            child: GestureDetector(
              onTap: onBlock,
              child: Text(
                context.l10n.friendRequestBlockCta,
                style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.errorDefault),
              ),
            ),
          ),
      ],
    ),
  );
}
