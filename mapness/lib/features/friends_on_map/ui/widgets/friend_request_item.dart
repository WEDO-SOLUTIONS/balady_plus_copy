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
  Widget build(BuildContext context) {
    final isIncoming = request.direction == FriendRequestDirection.incoming;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.$1_5x, horizontal: Spacing.$4x),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.backgroundSurface1,
          borderRadius: BorderRadius.circular(RadiusBorder.xl),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.$3x),
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
                  if (!isIncoming) ...[
                    const SizedBox(width: Spacing.$2x),
                    AppButton(
                      buttonColorScheme: ButtonColorScheme.accentSecondary,
                      buttonType: ButtonType.secondary,
                      primaryLabel: context.l10n.friendRequestCancelCta,
                      onTap: onCancel,
                    ),
                  ],
                ],
              ),
              if (isIncoming) ...[
                const SizedBox(height: Spacing.$3x),
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
                  ],
                ),
                // Not in the dark-theme design, kept so R-44 (block straight
                // from a request) stays reachable — see friends_on_map/AGENTS.md.
                const SizedBox(height: Spacing.$2x),
                Center(
                  child: GestureDetector(
                    onTap: onBlock,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Spacing.$1x, horizontal: Spacing.$2x),
                      child: Text(
                        context.l10n.friendRequestBlockCta,
                        style: context.textStyles.bodySmallMedium.copyWith(color: context.colors.errorDefault),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
