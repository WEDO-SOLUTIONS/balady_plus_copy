/// Navigation cursor (BALADY-3772): the 3D car model shown in place of the
/// my-location marker during turn-by-turn navigation.
///
/// The meshes ship inside the bundled 2GIS style archive
/// (`MapnessConstants.mapStylesPath`); `NavigationCursorController` reads
/// them out of the bundle and feeds `setNavigationCursorModel`, which is
/// backed by the SDK's `MyLocationMapObject.setModelData` — no style reload
/// and no MapView recreate, so applying the model never disturbs the live
/// map (the white-flash regression this ticket is about).
library;

/// Archive-internal paths of the bundled classic car meshes inside the 2GIS
/// style archive: index 0 = day, index 1 = night (they are different meshes).
/// The style itself binds the same files by exact filename and the SDK draws
/// them ONLY during turn-by-turn car navigation (the static dashboard marker
/// is a separate FOOT_GPS model, intentionally left untouched).
const kNavigationCursorCarModelPaths = <String>[
  'zmap/vidoc/models/day_LIGHT_THEME_CAR_MODEL.glb',
  'zmap/vidoc/models/night_DARK_THEME_CAR_MODEL.glb',
];
