import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/friends_on_map/models/friend_request.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_avatar.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// R-36 (incoming: Accept/Decline) / R-37 (outgoing: Cancel).
class FriendRequestItem extends StatelessWidget {
  final FriendRequest request;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onCancel;

  const FriendRequestItem({required this.request, this.onAccept, this.onDecline, this.onCancel, super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Spacing.$2x, horizontal: Spacing.$4x),
    child: Row(
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
  );
}
