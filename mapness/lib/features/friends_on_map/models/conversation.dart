import 'package:mapness/features/friends_on_map/models/chat_message.dart';

/// One row of the conversation list (R-105).
class Conversation {
  final String friendId;
  final String displayName;
  final String? profilePictureUrl;
  final ChatMessage lastMessage;
  final int unreadCount;

  const Conversation({
    required this.friendId,
    required this.displayName,
    required this.lastMessage,
    required this.unreadCount,
    this.profilePictureUrl,
  });
}

/// The conversation list plus the total unread count (R-104) — the server
/// sends the total so the client never sums a possibly-partial list.
class ConversationList {
  final List<Conversation> items;
  final int unreadTotal;

  const ConversationList({required this.items, required this.unreadTotal});
}

/// One page of a thread, oldest first. [nextBefore] is the cursor for the
/// next, older page; null once the start of the thread is reached.
class ChatThreadPage {
  final List<ChatMessage> items;
  final int? nextBefore;

  const ChatThreadPage({required this.items, this.nextBefore});
}
