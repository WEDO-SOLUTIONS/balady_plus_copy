import 'dart:convert';

import 'package:dgis_map/library.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/shared/extensions/directory_object_message_ext.dart';

/// Locks the Hive cache round-trip of [PoiCardState] (BALADY-3856).
///
/// The POI card caches its state as JSON and restores it on every provider
/// rebuild (e.g. after app resume). A restore that throws is swallowed as a
/// cache miss, forcing a network refetch — which after backgrounding on iOS
/// frequently fails and surfaces the "Something went wrong" sheet.
void main() {
  DirectoryObjectMessage buildMinimalObject() => DirectoryObjectMessage(
    types: [],
    title: 'LEAP mega POI',
    titleAddition: '',
    subtitle: '',
    about: '',
    id: DgisObjectIdMessage(objectId: 123456789, entranceId: 0),
    attributes: [],
    contextAttributes: [],
    contactInfos: [],
    entrances: [],
    buildingInfo: BuildingInfoMessage(),
    rubricIds: [],
    group: [],
    routeInfos: [],
    platformIds: [DgisObjectIdMessage(objectId: 987, entranceId: 0)],
  );

  group('PoiCardState cache round-trip', () {
    test('survives null organizations (LEAP mega POI has none)', () {
      final state = PoiCardState(
        showEntrances: false,
        isLoading: false,
        gisObjectIdMessage: buildMinimalObject(),
        organizations: null,
      );

      final restored = PoiCardState.fromJson(jsonDecode(jsonEncode(state.toJson())));

      expect(restored.organizations, isNull);
      expect(restored.gisObjectIdMessage, isNotNull);
      expect(restored.gisObjectIdMessage!.id!.objectId, 123456789);
      expect(restored.timestamp, isNotNull);
    });

    test('serializes and restores platformIds', () {
      final json = buildMinimalObject().toJson();

      expect(json['platformIds'], isNotEmpty);

      final restored = DirectoryObjectMessageExt.fromJson(jsonDecode(jsonEncode(json)));
      expect(restored.platformIds.single.objectId, 987);
    });

    test('tolerates cache entries written before platformIds existed', () {
      final legacyJson = buildMinimalObject().toJson()..remove('platformIds');

      final restored = DirectoryObjectMessageExt.fromJson(jsonDecode(jsonEncode(legacyJson)));

      expect(restored.platformIds, isEmpty);
    });

    test('fromJson does not throw when gisObjectIdMessage is null', () {
      final restored = PoiCardState.fromJson({
        'showEntrances': false,
        'gisObjectIdMessage': null,
        'organizations': null,
        'timestamp': 1,
      });

      expect(restored.gisObjectIdMessage, isNull);
      expect(restored.organizations, isNull);
    });
  });
}
