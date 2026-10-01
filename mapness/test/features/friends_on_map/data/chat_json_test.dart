import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_api_exception.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_json.dart';
import 'package:mapness/features/friends_on_map/models/chat_message.dart';

void main() {
  group('chatMessageFromJson', () {
    test('text message with delivery status', () {
      final m = chatMessageFromJson({
        'id': 'm1',
        'seq': 7,
        'mine': true,
        'kind': 'text',
        'body': 'hello',
        'place': null,
        'composedAt': '2026-10-02T10:00:00Z',
        'createdAt': '2026-10-02T10:00:01Z',
        'status': 'delivered',
        'deleted': false,
      });
      expect(m.id, 'm1');
      expect(m.seq, 7);
      expect(m.mine, isTrue);
      expect(m.kind, ChatMessageKind.text);
      expect(m.body, 'hello');
      expect(m.place, isNull);
      expect(m.status, ChatMessageStatus.delivered);
      expect(m.deleted, isFalse);
    });

    test('place card carries the place, not text', () {
      final m = chatMessageFromJson({
        'id': 'm2',
        'seq': 8,
        'mine': false,
        'kind': 'place_card',
        'body': null,
        'place': {'latitude': 24.7, 'longitude': 46.6, 'label': 'Tower'},
        'composedAt': '2026-10-02T10:00:00Z',
        'createdAt': '2026-10-02T10:00:01Z',
        'status': 'read',
        'deleted': false,
      });
      expect(m.kind, ChatMessageKind.placeCard);
      expect(m.body, isNull);
      expect(m.place!.latitude, 24.7);
      expect(m.place!.label, 'Tower');
      expect(m.status, ChatMessageStatus.read);
    });

    test('deleted message keeps only the marker; unknown status degrades to sent', () {
      final m = chatMessageFromJson({
        'id': 'm3',
        'seq': 9,
        'mine': true,
        'kind': 'text',
        'body': null,
        'place': null,
        'composedAt': '2026-10-02T10:00:00Z',
        'createdAt': '2026-10-02T10:00:01Z',
        'status': 'something-new',
        'deleted': true,
      });
      expect(m.deleted, isTrue);
      expect(m.body, isNull);
      expect(m.status, ChatMessageStatus.sent);
    });
  });

  test('conversationListFromJson reads items and the server-computed total', () {
    final list = conversationListFromJson({
      'items': [
        {
          'friendId': 'f1',
          'displayName': 'Bob',
          'profilePictureUrl': null,
          'unreadCount': 3,
          'lastMessage': {
            'id': 'm1',
            'seq': 1,
            'mine': false,
            'kind': 'text',
            'body': 'hi',
            'place': null,
            'composedAt': '2026-10-02T10:00:00Z',
            'createdAt': '2026-10-02T10:00:01Z',
            'status': 'sent',
            'deleted': false,
          },
        },
      ],
      'unreadTotal': 3,
    });
    expect(list.items.single.friendId, 'f1');
    expect(list.items.single.unreadCount, 3);
    expect(list.unreadTotal, 3);
  });

  test('chatThreadPageFromJson: cursor present / absent', () {
    expect(chatThreadPageFromJson({'items': <dynamic>[], 'nextBefore': 42}).nextBefore, 42);
    expect(chatThreadPageFromJson({'items': <dynamic>[], 'nextBefore': null}).nextBefore, isNull);
  });

  test('S-21 limit codes are recognised from the wire', () {
    expect(FriendsOnMapLimitCode.fromWire('message_too_long'), FriendsOnMapLimitCode.messageTooLong);
    expect(FriendsOnMapLimitCode.fromWire('message_rate_limited'), FriendsOnMapLimitCode.messageRateLimited);
    expect(
      FriendsOnMapLimitCode.fromWire('message_delete_window_expired'),
      FriendsOnMapLimitCode.messageDeleteWindowExpired,
    );
  });
}
