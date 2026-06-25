import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'satellite_debug.g.dart';

/// Which satellite tile source the app uses. `frc` is the production path
/// (Firebase Remote Config); the others are dev/QA stand-ins exposed via
/// the debug panel.
enum SatelliteDebugSource {
  /// Production — `SatelliteMapController` reads `satellite_config` from
  /// Firebase Remote Config (with the bundled default as fallback).
  frc,

  /// Staging proxy at `urbi-lifestyle-stg`. Forwards to Saudi Geoportal
  /// from a KSA-network endpoint, so QA/devs outside KSA still see real
  /// tiles instead of the WAF rejection HTML that crashes the DGis iOS
  /// render thread.
  satproxy,

  /// ESRI ArcGIS WMTS — World_Imagery global imagery cache. JPEG tiles,
  /// public (no token), reachable from any network. Same content as the
  /// REST tile endpoint but in the OGC WMTS envelope, served as JPEG so
  /// payloads are 3–5× smaller than PNG. Not for prod — ESRI ToS limits
  /// commercial use.
  wmtsEsri,
}

/// JSON payload (same schema as Firebase Remote Config `satellite_config`)
/// used when [SatelliteDebugSource.satproxy] is selected.
const String kSatelliteDebugSatproxyConfig =
    '{"layer_name":"satellite",'
    '"url_template":"https://urbi-lifestyle-stg.momah.gov.sa/satproxy/tiles/{z}/{y}/{x}",'
    '"token":"",'
    '"expires":0}';

/// JSON payload used when [SatelliteDebugSource.wmtsEsri] is selected.
/// ESRI World_Imagery WMTS RESTful endpoint, `default028mm` TileMatrixSet
/// (256×256 JPEG). Switch back via the debug panel to compare image
/// quality and payload size against the satproxy path.
const String kSatelliteDebugWmtsConfig =
    '{"layer_name":"satellite",'
    '"url_template":"https://server.arcgisonline.com/arcgis/rest/services/World_Imagery/MapServer/WMTS/tile/1.0.0/World_Imagery/default/default028mm/{z}/{y}/{x}.jpg",'
    '"token":"",'
    '"expires":0}';

/// Returns the config JSON for the given debug source, or `null` for
/// [SatelliteDebugSource.frc] (the controller falls back to its FRC read
/// path when no override is active).
String? satelliteDebugConfigFor(SatelliteDebugSource source) => switch (source) {
  SatelliteDebugSource.frc => null,
  SatelliteDebugSource.satproxy => kSatelliteDebugSatproxyConfig,
  SatelliteDebugSource.wmtsEsri => kSatelliteDebugWmtsConfig,
};

/// Debug-panel selector for the satellite tile source. Resets to
/// [SatelliteDebugSource.frc] on each app launch (no persistence —
/// keepAlive only survives the session).
@Riverpod(keepAlive: true)
class SatelliteDebugOverride extends _$SatelliteDebugOverride {
  @override
  SatelliteDebugSource build() => SatelliteDebugSource.frc;

  // ignore: use_setters_to_change_properties
  void select(SatelliteDebugSource source) => state = source;
}
