import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/free_roam/camera_controls_overlay_provider.dart';
import 'package:mapness/features/free_roam/navigation_camera_settings_controller.dart';
import 'package:mapness/features/free_roam/simulation_speed_controller.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

/// Live tuning of the 2GIS navigation-camera controls (tilt-by-zoom, zoom-by-speed,
/// follow toggles, zoom restriction, follow-return delay, maneuver zone). Changes
/// are pushed to the native side immediately, so this can be used during a
/// navigation simulation to benchmark behavior against the 2GIS app (BE-193).
class CameraControlsDebugPanel extends ConsumerWidget {
  const CameraControlsDebugPanel({super.key, this.inOverlay = false});

  /// When true the panel is rendered inside the on-map translucent overlay; it
  /// then hides the "Show on map" toggle (the overlay has its own close button).
  final bool inOverlay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(navigationCameraSettingsControllerProvider);
    final controller = ref.read(navigationCameraSettingsControllerProvider.notifier);

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DebugSectionHeader(
            icon: Icons.videocam_rounded,
            title: 'Navigation Camera',
            subtitle: 'Tilt, zoom & follow tuning',
            gradient: DebugTheme.gradientTeal,
            trailing: DebugOutlinedButton(
              label: 'Reset',
              icon: Icons.refresh_rounded,
              isCompact: true,
              onPressed: controller.reset,
            ),
          ),
          const SizedBox(height: 8),
          const _LiveReadout(),
          const SizedBox(height: 10),

          if (!inOverlay) ...[
            DebugToggleRow(
              title: 'Show on map',
              subtitle: 'Translucent overlay while driving',
              gradient: DebugTheme.gradientTeal,
              value: ref.watch(cameraControlsOverlayVisibleProvider),
              onChanged: (_) => ref.read(cameraControlsOverlayVisibleProvider.notifier).toggle(),
            ),
            const DebugDivider(),
          ],

          // In the on-map HUD there is no separate SliderSpeed card, so surface the
          // simulation-speed control here (shared provider keeps it in sync).
          if (inOverlay) ...[
            const _GroupLabel('Simulation speed'),
            _SliderRow(
              label: 'Speed km/h',
              value: ref.watch(simulationSpeedProvider),
              min: 5,
              max: 230,
              divisions: 45,
              valueLabel: '${ref.watch(simulationSpeedProvider).round()}',
              onChanged: (v) => ref.read(simulationSpeedProvider.notifier).setKmh(v),
            ),
            const DebugDivider(),
          ],

          const _GroupLabel('Follow behaviour'),
          DebugToggleRow(
            title: 'Follow bearing',
            subtitle: 'Rotate map with heading',
            gradient: DebugTheme.gradientTeal,
            value: state.followBearing,
            onChanged: controller.setFollowBearing,
          ),
          DebugToggleRow(
            title: 'Follow zoom',
            subtitle: 'Auto zoom by speed',
            gradient: DebugTheme.gradientTeal,
            value: state.followStyleZoom,
            onChanged: controller.setFollowStyleZoom,
          ),
          DebugToggleRow(
            title: 'Follow tilt',
            subtitle: 'Auto pitch by zoom',
            gradient: DebugTheme.gradientTeal,
            value: state.followTilt,
            onChanged: controller.setFollowTilt,
          ),

          const DebugDivider(),
          const _GroupLabel('Tilt by zoom (°)'),
          const _Caption('0° = top-down · higher = horizon (more road ahead)'),
          for (var i = 0; i < state.tiltRelation.length; i++)
            _SliderRow(
              label: 'zoom ${state.tiltRelation[i].styleZoom.toStringAsFixed(0)}',
              value: state.tiltRelation[i].tiltDegrees,
              min: 0,
              max: 70,
              divisions: 70,
              valueLabel: '${state.tiltRelation[i].tiltDegrees.toStringAsFixed(0)}°',
              onChanged: (v) => controller.setTiltAt(i, v),
            ),

          const DebugDivider(),
          const _GroupLabel('Cruise zoom by speed'),
          for (var band = 0; band * 2 + 1 < state.speedZoomRules.length; band++)
            _buildBandSlider(state, controller, band),

          const DebugDivider(),
          const _GroupLabel('Zoom restriction'),
          DebugToggleRow(
            title: 'Restrict zoom range',
            gradient: DebugTheme.gradientTeal,
            value: state.zoomRestrictionEnabled,
            onChanged: controller.setZoomRestrictionEnabled,
          ),
          if (state.zoomRestrictionEnabled) ...[
            _SliderRow(
              label: 'Min zoom',
              value: state.minZoom,
              min: 2,
              max: 20,
              divisions: 36,
              valueLabel: state.minZoom.toStringAsFixed(1),
              onChanged: controller.setMinZoom,
            ),
            _SliderRow(
              label: 'Max zoom',
              value: state.maxZoom,
              min: 2,
              max: 20,
              divisions: 36,
              valueLabel: state.maxZoom.toStringAsFixed(1),
              onChanged: controller.setMaxZoom,
            ),
          ],

          const DebugDivider(),
          const _GroupLabel('Timing & maneuver'),
          _SliderRow(
            label: 'Follow return',
            value: state.followReturnDelaySeconds.toDouble(),
            min: 0,
            max: 30,
            divisions: 30,
            valueLabel: '${state.followReturnDelaySeconds}s',
            onChanged: (v) => controller.setFollowReturnDelaySeconds(v.round()),
          ),
          _SliderRow(
            label: 'Maneuver zone',
            value: state.distanceGapToManeuverMm / 1000,
            min: 0,
            max: 1000,
            divisions: 100,
            valueLabel: '${(state.distanceGapToManeuverMm / 1000).toStringAsFixed(0)} m',
            onChanged: (v) => controller.setDistanceGapToManeuverMm(v * 1000),
          ),
        ],
      ),
    );
  }

  Widget _buildBandSlider(
    CameraTuneState state,
    NavigationCameraSettingsController controller,
    int band,
  ) {
    final cruiseRule = state.speedZoomRules[band * 2 + 1];
    final minKmh = (cruiseRule.minSpeed * 3.6).round();
    final maxKmh = (cruiseRule.maxSpeed * 3.6).round();
    return _SliderRow(
      label: '$minKmh–$maxKmh km/h',
      value: cruiseRule.styleZoom,
      min: 10,
      max: 22,
      divisions: 24,
      valueLabel: cruiseRule.styleZoom.toStringAsFixed(1),
      onChanged: (v) => controller.setBandZoom(band, v),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 4, bottom: 2),
    child: Text(
      text.toUpperCase(),
      style: context.textStyles.captionSmallMedium.copyWith(
        color: DebugTheme.textMuted,
        letterSpacing: 0.5,
      ),
    ),
  );
}

/// Small muted hint line (scale legend / live readout).
class _Caption extends StatelessWidget {
  const _Caption(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      text,
      style: context.textStyles.captionSmallRegular.copyWith(
        color: DebugTheme.textMuted,
        fontSize: 10,
      ),
    ),
  );
}

/// Prominent live readout of the current camera zoom/tilt/bearing. Watches
/// [cameraPositionProvider] in isolation so the rest of the panel is not rebuilt
/// on every camera frame during navigation. Shows "—" until a position arrives.
///
/// Note: `zoom` here is the camera Zoom reported by the SDK, which is close to
/// but not identical to the StyleZoom used by the tilt/zoom sliders below.
class _LiveReadout extends ConsumerWidget {
  const _LiveReadout();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pos = ref.watch(cameraPositionProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: DebugTheme.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DebugTheme.border),
      ),
      child: Row(
        children: [
          _stat(context, 'ZOOM', pos?.zoom.toStringAsFixed(1) ?? '—'),
          _stat(context, 'TILT', pos != null ? '${pos.tilt.round()}°' : '—'),
          _stat(context, 'BEARING', pos != null ? '${pos.bearing.round()}°' : '—'),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String label, String value) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textStyles.captionSmallRegular.copyWith(
            color: DebugTheme.textMuted,
            fontSize: 9,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: context.textStyles.bodySmallSemiBold.copyWith(color: DebugTheme.textPrimary),
        ),
      ],
    ),
  );
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.valueLabel,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String valueLabel;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(
        width: 88,
        child: Text(
          label,
          style: context.textStyles.captionSmallRegular.copyWith(color: DebugTheme.textSecondary),
        ),
      ),
      Expanded(
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2,
            activeTrackColor: DebugTheme.accent,
            inactiveTrackColor: DebugTheme.surfaceLight,
            thumbColor: DebugTheme.accentLight,
            overlayColor: DebugTheme.accent.withOpacity(0.2),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ),
      SizedBox(
        width: 44,
        child: Text(
          valueLabel,
          textAlign: TextAlign.end,
          style: context.textStyles.captionSmallMedium.copyWith(color: DebugTheme.textPrimary),
        ),
      ),
    ],
  );
}
