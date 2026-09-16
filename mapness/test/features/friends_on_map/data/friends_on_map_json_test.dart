import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_json.dart';

void main() {
  group('meetupFromJson', () {
    test('decodes every field', () {
      final meetup = meetupFromJson({
        'id': 'meetup-1',
        'senderId': 'sender-1',
        'senderDisplayName': 'Fatima',
        'senderProfilePictureUrl': 'https://example.com/fatima.jpg',
        'latitude': 24.7136,
        'longitude': 46.6753,
        'label': 'Coffee shop',
        'createdAt': '2026-09-16T10:00:00.000Z',
      });

      expect(meetup.id, 'meetup-1');
      expect(meetup.senderId, 'sender-1');
      expect(meetup.senderDisplayName, 'Fatima');
      expect(meetup.senderProfilePictureUrl, 'https://example.com/fatima.jpg');
      expect(meetup.latitude, 24.7136);
      expect(meetup.longitude, 46.6753);
      expect(meetup.label, 'Coffee shop');
      expect(meetup.createdAt, DateTime.parse('2026-09-16T10:00:00.000Z'));
    });

    test('decodes with nullable fields absent', () {
      final meetup = meetupFromJson({
        'id': 'meetup-2',
        'senderId': 'sender-2',
        'senderDisplayName': 'Khalid',
        'senderProfilePictureUrl': null,
        'latitude': 21.4225,
        'longitude': 39.8262,
        'label': null,
        'createdAt': '2026-09-16T11:00:00.000Z',
      });

      expect(meetup.senderProfilePictureUrl, isNull);
      expect(meetup.label, isNull);
    });

    test('accepts integer-valued lat/lng (num, not just double)', () {
      final meetup = meetupFromJson({
        'id': 'meetup-3',
        'senderId': 'sender-3',
        'senderDisplayName': 'Sara',
        'latitude': 24,
        'longitude': 46,
        'createdAt': '2026-09-16T12:00:00.000Z',
      });

      expect(meetup.latitude, 24.0);
      expect(meetup.longitude, 46.0);
    });
  });
}
