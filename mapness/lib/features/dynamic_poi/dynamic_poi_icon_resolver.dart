/// Maps Momrah dynamic-POI rubric IDs to bundled SVG marker icons.
///
/// Per task spec, unknown rubric IDs fall back to the Landmark disc.
/// The 18 known dynamic-POI rubrics live under
/// `assets/icons/svg/dynamic_poi/`; the asset paths use the
/// `packages/mapness/...` prefix because mapness is a path dependency of
/// the host `balady_plus` app.
class DynamicPoiIconResolver {
  static const _packagePrefix = 'packages/mapness/assets/icons/svg';

  static const String _dynamicPoiDir = '$_packagePrefix/dynamic_poi';

  /// Default disc icon for rubrics we don't recognize. Iter5 switched this
  /// from the purple cityscape pin to the per-rubric Landmark disc so the
  /// dynamic-POI layer renders a consistent visual style across known and
  /// unknown rubrics.
  static const String defaultIcon = '$_dynamicPoiDir/rubric_900010_landmark.svg';

  /// Per-rubric icon table. Keys come from `properties.rubric_id` (a list of
  /// strings on each feature). The first matching entry wins; absence falls
  /// through to [defaultIcon].
  static const Map<String, String> _byRubricId = {
    '900001': '$_dynamicPoiDir/rubric_900001_medical_help.svg',
    '900002': '$_dynamicPoiDir/rubric_900002_lost_and_found.svg',
    '900003': '$_dynamicPoiDir/rubric_900003_hajj_support.svg',
    '900004': '$_dynamicPoiDir/rubric_900004_kiosk_and_pos.svg',
    '900005': '$_dynamicPoiDir/rubric_900005_additional_category.svg',
    '900006': '$_dynamicPoiDir/rubric_900006_stair.svg',
    '900007': '$_dynamicPoiDir/rubric_900007_service.svg',
    '900008': '$_dynamicPoiDir/rubric_900008_gate.svg',
    '900009': '$_dynamicPoiDir/rubric_900009_prayer_hall.svg',
    '900010': '$_dynamicPoiDir/rubric_900010_landmark.svg',
    '900011': '$_dynamicPoiDir/rubric_900011_luggage_storage.svg',
    '900012': '$_dynamicPoiDir/rubric_900012_wheelchairs_carts_center.svg',
    '900013': '$_dynamicPoiDir/rubric_900013_prayer_area_for_disabled.svg',
    '900014': '$_dynamicPoiDir/rubric_900014_emergency_assembly_point.svg',
    '900015': '$_dynamicPoiDir/rubric_900015_restricted_zone.svg',
    '900016': '$_dynamicPoiDir/rubric_900016_volunteer_point.svg',
    '900017': '$_dynamicPoiDir/rubric_900017_free_wifi_station.svg',
    '900018': '$_dynamicPoiDir/rubric_900018_pilgrim_camp.svg',
  };

  static String resolve(List<String> rubricIds) {
    for (final id in rubricIds) {
      final hit = _byRubricId[id];
      if (hit != null) {
        return hit;
      }
    }
    return defaultIcon;
  }

  /// Same as [resolve], but also reports which path was chosen — used by the
  /// layer to log fallback rate when assembling the marker set.
  static ({String icon, bool isFallback}) resolveWithFallbackInfo(List<String> rubricIds) {
    for (final id in rubricIds) {
      final hit = _byRubricId[id];
      if (hit != null) {
        return (icon: hit, isFallback: false);
      }
    }
    return (icon: defaultIcon, isFallback: true);
  }
}
