import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/friends_on_map/models/chat_message.dart';
import 'package:mapness/features/friends_on_map/models/conversation.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_marker_avatar.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// R-104 Appendix B: unread counts above this display as "99+".
const int kChatUnreadDisplayCap = 99;

/// Formats an unread count with the Appendix B cap.
String chatUnreadLabel(int count) => count > kChatUnreadDisplayCap ? '$kChatUnreadDisplayCap+' : '$count';

/// One row of the conversation list (R-105): friend, last message, time and
/// unread count.
class ConversationListItem extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ConversationListItem({required this.conversation, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final last = conversation.lastMessage;
    final preview = last.deleted
        ? context.l10n.chatMessageDeleted
        : last.kind == ChatMessageKind.placeCard
        ? context.l10n.chatPreviewPlace
        : (last.body ?? '');
    final unread = conversation.unreadCount;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.$2x, horizontal: Spacing.$4x),
        child: Row(
          children: [
            FriendMarkerAvatar(friendId: conversation.friendId),
            const SizedBox(width: Spacing.$3x),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    conversation.displayName,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.bodyLargeMedium.copyWith(color: context.colors.foregroundDefault),
                  ),
                  Text(
                    preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.bodySmallRegular.copyWith(
                      color: unread > 0 ? context.colors.foregroundDefault : context.colors.foregroundMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Spacing.$2x),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  TimeOfDay.fromDateTime((last.createdAt ?? last.composedAt).toLocal()).format(context),
                  style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                ),
                if (unread > 0)
                  Container(
                    margin: const EdgeInsets.only(top: Spacing.$1x),
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.$2x, vertical: 2),
                    decoration: BoxDecoration(
                      color: context.colors.accentDefault,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      chatUnreadLabel(unread),
                      style: context.textStyles.bodySmallSemiBold.copyWith(
                        color: context.colors.foregroundDefaultInversion,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
