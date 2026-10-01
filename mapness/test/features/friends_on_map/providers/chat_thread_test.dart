import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/friends_on_map/data/chat_repository.dart';
import 'package:mapness/features/friends_on_map/models/chat_message.dart';
import 'package:mapness/features/friends_on_map/models/conversation.dart';
import 'package:mapness/features/friends_on_map/providers/chat_repository.dart';
import 'package:mapness/features/friends_on_map/providers/chat_thread.dart';

class _ThreadRepo implements ChatRepository {
  _ThreadRepo(this.initial);

  final List<ChatMessage> initial;

  @override
  Future<ChatThreadPage> getThread(String friendId, {int? before, int limit = 50}) async =>
      ChatThreadPage(items: initial);

  @override
  Future<ConversationList> getConversations() async => const ConversationList(items: [], unreadTotal: 0);

  @override
  Future<ChatMessage> sendMessage({
    required String friendId,
    required String clientMessageId,
    required ChatMessageKind kind,
    required DateTime composedAt,
    String? body,
    ChatPlace? place,
  }) => throw UnimplementedError();

  @override
  Future<void> markRead(String friendId) async {}

  @override
  Future<void> deleteMessage(String messageId) async {}

  @override
  Future<void> reportMessage(String messageId) async {}

  @override
  Future<void> reportConversation(String friendId) async {}
}

ChatMessage _m(int seq, {String? body, ChatMessageStatus status = ChatMessageStatus.sent}) => ChatMessage(
  id: 'm$seq',
  seq: seq,
  mine: false,
  kind: ChatMessageKind.text,
  body: body ?? 'msg $seq',
  composedAt: DateTime.utc(2026, 10, 2, 10, seq),
  createdAt: DateTime.utc(2026, 10, 2, 10, seq),
  status: status,
);

void main() {
  Future<ProviderContainer> open(List<ChatMessage> initial) async {
    final container = ProviderContainer(overrides: [chatRepositoryProvider.overrideWithValue(_ThreadRepo(initial))]);
    addTearDown(container.dispose);
    await container.read(chatThreadProvider('f1').future);
    return container;
  }

  test('upsert replaces a message with the same id', () async {
    final container = await open([_m(1), _m(2)]);
    container.read(chatThreadProvider('f1').notifier).upsert(_m(2, body: 'edited', status: ChatMessageStatus.read));

    final items = container.read(chatThreadProvider('f1')).value!.items;
    expect(items.map((m) => m.id), ['m1', 'm2']);
    expect(items.last.body, 'edited');
    expect(items.last.status, ChatMessageStatus.read);
  });

  test('upsert appends a newer message', () async {
    final container = await open([_m(1), _m(2)]);
    container.read(chatThreadProvider('f1').notifier).upsert(_m(3));

    expect(container.read(chatThreadProvider('f1')).value!.items.map((m) => m.id), ['m1', 'm2', 'm3']);
  });

  test('an out-of-order event is inserted by seq, not appended', () async {
    final container = await open([_m(1), _m(3)]);
    container.read(chatThreadProvider('f1').notifier).upsert(_m(2));

    expect(container.read(chatThreadProvider('f1')).value!.items.map((m) => m.id), ['m1', 'm2', 'm3']);
  });

  test('upsert before the first page has loaded is ignored (the fetch will carry it)', () {
    final container = ProviderContainer(
      overrides: [
        chatRepositoryProvider.overrideWithValue(_ThreadRepo([_m(1)])),
      ],
    );
    addTearDown(container.dispose);

    container.read(chatThreadProvider('f1').notifier).upsert(_m(2));

    expect(container.read(chatThreadProvider('f1')).hasValue, isFalse);
  });
}
