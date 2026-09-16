import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_json.dart';
import 'package:mapness/features/friends_on_map/models/shared_list_detail.dart';

void main() {
  group('sharedListFromJson', () {
    test('decodes every field', () {
      final list = sharedListFromJson({
        'id': 'list-1',
        'ownerId': 'owner-1',
        'name': 'Weekend spots',
        'createdAt': '2026-09-16T10:00:00.000Z',
        'memberCount': 3,
        'itemCount': 5,
      });

      expect(list.id, 'list-1');
      expect(list.ownerId, 'owner-1');
      expect(list.name, 'Weekend spots');
      expect(list.createdAt, DateTime.parse('2026-09-16T10:00:00.000Z'));
      expect(list.memberCount, 3);
      expect(list.itemCount, 5);
    });
  });

  group('sharedListMemberFromJson', () {
    test('decodes every field', () {
      final member = sharedListMemberFromJson({
        'accountId': 'account-1',
        'displayName': 'Fatima',
        'profilePictureUrl': 'https://example.com/fatima.jpg',
        'isOwner': true,
        'canRemove': false,
      });

      expect(member.accountId, 'account-1');
      expect(member.displayName, 'Fatima');
      expect(member.profilePictureUrl, 'https://example.com/fatima.jpg');
      expect(member.isOwner, isTrue);
      expect(member.canRemove, isFalse);
    });

    test('decodes with nullable profilePictureUrl absent', () {
      final member = sharedListMemberFromJson({
        'accountId': 'account-2',
        'displayName': 'Khalid',
        'profilePictureUrl': null,
        'isOwner': false,
        'canRemove': true,
      });

      expect(member.profilePictureUrl, isNull);
    });
  });

  group('sharedListItemFromJson', () {
    test('decodes every field', () {
      final item = sharedListItemFromJson({
        'id': 'item-1',
        'adderId': 'account-1',
        'adderDisplayName': 'Fatima',
        'adderProfilePictureUrl': 'https://example.com/fatima.jpg',
        'latitude': 24.7136,
        'longitude': 46.6753,
        'label': 'Coffee shop',
        'createdAt': '2026-09-16T10:00:00.000Z',
        'canRemove': true,
      });

      expect(item.id, 'item-1');
      expect(item.adderId, 'account-1');
      expect(item.adderDisplayName, 'Fatima');
      expect(item.adderProfilePictureUrl, 'https://example.com/fatima.jpg');
      expect(item.latitude, 24.7136);
      expect(item.longitude, 46.6753);
      expect(item.label, 'Coffee shop');
      expect(item.createdAt, DateTime.parse('2026-09-16T10:00:00.000Z'));
      expect(item.canRemove, isTrue);
    });

    test('decodes with nullable fields absent', () {
      final item = sharedListItemFromJson({
        'id': 'item-2',
        'adderId': 'account-2',
        'adderDisplayName': 'Khalid',
        'adderProfilePictureUrl': null,
        'latitude': 21.4225,
        'longitude': 39.8262,
        'label': null,
        'createdAt': '2026-09-16T11:00:00.000Z',
        'canRemove': false,
      });

      expect(item.adderProfilePictureUrl, isNull);
      expect(item.label, isNull);
    });
  });

  group('sharedListDetailFromJson', () {
    test('decodes owner role with members and items', () {
      final detail = sharedListDetailFromJson({
        'id': 'list-1',
        'ownerId': 'account-1',
        'name': 'Weekend spots',
        'createdAt': '2026-09-16T10:00:00.000Z',
        'callerRole': 'owner',
        'members': [
          {
            'accountId': 'account-1',
            'displayName': 'Fatima',
            'profilePictureUrl': null,
            'isOwner': true,
            'canRemove': false,
          },
        ],
        'items': [
          {
            'id': 'item-1',
            'adderId': 'account-1',
            'adderDisplayName': 'Fatima',
            'adderProfilePictureUrl': null,
            'latitude': 24.7136,
            'longitude': 46.6753,
            'label': null,
            'createdAt': '2026-09-16T10:00:00.000Z',
            'canRemove': true,
          },
        ],
      });

      expect(detail.callerRole, SharedListRole.owner);
      expect(detail.isOwner, isTrue);
      expect(detail.members, hasLength(1));
      expect(detail.items, hasLength(1));
    });

    test('decodes member role', () {
      final detail = sharedListDetailFromJson({
        'id': 'list-2',
        'ownerId': 'account-1',
        'name': 'Weekend spots',
        'createdAt': '2026-09-16T10:00:00.000Z',
        'callerRole': 'member',
        'members': <Map<String, dynamic>>[],
        'items': <Map<String, dynamic>>[],
      });

      expect(detail.callerRole, SharedListRole.member);
      expect(detail.isOwner, isFalse);
    });
  });
}
