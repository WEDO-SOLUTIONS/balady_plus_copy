import 'package:flutter/foundation.dart';

/// One resolved glyph: the rubric id that matched (for cache keys / fallback
/// reporting), the SVG asset path inside the `mapness` package, and the
/// package name that owns the asset.
///
/// The asset is monochrome with `fill="currentColor"` — `DynamicPoiMarkerBitmap`
/// passes the desired tint via `SvgTheme(currentColor: ...)`.
@immutable
class DynamicPoiGlyph {
  const DynamicPoiGlyph({
    required this.rubricId,
    required this.assetPath,
    required this.packageName,
    required this.isFallback,
  });

  final String rubricId;
  final String assetPath;
  final String packageName;

  /// `true` when no rubric in the input list matched and we fell back to the
  /// Landmark glyph. Useful for telemetry / debug log "% unknown rubrics".
  final bool isFallback;
}

/// Maps Momrah dynamic-POI rubric IDs to bundled monochrome glyph SVGs.
///
/// The 18 known dynamic-POI rubrics live in `assets/icons/svg/dynamic_poi/glyphs/`
/// inside the `mapness` package. Unknown rubrics fall back to the Landmark
/// glyph (900010), preserving the visual style established in iter5.
class DynamicPoiIconResolver {
  const DynamicPoiIconResolver._();

  static const String packageName = 'mapness';
  static const String _glyphDir = 'assets/icons/svg/dynamic_poi/glyphs';

  /// Rubric used when none of the feature's `properties.rubric_id` entries
  /// is in [_assetByRubricId]. Keeps the legacy "Landmark disc" fallback.
  static const String fallbackRubricId = '900010';
  static const String _fallbackAsset = '$_glyphDir/900010_landmark.svg';

  /// Per-rubric glyph table. Filenames follow `<rubricId>_<slug>.svg`. Keep
  /// in sync with `mapness/assets/icons/svg/dynamic_poi/glyphs/`.
  static const Map<String, String> _assetByRubricId = {
    '900001': '$_glyphDir/900001_medical_help.svg',
    '900002': '$_glyphDir/900002_lost_and_found.svg',
    '900003': '$_glyphDir/900003_hajj_support.svg',
    '900004': '$_glyphDir/900004_kiosk_and_pos.svg',
    '900005': '$_glyphDir/900005_additional_category.svg',
    '900006': '$_glyphDir/900006_stair.svg',
    '900007': '$_glyphDir/900007_service.svg',
    '900008': '$_glyphDir/900008_gate.svg',
    '900009': '$_glyphDir/900009_prayer_hall.svg',
    '900010': _fallbackAsset,
    '900011': '$_glyphDir/900011_luggage_storage.svg',
    '900012': '$_glyphDir/900012_wheelchairs_carts.svg',
    '900013': '$_glyphDir/900013_prayer_area_disabled.svg',
    '900014': '$_glyphDir/900014_emergency_assembly.svg',
    '900015': '$_glyphDir/900015_restricted_zone.svg',
    '900016': '$_glyphDir/900016_volunteer_point.svg',
    '900017': '$_glyphDir/900017_free_wifi.svg',
    '900018': '$_glyphDir/900018_pilgrim_camp.svg',
  };

  /// Returns the first rubric in [rubricIds] for which a glyph is registered,
  /// or the Landmark fallback if none matched.
  static DynamicPoiGlyph resolve(List<String> rubricIds) {
    for (final id in rubricIds) {
      final asset = _assetByRubricId[id];
      if (asset != null) {
        return DynamicPoiGlyph(
          rubricId: id,
          assetPath: asset,
          packageName: packageName,
          isFallback: false,
        );
      }
    }
    return const DynamicPoiGlyph(
      rubricId: fallbackRubricId,
      assetPath: _fallbackAsset,
      packageName: packageName,
      isFallback: true,
    );
  }
}
