import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/friends_on_map/models/friend.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_avatar.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// R-41: avatar (or initials fallback) + display name. Deliberately no
/// presence indicator, district or elapsed time yet — see
/// `friends_on_map/AGENTS.md` for why.
class FriendListItem extends StatelessWidget {
  final Friend friend;

  const FriendListItem({required this.friend, super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Spacing.$2x, horizontal: Spacing.$4x),
    child: Row(
      children: [
        FriendAvatar(displayName: friend.displayName, profilePictureUrl: friend.profilePictureUrl),
        const SizedBox(width: Spacing.$3x),
        Expanded(
          child: Text(
            friend.displayName,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.bodyLargeMedium.copyWith(color: context.colors.foregroundDefault),
          ),
        ),
      ],
    ),
  );
}
