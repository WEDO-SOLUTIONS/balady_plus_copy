import 'package:mapness/features/friends_on_map/models/chat_message.dart';
import 'package:mapness/features/friends_on_map/models/conversation.dart';

/// Server-side counterpart of one-to-one chat (S-21) — `GET
/// /v1/conversations`, `GET/PUT /v1/conversations/{friendId}/messages…`,
/// `POST …/read`, `POST …/report`, `DELETE /v1/messages/{id}`, `POST
/// /v1/messages/{id}/report`. Only `RemoteChatRepository` implements it.
abstract class ChatRepository {
  /// R-105: every conversation, most recent activity first, plus the total
  /// unread count (R-104).
  Future<ConversationList> getConversations();

  /// One page of the thread with [friendId], oldest first. [before] is the
  /// previous page's `nextBefore` cursor.
  Future<ChatThreadPage> getThread(String friendId, {int? before, int limit = 50});

  /// R-100/R-117: sends one message. Idempotent on [clientMessageId] — a
  /// replay returns the already-stored message, which is what lets the
  /// offline outbox (R-103) retry safely.
  Future<ChatMessage> sendMessage({
    required String friendId,
    required String clientMessageId,
    required ChatMessageKind kind,
    required DateTime composedAt,
    String? body,
    ChatPlace? place,
  });

  /// R-102: marks everything the friend sent as read. Only ever called when
  /// the user actually opens the conversation.
  Future<void> markRead(String friendId);

  /// R-107: deletes the user's own message for both parties.
  Future<void> deleteMessage(String messageId);

  /// R-108: reports a received message; it disappears for the reporter.
  Future<void> reportMessage(String messageId);

  /// R-108: reports everything the friend has sent so far.
  Future<void> reportConversation(String friendId);
}
