import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_icon_resolver.dart';

void main() {
  group('DynamicPoiIconResolver.resolve', () {
    // (rubricId, expected basename)
    const knownRubrics = <(String, String)>[
      ('900001', '900001_medical_help.svg'),
      ('900002', '900002_lost_and_found.svg'),
      ('900003', '900003_hajj_support.svg'),
      ('900004', '900004_kiosk_and_pos.svg'),
      ('900005', '900005_additional_category.svg'),
      ('900006', '900006_stair.svg'),
      ('900007', '900007_service.svg'),
      ('900008', '900008_gate.svg'),
      ('900009', '900009_prayer_hall.svg'),
      ('900010', '900010_landmark.svg'),
      ('900011', '900011_luggage_storage.svg'),
      ('900012', '900012_wheelchairs_carts.svg'),
      ('900013', '900013_prayer_area_disabled.svg'),
      ('900014', '900014_emergency_assembly.svg'),
      ('900015', '900015_restricted_zone.svg'),
      ('900016', '900016_volunteer_point.svg'),
      ('900017', '900017_free_wifi.svg'),
      ('900018', '900018_pilgrim_camp.svg'),
    ];

    test('every known rubric resolves to its glyph (no fallback)', () {
      for (final (id, expectedBasename) in knownRubrics) {
        final glyph = DynamicPoiIconResolver.resolve([id]);
        expect(glyph.rubricId, id, reason: 'rubric for $id');
        expect(glyph.assetPath.endsWith(expectedBasename), isTrue, reason: 'asset for $id → ${glyph.assetPath}');
        expect(glyph.packageName, 'mapness');
        expect(glyph.isFallback, isFalse, reason: 'fallback for $id');
      }
    });

    test('unknown rubric falls back to the Landmark glyph', () {
      final glyph = DynamicPoiIconResolver.resolve(['999999']);
      expect(glyph.rubricId, DynamicPoiIconResolver.fallbackRubricId);
      expect(glyph.assetPath.endsWith('900010_landmark.svg'), isTrue);
      expect(glyph.isFallback, isTrue);
    });

    test('empty rubric list falls back', () {
      final glyph = DynamicPoiIconResolver.resolve(const []);
      expect(glyph.isFallback, isTrue);
      expect(glyph.rubricId, DynamicPoiIconResolver.fallbackRubricId);
    });

    test('first matching rubric wins', () {
      final glyph = DynamicPoiIconResolver.resolve(['999999', '900001', '900002']);
      expect(glyph.rubricId, '900001');
      expect(glyph.isFallback, isFalse);
    });
  });
}
