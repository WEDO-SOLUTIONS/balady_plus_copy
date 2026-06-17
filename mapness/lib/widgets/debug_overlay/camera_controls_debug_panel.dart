import 'dart:math' as math;

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/free_roam/camera_controls_overlay_provider.dart';
import 'package:mapness/features/free_roam/navigation_camera_settings_controller.dart';
import 'package:mapness/features/free_roam/simulation_speed_controller.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';
import 'package:mapness/widgets/debug_overlay/slider_speed.dart';

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
          const SizedBox(height: 8),
          const _GroupLabel('Side view — camera vs car'),
          const _CameraSideProjection(),
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
            const SizedBox(height: 6),
            const SpeedInputField(),
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
    // [DEBUG TEMP] Log the sim-speed → camera zoom/tilt response so the
    // speed→zoom→tilt chain can be verified against the VERBOSE SDK log. Fires on
    // each camera change while this readout is mounted (i.e. debug panel open).
    ref.listen(cameraPositionProvider, (_, pos) {
      if (pos == null) {
        return;
      }
      final kmh = ref.read(simulationSpeedProvider);
      debugPrint(
        '[CAM-TUNE] speed=${kmh.round()}km/h  zoom=${pos.zoom.toStringAsFixed(2)}  '
        'tilt=${pos.tilt.toStringAsFixed(1)}deg  bearing=${pos.bearing.round()}deg',
      );
    });
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

/// Live side-elevation schematic of the follow camera relative to the car.
/// Visualises **tilt** (angle of the camera boom off vertical) and **distance**
/// (derived from zoom — lower zoom pulls the camera back), plus a "road ahead"
/// marker that grows with tilt. Pure side projection, so bearing is ignored.
/// Reads the same [cameraPositionProvider] as the readout, so it tracks the
/// camera frame-by-frame during a navigation simulation.
class _CameraSideProjection extends ConsumerWidget {
  const _CameraSideProjection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pos = ref.watch(cameraPositionProvider);
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: DebugTheme.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DebugTheme.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(
        painter: _CameraProjectionPainter(
          tilt: pos?.tilt.toDouble() ?? 45,
          zoom: pos?.zoom.toDouble() ?? 17,
          hasData: pos != null,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _CameraProjectionPainter extends CustomPainter {
  _CameraProjectionPainter({required this.tilt, required this.zoom, required this.hasData});

  final double tilt;
  final double zoom;
  final bool hasData;

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final groundY = h - 28;
    final carX = w * 0.62;
    const leftPad = 22.0;
    const topPad = 18.0;

    final tiltC = tilt.clamp(0.0, 89.0);
    final tiltRad = tiltC * math.pi / 180.0;
    final zoomC = zoom.clamp(10.0, 22.0);
    // 0 at max zoom (close), 1 at min zoom (pulled back).
    final distT = ((22.0 - zoomC) / (22.0 - 10.0)).clamp(0.0, 1.0);

    // --- ground + perspective ticks ---
    final gridPaint = Paint()
      ..color = DebugTheme.border
      ..strokeWidth = 1;
    canvas.drawLine(Offset(8, groundY), Offset(w - 8, groundY), gridPaint);
    final tickPaint = Paint()
      ..color = DebugTheme.border.withOpacity(0.5)
      ..strokeWidth = 1;
    for (var x = 14.0; x < w - 8; x += 26) {
      canvas.drawLine(Offset(x, groundY), Offset(x + 8, groundY + 6), tickPaint);
    }

    // --- "road ahead" marker (grows with tilt) ---
    final aheadLen = _lerp(10, (w - carX) - 16, (tiltC / 70).clamp(0.0, 1.0));
    final aheadEnd = carX + aheadLen;
    final aheadPaint = Paint()
      ..color = DebugTheme.warning.withOpacity(0.85)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawLine(Offset(carX + 16, groundY - 2), Offset(aheadEnd, groundY - 2), aheadPaint)
      // arrowhead
      ..drawLine(Offset(aheadEnd, groundY - 2), Offset(aheadEnd - 5, groundY - 5), aheadPaint)
      ..drawLine(Offset(aheadEnd, groundY - 2), Offset(aheadEnd - 5, groundY + 1), aheadPaint);
    _text(
      canvas,
      'road ahead',
      Offset(carX + 18, groundY - 16),
      color: DebugTheme.warning.withOpacity(0.9),
      size: 8.5,
    );

    // --- camera position from tilt + distance, fitted to the box ---
    final maxByH = (groundY - topPad) / math.max(math.cos(tiltRad), 0.08);
    final maxByW = (carX - leftPad) / math.max(math.sin(tiltRad), 0.08);
    final fit = math.min(maxByH, maxByW);
    final boom = _lerp(0.5, 0.95, distT) * fit;
    final camX = carX - boom * math.sin(tiltRad);
    final camY = groundY - boom * math.cos(tiltRad);

    // --- vertical (top-down) reference from car ---
    final refPaint = Paint()
      ..color = DebugTheme.textMuted.withOpacity(0.6)
      ..strokeWidth = 1;
    _dashLine(canvas, Offset(carX, groundY), Offset(carX, groundY - fit * 0.95), refPaint);

    // --- tilt arc between vertical and boom ---
    final boomAngle = math.atan2(camY - groundY, camX - carX);
    const upAngle = -math.pi / 2;
    final arcPaint = Paint()
      ..color = DebugTheme.accentLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(carX, groundY), radius: 30),
      upAngle,
      boomAngle - upAngle,
      false,
      arcPaint,
    );
    final midAngle = upAngle + (boomAngle - upAngle) / 2;
    _text(
      canvas,
      '${tiltC.round()}°',
      Offset(carX + 36 * math.cos(midAngle) - 8, groundY + 36 * math.sin(midAngle) - 6),
      color: DebugTheme.accentLight,
      size: 11,
      weight: FontWeight.w700,
    );

    // --- boom (camera -> car) ---
    final boomPaint = Paint()
      ..color = DebugTheme.accent
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(camX, camY), Offset(carX, groundY), boomPaint);

    // --- car silhouette ---
    _drawCar(canvas, carX, groundY);

    // --- camera glyph (body + lens toward car) ---
    final camPaint = Paint()..color = DebugTheme.accentLight;
    final toCar = Offset(carX, groundY) - Offset(camX, camY);
    final u = toCar / toCar.distance;
    final perp = Offset(-u.dy, u.dx) * 4.5;
    final lensTip = Offset(camX, camY) + u * 12;
    canvas
      ..drawPath(
        Path()
          ..moveTo(camX + perp.dx, camY + perp.dy)
          ..lineTo(camX - perp.dx, camY - perp.dy)
          ..lineTo(lensTip.dx, lensTip.dy)
          ..close(),
        camPaint,
      )
      ..drawCircle(Offset(camX, camY), 6.5, camPaint);

    // --- readout labels ---
    if (!hasData) {
      _text(canvas, 'no camera (start navigation)', const Offset(10, 8), color: DebugTheme.textMuted, size: 9);
    }
    _text(
      canvas,
      'TILT ${tiltC.round()}°',
      const Offset(10, 8),
      color: hasData ? DebugTheme.textPrimary : DebugTheme.textMuted,
      weight: FontWeight.w700,
    );
    final zlabel = 'ZOOM ${zoomC.toStringAsFixed(1)}';
    final zw = _measure(zlabel, 10, FontWeight.w700);
    _text(
      canvas,
      zlabel,
      Offset(w - zw - 10, 8),
      color: hasData ? DebugTheme.textPrimary : DebugTheme.textMuted,
      weight: FontWeight.w700,
    );
  }

  void _drawCar(Canvas canvas, double cx, double groundY) {
    final paint = Paint()..color = DebugTheme.textSecondary;
    const bodyW = 30.0;
    const bodyH = 8.0;
    const cabinW = 16.0;
    const cabinH = 6.0;
    const wheelR = 3.0;
    canvas
      // body
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx, groundY - wheelR - bodyH / 2), width: bodyW, height: bodyH),
          const Radius.circular(2),
        ),
        paint,
      )
      // cabin (offset back = left, so the car "faces" right/forward)
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(cx - 3, groundY - wheelR - bodyH - cabinH / 2 + 1),
            width: cabinW,
            height: cabinH,
          ),
          const Radius.circular(2),
        ),
        paint,
      )
      // wheels
      ..drawCircle(Offset(cx - bodyW * 0.28, groundY - wheelR), wheelR, paint)
      ..drawCircle(Offset(cx + bodyW * 0.28, groundY - wheelR), wheelR, paint);
  }

  void _dashLine(Canvas c, Offset a, Offset b, Paint p, {double dash = 4, double gap = 3}) {
    final total = (b - a).distance;
    if (total <= 0) {
      return;
    }
    final dir = (b - a) / total;
    var d = 0.0;
    while (d < total) {
      final s = a + dir * d;
      final e = a + dir * math.min(d + dash, total);
      c.drawLine(s, e, p);
      d += dash + gap;
    }
  }

  double _measure(String s, double size, FontWeight weight) {
    final tp = TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(fontSize: size, fontWeight: weight),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return tp.width;
  }

  void _text(
    Canvas c,
    String s,
    Offset at, {
    required Color color,
    double size = 10,
    FontWeight weight = FontWeight.w500,
  }) {
    TextPainter(
        text: TextSpan(
          text: s,
          style: TextStyle(color: color, fontSize: size, fontWeight: weight),
        ),
        textDirection: TextDirection.ltr,
      )
      ..layout()
      ..paint(c, at);
  }

  @override
  bool shouldRepaint(covariant _CameraProjectionPainter old) =>
      old.tilt != tilt || old.zoom != zoom || old.hasData != hasData;
}
