import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/app_analytics/insider_custom_action_handler.dart';

void main() {
  group('InsiderCustomActionHandler', () {
    test('handles null payload safely without throwing', () {
      expect(() => InsiderCustomActionHandler.handleCustomAction(null), returnsNormally);
    });

    test('handles empty payload safely without throwing', () {
      expect(() => InsiderCustomActionHandler.handleCustomAction({}), returnsNormally);
    });

    test('handles Map payload with open_url action', () {
      final payload = {
        'action': 'open_url',
        'url': 'https://balady.gov.sa',
      };
      expect(() => InsiderCustomActionHandler.handleCustomAction(payload), returnsNormally);
    });

    test('handles JSON string payload with navigate action', () {
      const payloadJson = '{"action": "navigate", "route": "/search"}';
      expect(() => InsiderCustomActionHandler.handleCustomAction(payloadJson), returnsNormally);
    });

    test('handles Map payload with open_screen action', () {
      final payload = {
        'action': 'open_screen',
        'screen': 'profile_page',
      };
      expect(() => InsiderCustomActionHandler.handleCustomAction(payload), returnsNormally);
    });

    test('handles Map payload with show_dialog action', () {
      final payload = {
        'action': 'show_dialog',
        'title': 'Campaign Dialog',
        'message': 'Welcome to Lucky Location!',
      };
      expect(() => InsiderCustomActionHandler.handleCustomAction(payload), returnsNormally);
    });

    test('handles invalid JSON string safely without throwing', () {
      const invalidJson = 'not_a_valid_json';
      expect(() => InsiderCustomActionHandler.handleCustomAction(invalidJson), returnsNormally);
    });
  });
}
