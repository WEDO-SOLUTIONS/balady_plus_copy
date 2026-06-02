import 'package:dgis_map/library.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/ai_summary/domain/ai_summary_scope.dart';

void main() {
  group('isAiSummaryAllowed', () {
    test('returns true for every type in the allow-list', () {
      const allowed = [
        ObjectTypeMessage.branch,
        ObjectTypeMessage.parking,
        ObjectTypeMessage.attraction,
        ObjectTypeMessage.gate,
        ObjectTypeMessage.station,
        ObjectTypeMessage.stationPlatform,
        ObjectTypeMessage.admDivPlace,
      ];
      for (final type in allowed) {
        expect(isAiSummaryAllowed([type]), isTrue, reason: 'type=$type');
      }
    });

    test('returns false for types outside the allow-list', () {
      const disallowed = [
        ObjectTypeMessage.admDiv,
        ObjectTypeMessage.admDivCity,
        ObjectTypeMessage.admDivCountry,
        ObjectTypeMessage.admDivDistrict,
        ObjectTypeMessage.admDivRegion,
        ObjectTypeMessage.admDivSettlement,
        ObjectTypeMessage.building,
        ObjectTypeMessage.coordinates,
        ObjectTypeMessage.crossroad,
        ObjectTypeMessage.kilometerRoadSign,
        ObjectTypeMessage.road,
        ObjectTypeMessage.route,
        ObjectTypeMessage.stationEntrance,
        ObjectTypeMessage.stationMetro,
        ObjectTypeMessage.street,
        ObjectTypeMessage.unknown,
      ];
      for (final type in disallowed) {
        expect(isAiSummaryAllowed([type]), isFalse, reason: 'type=$type');
      }
    });

    test('OR semantics — true if at least one type is allowed', () {
      expect(
        isAiSummaryAllowed([ObjectTypeMessage.building, ObjectTypeMessage.branch]),
        isTrue,
      );
      expect(
        isAiSummaryAllowed([ObjectTypeMessage.building, ObjectTypeMessage.road]),
        isFalse,
      );
    });

    test('empty list → false', () {
      expect(isAiSummaryAllowed(const []), isFalse);
    });
  });
}
