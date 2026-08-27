class MapnessConstants {
  static const showFavouritesOnMapKey = 'showFavouritesOnMap';
  static const mapLayerName = 'common-marker-layer';
  static const appStoreId = 'id1522185123';
  static const poiDataBoxName = 'poiDataBoxName';
  // v2 — bumped when swapping from mock to real backend so any
  // device with cached mock fixtures starts fresh on next launch.
  static const aiSummaryCacheBoxName = 'aiSummaryCacheBoxName_v2';
  static const navigatorStateKey = 'navigatorState';
  static const navigatorStateTypeKey = 'navigatorStateType';
  static const voiceInstructionIndexPrefsKey = 'voice_instruction_index';
  static const muffleOtherSoundsPrefsKey = 'muffle_other_sounds';
  static const promptsVolumeIndexPrefsKey = 'prompts_volume_index';
  static const backgroundNavigationPrefsKey = 'background_navigation';
  static const roadCamerasPrefsKey = 'road_cameras';
  static const overSpeedingPrefsKey = 'over_speeding';
  static const voicesLanguagePrefsKey = 'voices_language';
  static const camerasOn = 'camerasOn';
  static const analyticsTripStopped = 'tripStopped';
  static const analyticsSearchInThisAreaPressed = 'analyticsSearchInThisAreaPressed';
  static const parkingEnabledFreeRoam = 'parkingEnabledFreeRoam';
  static const activeNavigationCursorPrefsKey = 'activeNavigationCursor';

  ///config region
  static const envConfigBoxKey = 'envConfigKey_4.7.3';
  static const envTypeKey = 'envTypeKey';
  static const vendorConfigKey = 'vendorConfigKey';
  static const firebaseAppEnvConfigKey = 'app_env_config';

  ///styles region
  //uncomment for tests
  // static const mapStylesPath = 'assets/maps/configs/styles.2gis';
  static const mapStylesPath = 'packages/map_styles/src/styles.2gis';
  static const mapStylesSaudiPath = 'packages/map_styles/src/styles_saudi_day.2gis';
  static const mapStylesFoundingDayPath = 'assets/maps/configs/founding-day-styles2.2gis';

  ///fonts
  static const poiMapFontAr = 'IBMPlexSansArabic_Bold';
  static const poiMapFontEn = 'GolosText_SemiBold';
}
