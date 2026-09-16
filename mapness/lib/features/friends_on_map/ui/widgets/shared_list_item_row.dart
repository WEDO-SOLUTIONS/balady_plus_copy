import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/friends_on_map/models/shared_list_item.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_avatar.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class SharedListItemRow extends StatelessWidget {
  final SharedListItem item;
  final VoidCallback onRemove;

  const SharedListItemRow({required this.item, required this.onRemove, super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Spacing.$2x, horizontal: Spacing.$4x),
    child: Row(
      children: [
        FriendAvatar(displayName: item.adderDisplayName, profilePictureUrl: item.adderProfilePictureUrl),
        const SizedBox(width: Spacing.$3x),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.label != null)
                Text(
                  item.label!,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.bodyLargeMedium.copyWith(color: context.colors.foregroundDefault),
                ),
              Text(
                context.l10n.sharedListDetailAddedByLabel(item.adderDisplayName),
                style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundMuted),
              ),
            ],
          ),
        ),
        if (item.canRemove)
          IconButton(
            icon: Icon(GeneralIcons.trash, color: context.colors.errorDefault),
            onPressed: onRemove,
          ),
      ],
    ),
  );
}
