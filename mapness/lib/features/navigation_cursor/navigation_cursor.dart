import 'package:flutter/widgets.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// Navigation cursor catalog: the discrete set of car models the user can
/// pick in Navigator settings → Cursors.
///
/// [classic] is the model shipped inside the bundled `styles.2gis`; the rest
/// live on the OCI Object Storage bucket `balady-plus-assets/cursors/` and
/// are downloaded on demand into the app's Application Support directory
/// via [CursorDownloader]. Applying a non-classic cursor reroutes through
/// [DynamicStyleController.applyOverrides] which repacks the archive at
/// runtime (see BE-184). Switching back to [classic] calls
/// [DynamicStyleController.resetToBundled].
///
/// The mapping GLB↔display name is a product decision — keep it here so
/// the picker UI, the persistence layer and the style-swap layer all read
/// from a single source of truth.
enum NavigationCursor {
  classic(
    id: 'classic',
    cdnFileName: null,
    thumbnailAsset: '$_thumbDir/thumb_classic.png',
  ),
  ceoRubberDucky(
    id: 'ceo_rubber_ducky',
    cdnFileName: 'ceo_rubber_ducky.glb',
    thumbnailAsset: '$_thumbDir/thumb_duck_default.png',
  ),
  theBoss(
    id: 'the_boss',
    cdnFileName: 'the_boss.glb',
    thumbnailAsset: '$_thumbDir/thumb_duck_boss.png',
  ),
  jetpack(
    id: 'jetpack',
    cdnFileName: 'jetpack.glb',
    thumbnailAsset: '$_thumbDir/thumb_duck_jetpack.png',
  ),
  jeep(
    id: 'jeep',
    cdnFileName: 'jeep.glb',
    thumbnailAsset: '$_thumbDir/thumb_car_jeep.png',
  ),
  jetsons(
    id: 'jetsons',
    cdnFileName: 'jetsons.glb',
    thumbnailAsset: '$_thumbDir/thumb_car_fly.png',
  ),
  sadu(
    id: 'sadu',
    cdnFileName: 'sadu.glb',
    thumbnailAsset: '$_thumbDir/thumb_car_sadu.png',
  ),
  saduBus(
    id: 'sadu_bus',
    cdnFileName: 'sadu_bus.glb',
    thumbnailAsset: '$_thumbDir/thumb_car_sadu_bus.png',
  );

  const NavigationCursor({
    required this.id,
    required this.cdnFileName,
    required this.thumbnailAsset,
  });

  /// Stable identifier used as the persisted key. Kebab-case, never renamed.
  final String id;

  /// Basename of the GLB on the OCI bucket, or null for [classic] (bundled).
  /// Full URL is derived via [kCursorCdnBaseUrl] at download time.
  final String? cdnFileName;

  /// PNG thumbnail shown as a leading icon in the picker rows.
  final String thumbnailAsset;

  /// True when the model must be downloaded before it can be applied.
  bool get requiresDownload => cdnFileName != null;

  /// Resolve a stored id back to the enum. Falls back to [classic] on
  /// unknown ids so a downgrade from a newer catalog can't strand the user.
  static NavigationCursor fromId(String? id) {
    if (id == null) {
      return NavigationCursor.classic;
    }
    for (final cursor in NavigationCursor.values) {
      if (cursor.id == id) {
        return cursor;
      }
    }
    return NavigationCursor.classic;
  }
}

const _thumbDir = 'assets/icons/cursors';

/// Read-only Pre-Authenticated Request that fronts the `cursors/` prefix on
/// the OCI bucket `balady-plus-assets` (region me-jeddah-1). Product
/// intentionally uses a read-only PAR here — the same URL string that ships
/// with every build. Expires 2027-07-06; rotate the token before then.
///
/// Full download URL is `$kCursorCdnBaseUrl<filename>.glb`.
const String kCursorCdnBaseUrl =
    'https://objectstorage.me-jeddah-1.oraclecloud.com/p/sviCqJVBbXeCelRlDyKxSlnW3xxqZ3eN73i9qlu-Id_yCHCOlyQ0qRzenirwNrJZ/n/axownvq9lhmx/b/balady-plus-assets/o/cursors/';

/// Archive-internal paths of the car model slots. `styles.zss` binds these by
/// exact filename and the SDK draws them ONLY during turn-by-turn car
/// navigation (the static dashboard marker is a separate FOOT_GPS model,
/// intentionally left untouched). Kept public so the controller can pass them
/// to `applyOverrides`.
const kNavigationCursorCarModelPaths = <String>[
  'zmap/vidoc/models/day_LIGHT_THEME_CAR_MODEL.glb',
  'zmap/vidoc/models/night_DARK_THEME_CAR_MODEL.glb',
];

extension NavigationCursorL10n on NavigationCursor {
  /// Localized display name from arb bundle (keys managed via Localazy).
  /// Kept next to the enum so any new cursor forces an update here —
  /// compile-time enum switch prevents missing translations.
  String title(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case NavigationCursor.classic:
        return l10n.cursorTitleClassicCursor;
      case NavigationCursor.ceoRubberDucky:
        return l10n.cursorTitleCEORubberDucky;
      case NavigationCursor.theBoss:
        return l10n.cursorTitleTheBoss;
      case NavigationCursor.jetpack:
        return l10n.cursorTitleJetpack;
      case NavigationCursor.jeep:
        return l10n.cursorTitleJeep;
      case NavigationCursor.jetsons:
        return l10n.cursorTitleJetsons;
      case NavigationCursor.sadu:
        return l10n.cursorTitleSadu;
      case NavigationCursor.saduBus:
        return l10n.cursorTitleSaduBus;
    }
  }
}
