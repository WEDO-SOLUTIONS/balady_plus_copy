import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/friends_on_map/models/shared_list_member.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_avatar.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class SharedListMemberRow extends StatelessWidget {
  final SharedListMember member;
  final VoidCallback onRemove;

  const SharedListMemberRow({required this.member, required this.onRemove, super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Spacing.$2x, horizontal: Spacing.$4x),
    child: Row(
      children: [
        FriendAvatar(displayName: member.displayName, profilePictureUrl: member.profilePictureUrl),
        const SizedBox(width: Spacing.$3x),
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  member.displayName,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.bodyLargeMedium.copyWith(color: context.colors.foregroundDefault),
                ),
              ),
              if (member.isOwner) ...[
                const SizedBox(width: Spacing.$2x),
                Text(
                  context.l10n.sharedListDetailOwnerBadge,
                  style: context.textStyles.captionLargeRegular.copyWith(color: context.colors.foregroundMuted),
                ),
              ],
            ],
          ),
        ),
        if (member.canRemove)
          IconButton(
            icon: Icon(GeneralIcons.trash, color: context.colors.errorDefault),
            onPressed: onRemove,
          ),
      ],
    ),
  );
}
