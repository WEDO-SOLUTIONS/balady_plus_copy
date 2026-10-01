import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mapness/features/friends_on_map/data/chat_repository.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_api_exception.dart';
import 'package:mapness/features/friends_on_map/models/chat_message.dart';
import 'package:mapness/features/friends_on_map/models/conversation.dart';
import 'package:mapness/features/friends_on_map/models/outbox_message.dart';
import 'package:mapness/features/friends_on_map/providers/chat_outbox.dart';
import 'package:mapness/features/friends_on_map/providers/chat_repository.dart';

/// Records every send and answers per a script, so the outbox's ordering and
/// failure policy (R-103) can be asserted without a network or a device.
class _FakeChatRepository implements ChatRepository {
  final List<String> sent = [];
  Exception? Function(String clientMessageId)? failWith;
  int attempts = 0;

  @override
  Future<ChatMessage> sendMessage({
    required String friendId,
    required String clientMessageId,
    required ChatMessageKind kind,
    required DateTime composedAt,
    String? body,
    ChatPlace? place,
  }) async {
    attempts++;
    final failure = failWith?.call(clientMessageId);
    if (failure != null) {
      throw failure;
    }
    sent.add(clientMessageId);
    return ChatMessage(
      id: 'srv-$clientMessageId',
      seq: sent.length,
      mine: true,
      kind: kind,
      body: body,
      place: place,
      composedAt: composedAt,
      createdAt: composedAt,
      status: ChatMessageStatus.sent,
    );
  }

  @override
  Future<ConversationList> getConversations() async => const ConversationList(items: [], unreadTotal: 0);

  @override
  Future<ChatThreadPage> getThread(String friendId, {int? before, int limit = 50}) async =>
      const ChatThreadPage(items: []);

  @override
  Future<void> markRead(String friendId) async {}

  @override
  Future<void> deleteMessage(String messageId) async {}

  @override
  Future<void> reportMessage(String messageId) async {}

  @override
  Future<void> reportConversation(String friendId) async {}
}

const _network = FriendsOnMapApiException(statusCode: null, message: 'offline');
const _rateLimited = FriendsOnMapApiException(
  statusCode: 429,
  message: 'slow down',
  limitCode: FriendsOnMapLimitCode.messageRateLimited,
  limit: 300,
);

OutboxMessage _msg(String id, {int minute = 0}) => OutboxMessage(
  friendId: 'friend-1',
  clientMessageId: id,
  kind: ChatMessageKind.text,
  body: 'text $id',
  composedAt: DateTime.utc(2026, 10, 2, 10, minute),
);

Future<void> _settle() async {
  for (var i = 0; i < 10; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  late Directory dir;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('chat_outbox_test');
    Hive.init(dir.path);
  });

  tearDown(() async {
    await _settle();
    await Hive.close();
    try {
      dir.deleteSync(recursive: true);
    } on FileSystemException {
      // Hive may still be removing its own lock file.
    }
  });

  ProviderContainer makeContainer(_FakeChatRepository repo) {
    final container = ProviderContainer(overrides: [chatRepositoryProvider.overrideWithValue(repo)]);
    addTearDown(container.dispose);
    return container;
  }

  test('a message is sent once and leaves the outbox', () async {
    final repo = _FakeChatRepository();
    final container = makeContainer(repo);

    final refusal = await container.read(chatOutboxProvider.notifier).enqueue(_msg('a'));

    expect(refusal, isNull);
    expect(repo.sent, ['a']);
    expect(await container.read(chatOutboxProvider.future), isEmpty);
  });

  test('a network failure keeps it pending (not failed) and stops later messages overtaking it', () async {
    final repo = _FakeChatRepository()..failWith = (_) => _network;
    final container = makeContainer(repo);
    final outbox = container.read(chatOutboxProvider.notifier);

    expect(await outbox.enqueue(_msg('a', minute: 1)), isNull);
    expect(await outbox.enqueue(_msg('b', minute: 2)), isNull);

    final items = await container.read(chatOutboxProvider.future);
    expect(items.map((i) => i.clientMessageId), ['a', 'b']);
    expect(items.every((i) => !i.failed), isTrue);
    // 'b' was never even attempted: order is preserved.
    expect(repo.attempts, 2); // one attempt per flush, both on 'a'
    expect(repo.sent, isEmpty);

    // Network back: the next trigger sends everything, oldest first, with the
    // same clientMessageIds (idempotent on the server).
    repo.failWith = null;
    await outbox.flush();
    expect(repo.sent, ['a', 'b']);
    expect(await container.read(chatOutboxProvider.future), isEmpty);
  });

  test('a refusal marks only that message failed, never auto-retries it, and does not block the rest', () async {
    final repo = _FakeChatRepository()..failWith = (id) => id == 'a' ? _rateLimited : null;
    final container = makeContainer(repo);
    final outbox = container.read(chatOutboxProvider.notifier);

    final refusal = await outbox.enqueue(_msg('a', minute: 1));
    expect(refusal?.limitCode, FriendsOnMapLimitCode.messageRateLimited);
    expect(await outbox.enqueue(_msg('b', minute: 2)), isNull);

    var items = await container.read(chatOutboxProvider.future);
    expect(items.map((i) => (i.clientMessageId, i.failed)), [('a', true)]);
    expect(repo.sent, ['b']);

    // A later flush must not touch the failed one.
    final attemptsBefore = repo.attempts;
    await outbox.flush();
    expect(repo.attempts, attemptsBefore);

    // The user retries once the limit has cleared.
    repo.failWith = null;
    expect(await outbox.retry('a'), isNull);
    expect(repo.sent, ['b', 'a']);
    items = await container.read(chatOutboxProvider.future);
    expect(items, isEmpty);
  });

  test('discard drops a failed message for good', () async {
    final repo = _FakeChatRepository()..failWith = (_) => _rateLimited;
    final container = makeContainer(repo);
    final outbox = container.read(chatOutboxProvider.notifier);

    await outbox.enqueue(_msg('a'));
    await outbox.discard('a');

    expect(await container.read(chatOutboxProvider.future), isEmpty);
  });

  test('pending messages survive a restart and are resumed automatically (R-103)', () async {
    final offline = _FakeChatRepository()..failWith = (_) => _network;
    final first = ProviderContainer(overrides: [chatRepositoryProvider.overrideWithValue(offline)]);
    await first.read(chatOutboxProvider.notifier).enqueue(_msg('a', minute: 1));
    await first.read(chatOutboxProvider.notifier).enqueue(_msg('b', minute: 2));
    first.dispose();
    await _settle();

    final online = _FakeChatRepository();
    final second = makeContainer(online);
    final restored = await second.read(chatOutboxProvider.future);
    expect(restored.map((i) => i.clientMessageId), ['a', 'b']);

    await _settle();
    expect(online.sent, ['a', 'b']);
    expect(await second.read(chatOutboxProvider.future), isEmpty);
  });
}
