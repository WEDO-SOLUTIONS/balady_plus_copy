import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:mapness/entities/search/models/rubric_marker_info.dart';
import 'package:mapness/shared/constants/remote_config_constants.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'rubric_marker_type_mapper.g.dart';

/// Provider that maps rubric marker types from remote configuration.
///
/// This provider fetches the marker types from Firebase Remote Config and
/// decodes them into a list of [RubricMarkerInfo] objects

@Riverpod(keepAlive: true)
class RubricMarkerMapper extends _$RubricMarkerMapper {
  @override
  List<RubricMarkerInfo> build() {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      final markerTypeValue = remoteConfig
          .getValue(RemoteConfigConstants.mapMarkerTypes)
          .asString();

      final List<dynamic> decoded = jsonDecode(markerTypeValue);

      return decoded.map((e) => RubricMarkerInfo.fromJson(e)).toList();
    } on Exception catch (_) {
      // TODO(ilyasov): log the exception to the crashlytics

      // if there is an Exception (CheckedFromJsonException e.g.), return an empty list
      return List<RubricMarkerInfo>.empty();
    } on Object catch (_) {
      rethrow;
    }
  }

  /// Returns the most relevant marker type based on the provided set of rubric IDs.
  ///
  /// Works based on intersection of rubric IDs from config with the rubric form marker info.
  MapMarkersType? getMarkerType(Set<int> rubricIds) {
    if (stateOrNull == null || rubricIds.isEmpty) {
      return null;
    }

    final relevantMap = <MapMarkersType, Set<int>>{};

    for (final markerInfo in state) {
      relevantMap[markerInfo.type] =
          markerInfo.rubricIds.intersection(rubricIds);
    }

    final mostRelevantType = relevantMap.entries
        .reduce(
          (prev, curr) => prev.value.length > curr.value.length ? prev : curr,
        )
        .key;

    return mostRelevantType;
  }
}
