import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'satellite_debug.g.dart';

/// Dev-only stand-in JSON used by [SatelliteMapController] when
/// [SatelliteDebugOverride] is on. ESRI World Imagery — public, token-less,
/// reachable from any network. Lets QA/devs exercise the satellite layer
/// without depending on Saudi Geoportal connectivity (and without crashing
/// the DGis iOS render thread on an HTML rejection response).
///
/// ESRI ToS restricts commercial use, so this URL must NEVER ship to prod —
/// it's only reachable through the debug panel switch.
const String kSatelliteDebugOverrideConfig =
    '{"layer_name":"satellite",'
    '"url_template":"https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",'
    '"token":"",'
    '"expires":0}';

/// Debug-panel toggle: when enabled, the satellite controller ignores the
/// Firebase Remote Config snapshot for `satellite_config` and uses the
/// bundled ESRI World Imagery stand-in. Resets to off on each app launch
/// (no persistence — keepAlive only survives the session).
@Riverpod(keepAlive: true)
class SatelliteDebugOverride extends _$SatelliteDebugOverride {
  @override
  bool build() => false;

  void toggle() => state = !state;

  void enable() => state = true;

  void disable() => state = false;
}
