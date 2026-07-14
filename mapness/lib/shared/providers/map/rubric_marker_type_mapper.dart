import 'dart:async';
import 'dart:convert';

import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/entities/search/models/rubric_marker_info.dart';
import 'package:mapness/features/balady_analytics/balady_analytics.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/cityscape/cityscape.dart';
import 'package:mapness/features/founding_day/founding_day.dart';
import 'package:mapness/features/wrc/wrc.dart';
import 'package:mapness/shared/extensions/marker_icons_ext.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/utils/app_config_loader.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rubric_marker_type_mapper.g.dart';

/// Provider that maps rubric marker types from remote configuration.
///
/// This provider fetches the marker types from Firebase Remote Config and
/// decodes them into a list of [RubricMarkerInfo] objects
class RubricTypeMapper {
  static List<RubricMarkerInfo>? rubricMarkerInfo;

  /// Returns the most relevant marker type based on the provided set of rubric IDs.
  ///
  /// Works based on intersection of rubric IDs from config with the rubric form marker info.
  static Future<MapMarkersType?> getMarkerType(Set<int> rubricIds) async {
    if (rubricMarkerInfo == null) {
      try {
        final markerTypeValue = await AppConfigLoader.getMarkerType();
        if (markerTypeValue == null) {
          return null;
        }

        final List<dynamic> decoded = jsonDecode(markerTypeValue);

        rubricMarkerInfo = decoded.map((e) => RubricMarkerInfo.fromJson(e)).toList();
      } on Exception catch (e, stackTrace) {
        BaladyAnalytics.instance.error(e, stackTrace);
        return null;
      } on Object catch (_) {
        rethrow;
      }
    }

    if (rubricMarkerInfo == null || rubricIds.isEmpty) {
      return null;
    }

    final relevantMap = <MapMarkersType, Set<int>>{};

    for (final markerInfo in rubricMarkerInfo!) {
      final intersection = markerInfo.rubricIds.intersection(rubricIds);

      if (intersection.isNotEmpty) {
        relevantMap[markerInfo.type] = intersection;
      }
    }
    if (relevantMap.isEmpty) {
      return null;
    }

    final mostRelevantType = relevantMap.entries
        .reduce((prev, curr) => prev.value.length > curr.value.length ? prev : curr)
        .key;

    return mostRelevantType;
  }
}

@riverpod
class RubricMarkerMapper extends _$RubricMarkerMapper {
  @override
  void build() {}

  /// Returns the most relevant marker type based on the provided set of rubric IDs.
  ///
  /// Works based on intersection of rubric IDs from config with the rubric form marker info.
  Future<MapMarkersType?> getMarkerType(Set<int> rubricIds) => RubricTypeMapper.getMarkerType(rubricIds);

  /// Returns the most relevant marker type based on the provided set of rubric IDs.
  ///
  /// Replaces the default marker with custom marker
  Future<(String? smallIcon, String? bigIcon)> getMarkerPath(
    Set<int> rubricIds,
    int objectId, {
    GeoPointMessage? closestPoint,
  }) async {
    final cityscapeNotifier = ref.watch(cityscapeProvider.notifier);
    if (cityscapeNotifier.showCustomPin(objectId)) {
      return (cityscapeNotifier.customMarker, cityscapeNotifier.customPinPath);
    }
    final foundingDayNotifier = ref.watch(foundingDayUrbiProvider.notifier);
    if (foundingDayNotifier.isFoundationObject(objectId)) {
      return (foundingDayNotifier.customMarker, foundingDayNotifier.customMarker);
    }

    final wrcNotifier = ref.watch(wRCProvider.notifier);
    if (wrcNotifier.isWRCEventObject(objectId, closestPoint)) {
      return (wrcNotifier.getSearchMarkerPath(objectId), wrcNotifier.getPinPath(objectId));
    }

    final activeCityEvent = ref.read(activeCityEventProvider);
    final isDarkMode = ref.read(darkModeProvider).value?.isDark ?? false;

    final markerType = await getMarkerType(rubricIds);
    final iconPath = markerType?.pathBuilder(activeCityEvent, isDark: isDarkMode);
    final bigIconPath = markerType?.bigPathBuilder(activeCityEvent, isDark: isDarkMode);
    return (iconPath, bigIconPath);
  }
}
