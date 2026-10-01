import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/friends_on_map/models/chat_message.dart';
import 'package:mapness/features/friends_on_map/providers/chat_presence.dart';
import 'package:mapness/features/friends_on_map/providers/incoming_chat_notice.dart';

ChatMessage _msg({
  bool mine = false,
  bool deleted = false,
  ChatMessageKind kind = ChatMessageKind.text,
  String? body = 'hello',
}) => ChatMessage(
  id: 'm',
  seq: 1,
  mine: mine,
  kind: kind,
  body: body,
  composedAt: DateTime.utc(2026, 10, 2),
  status: ChatMessageStatus.sent,
  deleted: deleted,
);

bool _notify({
  ChatMessage? message,
  String friendId = 'bob',
  bool foreground = true,
  ChatPresenceState presence = const ChatPresenceState(),
  bool navigation = false,
}) => shouldNotifyIncomingMessage(
  message: message ?? _msg(),
  friendId: friendId,
  appInForeground: foreground,
  presence: presence,
  navigationActive: navigation,
);

void main() {
  // The notifier reads WidgetsBinding's lifecycle state.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('shouldNotifyIncomingMessage', () {
    test('a plain incoming message notifies', () => expect(_notify(), isTrue));

    test('own message (another device) never notifies', () => expect(_notify(message: _msg(mine: true)), isFalse));

    test('a deleted message never notifies', () => expect(_notify(message: _msg(deleted: true)), isFalse));

    test('not while the app is backgrounded', () => expect(_notify(foreground: false), isFalse));

    test('not during active navigation', () => expect(_notify(navigation: true), isFalse));

    test('not while the chat with that friend is open', () {
      expect(_notify(presence: const ChatPresenceState(chatFriendId: 'bob')), isFalse);
    });

    test('yes while a chat with a DIFFERENT friend is open', () {
      expect(_notify(presence: const ChatPresenceState(chatFriendId: 'carol')), isTrue);
    });

    test('not while the conversation list is open', () {
      expect(_notify(presence: const ChatPresenceState(conversationsOpen: true)), isFalse);
    });
  });

  group('IncomingChatNotice', () {
    ProviderContainer make({bool navigation = false}) {
      final container = ProviderContainer(
        overrides: [chatNavigationActiveProvider.overrideWithValue(navigation)],
      );
      addTearDown(container.dispose);
      return container;
    }

    void incoming(ProviderContainer c, {String friendId = 'bob', String name = 'Bob', ChatMessage? message}) {
      c
          .read(incomingChatNoticeProvider.notifier)
          .onIncoming(friendId: friendId, friendDisplayName: name, message: message ?? _msg());
    }

    test('emits a notice with the text and the friend name', () {
      final c = make();
      incoming(c);

      final notice = c.read(incomingChatNoticeProvider)!;
      expect(notice.friendId, 'bob');
      expect(notice.friendDisplayName, 'Bob');
      expect(notice.preview, 'hello');
      expect(notice.count, 1);
      expect(notice.isPlace, isFalse);
    });

    test('a place card has no preview text', () {
      final c = make();
      incoming(c, message: _msg(kind: ChatMessageKind.placeCard, body: null));

      final notice = c.read(incomingChatNoticeProvider)!;
      expect(notice.isPlace, isTrue);
      expect(notice.preview, isNull);
    });

    test('a long message preview is truncated', () {
      final c = make();
      incoming(c, message: _msg(body: 'x' * 500));

      expect(c.read(incomingChatNoticeProvider)!.preview!.length, kChatNoticePreviewMax + 1);
      expect(c.read(incomingChatNoticeProvider)!.preview, endsWith('…'));
    });

    test('quick follow-ups from the same friend fold into one counted notice', () {
      final c = make();
      incoming(c);
      final first = c.read(incomingChatNoticeProvider)!;
      incoming(c);
      incoming(c);

      final notice = c.read(incomingChatNoticeProvider)!;
      expect(notice.count, 3);
      expect(notice.id, isNot(first.id), reason: 'each emission must be a new notice so listeners fire');
    });

    test('a different friend starts a fresh count', () {
      final c = make();
      incoming(c);
      incoming(c);
      incoming(c, friendId: 'carol', name: 'Carol');

      final notice = c.read(incomingChatNoticeProvider)!;
      expect(notice.friendId, 'carol');
      expect(notice.count, 1);
    });

    test('nothing is emitted while that chat is open', () {
      final c = make();
      c.read(chatPresenceProvider.notifier).chatOpened('bob');
      incoming(c);

      expect(c.read(incomingChatNoticeProvider), isNull);
    });

    test('nothing is emitted during navigation', () {
      final c = make(navigation: true);
      incoming(c);

      expect(c.read(incomingChatNoticeProvider), isNull);
    });
  });

  group('ChatPresence', () {
    test('replacing a chat: the old screen closing late must not wipe the new one', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final presence = container.read(chatPresenceProvider.notifier)
        ..chatOpened('bob')
        ..chatOpened('carol')
        ..chatClosed('bob');

      expect(container.read(chatPresenceProvider).chatFriendId, 'carol');
      presence.chatClosed('carol');
      expect(container.read(chatPresenceProvider).chatFriendId, isNull);
    });

    test('chat and list presence are independent', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(chatPresenceProvider.notifier)
        ..conversationsOpened()
        ..chatOpened('bob')
        ..chatClosed('bob');

      expect(container.read(chatPresenceProvider).conversationsOpen, isTrue);
      expect(container.read(chatPresenceProvider).chatFriendId, isNull);
    });
  });
}
