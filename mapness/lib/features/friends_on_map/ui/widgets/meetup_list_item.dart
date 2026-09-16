import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/friends_on_map/friend_elapsed_time.dart';
import 'package:mapness/features/friends_on_map/models/meetup.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_avatar.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// One row on `meetup_list_page.dart` — sender identity, optional label,
/// relative time (reuses `friend_elapsed_time.dart`'s formatting, same
/// shape the friend card already uses for R-53).
class MeetupListItem extends StatelessWidget {
  final Meetup meetup;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const MeetupListItem({required this.meetup, required this.onTap, required this.onDismiss, super.key});

  @override
  Widget build(BuildContext context) => Dismissible(
    key: ValueKey(meetup.id),
    direction: DismissDirection.endToStart,
    onDismissed: (_) => onDismiss(),
    background: ColoredBox(
      color: context.colors.errorDefault,
      child: Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: Icon(GeneralIcons.trash, color: context.colors.foregroundDefaultInversion),
        ),
      ),
    ),
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.$2x, horizontal: Spacing.$4x),
        child: Row(
          children: [
            FriendAvatar(displayName: meetup.senderDisplayName, profilePictureUrl: meetup.senderProfilePictureUrl),
            const SizedBox(width: Spacing.$3x),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    meetup.senderDisplayName,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.bodyLargeMedium.copyWith(color: context.colors.foregroundDefault),
                  ),
                  if (meetup.label != null)
                    Text(
                      meetup.label!,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundMuted),
                    ),
                  Text(
                    friendElapsedTimeLabel(context.l10n, meetup.createdAt),
                    style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
