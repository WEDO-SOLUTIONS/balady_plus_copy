import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';
import 'package:mapness/shared/lib/search/rubric_marker_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'rubric_marker_type_mapper.g.dart';

@Riverpod(keepAlive: true)
class RubricMarkerMapper extends _$RubricMarkerMapper {
  @override
  List<RubricMarkerInfo> build() {
    final remoteConfig = FirebaseRemoteConfig.instance;

    final markerTypeValue = remoteConfig.getValue('map_marker_types').asString();
    final List<dynamic> decoded = jsonDecode(markerTypeValue);

    return decoded.map((e) => RubricMarkerInfo.fromJson(e)).toList();
  }

  MapMarkersType? getMarkerType(Set<int> rubricIds) {
    if (stateOrNull == null || rubricIds.isEmpty) {
      return null;
    }

    final relevantMap = <MapMarkersType, Set<int>>{};

    for (final markerInfo in state) {
      relevantMap[markerInfo.type] = markerInfo.rubricIds.intersection(rubricIds);
    }

    final mostRelevantType = relevantMap.entries
        .reduce(
          (prev, curr) => prev.value.length > curr.value.length ? prev : curr,
        )
        .key;

    return mostRelevantType;
  }
}
