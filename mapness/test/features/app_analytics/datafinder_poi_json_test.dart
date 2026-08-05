import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';

/// Locks the JSON payloads of [DataFinderPoi] — in particular that
/// `suggestion_exposure` carries `suggestion_type` (BRD) without leaking it into
/// the `poi_*` payload used by results/click events.
void main() {
  group('DataFinderPoi.toSuggestionJson', () {
    test('includes suggestion_type (from suggestionType field)', () {
      const poi = DataFinderPoi(
        id: '20000004740961831',
        name: 'Al Sadhan Mall',
        address: 'Al Rabwah, Riyadh Region',
        type: 'branch', // object type — must NOT appear in suggestion payload
        distanceKm: 8.03,
        rank: 1,
        suggestionType: 'branch',
      );

      final json = poi.toSuggestionJson();

      expect(json['suggestion_type'], 'branch');
      expect(json['suggestion_name'], 'Al Sadhan Mall');
      expect(json['suggestion_poi_id'], '20000004740961831');
      expect(json['suggestion_poi_addr'], 'Al Rabwah, Riyadh Region');
      expect(json['suggestion_distance'], 8.03);
      expect(json['suggestion_rank'], 1);
      // The suggestion payload must not contain poi_* keys.
      expect(json.containsKey('poi_type'), isFalse);
      expect(json.containsKey('poi_id'), isFalse);
    });

    test('omits suggestion_type when not a suggestion', () {
      const poi = DataFinderPoi(name: 'X', type: 'branch');
      expect(poi.toSuggestionJson().containsKey('suggestion_type'), isFalse);
    });
  });

  group('DataFinderPoi.toJson', () {
    test('poi_type comes from object type, not suggestionType', () {
      const poi = DataFinderPoi(
        id: '1',
        name: 'X',
        type: 'building', // object type
        suggestionType: 'rubric', // suggestion type — must NOT become poi_type
        rank: 2,
      );

      final json = poi.toJson();

      expect(json['poi_type'], 'building');
      expect(json.containsKey('suggestion_type'), isFalse);
    });
  });
}
