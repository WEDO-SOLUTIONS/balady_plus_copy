abstract class RemoteConfigConstants {
  static const mapMarkerTypes = 'map_marker_types';
  static const thermalConfig = 'thermal_config';
  static const dynamicPoiVisibility = 'dynamic_poi_visibility';
  static const satelliteConfig = 'satellite_config';

  /// BALADY-3754: gates the Default/Satellite base-map tiles in the layers
  /// sheet. Off by default — the satellite tile source is not
  /// production-ready (Geoportal token/WAF); flip in Firebase Console when
  /// it is, no app release required.
  static const baseMapSwitcherEnabled = 'base_map_switcher_enabled';
}
