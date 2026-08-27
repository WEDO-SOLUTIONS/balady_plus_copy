import 'package:dgis_map/library.dart';
import 'package:mapness/features/satellite/models/satellite_config.dart';
import 'package:mapness/features/satellite/providers/satellite_debug.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/app_config_loader.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'satellite_map_controller.g.dart';

/// Global map-style attribute name that hides immersive 3D buildings while
/// satellite imagery is on. Matches the literal used by the 2GIS style
/// editor filters (`["match", ["global", "dissappear3D"], [true], true,
/// false]`) — note the intentional double "s" in the spelling, the
/// contract is fixed on the style side and renaming would require a
/// style-editor update.
const String _kDisappear3DAttribute = 'dissappear3D';

// keepAlive: native SatelliteHandler holds the raster source for the whole
// session. If the provider auto-disposed when the layers sheet closes, the
// Dart bool would reset to false while the native layer stays visible — and
// on reopen the UI would show Default as selected even though the satellite
// tiles are still rendering on the map.
@Riverpod(keepAlive: true)
class SatelliteMapController extends _$SatelliteMapController {
  @override
  bool build() => false;

  Future<void> toggle() async {
    await _setEnabled(!state);
  }

  Future<void> enable() async {
    if (state) {
      return;
    }
    await _setEnabled(true);
  }

  Future<void> disable() async {
    if (!state) {
      return;
    }
    await _setEnabled(false);
  }

  Future<void> _setEnabled(bool enable) async {
    // Wait for the native map to be ready instead of silently dropping the
    // call when `dgisControllerProvider.value` is still null (the user can
    // tap Satellite before the map finishes its initial load). Same pattern
    // ParkingState uses for the `parkingOn` attribute.
    final controller = await ref.read(dgisControllerProvider.future);
    if (!ref.mounted) {
      return;
    }
    // BALADY-3742: flip the style-global `dissappear3D` flag so the 2GIS
    // style hides immersive 3D buildings while satellite imagery is on.
    // Done first (before adding the raster source on enable / before
    // removing it on disable) so the style finishes re-evaluating filters
    // in the same frame as the raster source change — no flicker of "3D
    // sticking out above the satellite tiles for one paint".
    await controller.setMapAttributeBool(_kDisappear3DAttribute, value: enable);
    if (!ref.mounted) {
      return;
    }
    if (enable) {
      // Debug-panel override: when a non-frc source is selected the
      // controller bypasses FRC and uses one of the bundled stand-ins
      // (staging satproxy / ESRI WMTS). See [SatelliteDebugSource] for
      // the menu of options and the rationale.
      ///TODO: temporary commented for build >>>>
      // final debugSource = ref.read(satelliteDebugOverrideProvider);
      // final debugRaw = satelliteDebugConfigFor(debugSource);
      // final String raw;
      // final String source;
      // if (debugRaw != null) {
      //   raw = debugRaw;
      //   source = 'debug:${debugSource.name}';
      // } else {
      //   final snapshot = await AppConfigLoader.getSatelliteConfigSnapshot();
      //   raw = snapshot.raw.isEmpty ? kSatelliteConfigBundledDefault : snapshot.raw;
      //   source = snapshot.source.name;
      // }
      // final config = SatelliteConfig.tryParse(raw);
      // if (config == null || !config.isUsable) {
      //   logger.log(
      //     'satellite: remote config missing or invalid — skipping enable',
      //     logLevel: MapnessLogLevel.warning,
      //   );
      //   return;
      // }
      // // TEMP debug — surface the resolved config so we can confirm whether
      // // FRC, the bundled default, or the debug override is in effect.
      // // Remove once FRC integration is confirmed working in prod.
      // logger.log(
      //   'satellite enable: source=$source length=${raw.length} payload=$raw',
      //   logLevel: MapnessLogLevel.info,
      // );
      // if (config.isExpired) {
      //   logger.log(
      //     'satellite: ESRI token expired at ${config.expiresAt?.toIso8601String()} — '
      //     'tiles will likely fail; rotate satellite_config in Firebase Remote Config',
      //     logLevel: MapnessLogLevel.warning,
      //   );
      // }
      //TODO: temporary commented for build <<<<
      await _applyToNative(
        enabled: true,
        // layerName: config.layerName,
        layerName: 'satellite',
        // tileUri: config.resolvedTileUri,
        tileUri: 'https://urbi-lifestyle-stg.momah.gov.sa/satproxy/tiles/{z}/{y}/{x}',
      );
    } else {
      await _applyToNative(enabled: false);
    }
  }

  Future<void> _applyToNative({
    required bool enabled,
    String layerName = '',
    String tileUri = '',
  }) async {
    final controller = await ref.read(dgisControllerProvider.future);
    if (!ref.mounted) {
      return;
    }
    final result = await controller.toggleSatellite(
      message: SatelliteMapMessage(
        layerName: layerName,
        rasterTileUri: tileUri,
        enabled: enabled,
      ),
    );
    if (!ref.mounted) {
      return;
    }
    state = result ?? enabled;
  }
}
