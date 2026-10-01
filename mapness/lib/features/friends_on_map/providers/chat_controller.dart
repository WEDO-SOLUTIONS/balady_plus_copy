import 'package:mapness/features/friends_on_map/data/friends_on_map_api_exception.dart';
import 'package:mapness/features/friends_on_map/models/chat_message.dart';
import 'package:mapness/features/friends_on_map/models/outbox_message.dart';
import 'package:mapness/features/friends_on_map/providers/chat_outbox.dart';
import 'package:mapness/features/friends_on_map/providers/chat_repository.dart';
import 'package:mapness/features/friends_on_map/providers/chat_thread.dart';
import 'package:mapness/features/friends_on_map/providers/conversations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'chat_controller.g.dart';

/// S-21 mutation surface, kept separate from the plain reads — same split as
/// `meetups_controller.dart`. keepAlive from day one: only ever reached via
/// `.notifier` from button callbacks (the bug `FriendsController` shipped
/// with), and every method guards `ref.mounted` after each await.
///
/// Methods throw [FriendsOnMapApiException] for a refusal the user should
/// see; callers wrap them in `runFriendsOnMapAction`.
@Riverpod(keepAlive: true)
class ChatController extends _$ChatController {
  @override
  void build() {}

  /// R-100: queues a text message (R-103: it is in the thread immediately,
  /// whether or not the network is up) and starts sending it.
  Future<void> sendText(String friendId, String text) {
    final body = text.trim();
    if (body.isEmpty) {
      return Future<void>.value();
    }
    return _enqueue(
      OutboxMessage(
        friendId: friendId,
        clientMessageId: const Uuid().v4(),
        kind: ChatMessageKind.text,
        body: body,
        composedAt: DateTime.now(),
      ),
    );
  }

  /// R-117: queues a place card.
  Future<void> sendPlace(String friendId, {required double latitude, required double longitude, String? label}) =>
      _enqueue(
        OutboxMessage(
          friendId: friendId,
          clientMessageId: const Uuid().v4(),
          kind: ChatMessageKind.placeCard,
          place: ChatPlace(latitude: latitude, longitude: longitude, label: label),
          composedAt: DateTime.now(),
        ),
      );

  Future<void> _enqueue(OutboxMessage message) async {
    final refusal = await ref.read(chatOutboxProvider.notifier).enqueue(message);
    if (refusal != null) {
      throw refusal;
    }
  }

  /// Re-sends a message that was refused earlier.
  Future<void> retry(String clientMessageId) async {
    final refusal = await ref.read(chatOutboxProvider.notifier).retry(clientMessageId);
    if (refusal != null) {
      throw refusal;
    }
  }

  Future<void> discard(String clientMessageId) => ref.read(chatOutboxProvider.notifier).discard(clientMessageId);

  /// R-102: only called when the user actually has the conversation open.
  Future<void> markRead(String friendId) async {
    await ref.read(chatRepositoryProvider).markRead(friendId);
    if (!ref.mounted) {
      return;
    }
    ref.invalidate(conversationsProvider);
  }

  /// R-107.
  Future<void> deleteMessage(String messageId) async {
    await ref.read(chatRepositoryProvider).deleteMessage(messageId);
    _refreshAll();
  }

  /// R-108.
  Future<void> reportMessage(String messageId) async {
    await ref.read(chatRepositoryProvider).reportMessage(messageId);
    _refreshAll();
  }

  /// R-108.
  Future<void> reportConversation(String friendId) async {
    await ref.read(chatRepositoryProvider).reportConversation(friendId);
    _refreshAll();
  }

  void _refreshAll() {
    if (!ref.mounted) {
      return;
    }
    ref
      ..invalidate(conversationsProvider)
      ..invalidate(chatThreadProvider);
  }
}
