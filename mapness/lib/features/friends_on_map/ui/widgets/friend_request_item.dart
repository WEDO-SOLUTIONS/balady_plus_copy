import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/friends_on_map/models/friend_request.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_marker_avatar.dart';
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
            FriendMarkerAvatar(friendId: request.id),
            const SizedBox(width: Spacing.$3x),
            Expanded(
              child: Text(
                request.displayName,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.bodyLargeMedium.copyWith(color: context.colors.foregroundDefault),
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.$4x),
        // design-lab: "Increase the button width so the full name fits
        // comfortably" — buttons get their own full-width row instead of
        // squeezing in next to the name.
        if (request.direction == FriendRequestDirection.incoming)
          Row(
            children: [
              Expanded(
                child: AppButton(
                  buttonColorScheme: ButtonColorScheme.accentSecondary,
                  buttonType: ButtonType.secondary,
                  size: ButtonSize.large,
                  primaryLabel: context.l10n.friendRequestDeclineCta,
                  onTap: onDecline,
                ),
              ),
              const SizedBox(width: Spacing.$2x),
              Expanded(
                child: AppButton(
                  buttonColorScheme: ButtonColorScheme.accentSecondary,
                  size: ButtonSize.large,
                  primaryLabel: context.l10n.friendRequestAcceptCta,
                  onTap: onAccept,
                ),
              ),
              const SizedBox(width: Spacing.$2x),
              Expanded(
                child: AppButton(
                  buttonColorScheme: ButtonColorScheme.error,
                  buttonType: ButtonType.secondary,
                  size: ButtonSize.large,
                  primaryLabel: context.l10n.friendRequestBlockCta,
                  onTap: onBlock,
                ),
              ),
            ],
          )
        else
          SizedBox(
            width: double.infinity,
            child: AppButton(
              buttonColorScheme: ButtonColorScheme.accentSecondary,
              buttonType: ButtonType.secondary,
              size: ButtonSize.large,
              primaryLabel: context.l10n.friendRequestCancelCta,
              onTap: onCancel,
            ),
          ),
      ],
    ),
  );
}
