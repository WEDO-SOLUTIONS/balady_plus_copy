import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/friends_on_map/friend_elapsed_time.dart';
import 'package:mapness/features/friends_on_map/models/friend.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_card_sheet.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_marker_avatar.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// R-41: marker-style icon (same illustration as the friend's map marker —
/// see `friend_marker_illustration.dart` — not their real profile photo) +
/// display name + last-seen (R-53's `friendElapsedTimeLabel`, reused as-is —
/// omitted when [Friend.lastPositionAt] is null). The trailing "⋯" is this
/// feature's first non-marker entry point into [showFriendCardSheet] — see
/// `friends_on_map/AGENTS.md`'s R-54 note.
class FriendListItem extends StatelessWidget {
  final Friend friend;

  const FriendListItem({required this.friend, super.key});

  @override
  Widget build(BuildContext context) {
    final lastSeen = friend.lastPositionAt == null
        ? null
        : friendElapsedTimeLabel(context.l10n, friend.lastPositionAt!);

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.$3x),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.backgroundSurface1,
          borderRadius: BorderRadius.circular(RadiusBorder.xl),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$3x, vertical: Spacing.$3x),
          child: Row(
            children: [
              FriendMarkerAvatar(friendId: friend.id),
              const SizedBox(width: Spacing.$3x),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      friend.displayName,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.bodyLargeMedium.copyWith(color: context.colors.foregroundDefault),
                    ),
                    if (lastSeen != null)
                      Text(
                        lastSeen,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => showFriendCardSheet(context, friend),
                child: Icon(SystemIcons.ellipsis, color: context.colors.foregroundSoft),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
