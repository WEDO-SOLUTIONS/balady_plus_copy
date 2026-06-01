// Boolean setters are intentionally positional so they can be passed directly as
// ValueChanged<bool> callbacks (e.g. DebugToggleRow.onChanged) from the debug panel.
// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/shared/constants/navigation_constants.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_camera_settings_controller.g.dart';

/// Immutable, app-side view of the navigation-camera controls. Mirrors the
/// fields of [NavigationCameraSettings] but in a mutable-friendly shape so the
/// debug panel can tweak individual values; [toMessage] rebuilds the pigeon
/// payload sent to the native side.
class CameraTuneState {
  const CameraTuneState({
    required this.speedZoomRules,
    required this.tiltRelation,
    required this.followBearing,
    required this.followStyleZoom,
    required this.followTilt,
    required this.zoomRestrictionEnabled,
    required this.minZoom,
    required this.maxZoom,
    required this.followReturnDelaySeconds,
    required this.styleZoomSpeedRangesAnimationMs,
    required this.zoomInBeforeManeuverAnimationMs,
    required this.zoomOutAfterManeuverAnimationMs,
    required this.distanceGapToManeuverMm,
  });

  /// Seeds the state from the canonical defaults in [NavigationConstants].
  factory CameraTuneState.initial() {
    final defaults = NavigationConstants.defaultNavigationCameraSettings;
    final behaviour = defaults.followBehaviour;
    final tuning = defaults.zoomTuning;
    return CameraTuneState(
      speedZoomRules: defaults.speedZoomRules ?? const [],
      tiltRelation: defaults.tiltRelation ?? const [],
      followBearing: behaviour?.followBearing ?? true,
      followStyleZoom: behaviour?.followStyleZoom ?? true,
      followTilt: behaviour?.followTilt ?? true,
      zoomRestrictionEnabled: defaults.minZoom != null || defaults.maxZoom != null,
      minZoom: defaults.minZoom ?? 5,
      maxZoom: defaults.maxZoom ?? 19,
      followReturnDelaySeconds: defaults.followReturnDelaySeconds ?? 15,
      styleZoomSpeedRangesAnimationMs: tuning?.styleZoomSpeedRangesAnimationMs ?? 500,
      zoomInBeforeManeuverAnimationMs: tuning?.zoomInBeforeManeuverAnimationMs ?? 700,
      zoomOutAfterManeuverAnimationMs: tuning?.zoomOutAfterManeuverAnimationMs ?? 700,
      distanceGapToManeuverMm: tuning?.distanceGapToManeuverMm ?? 500000,
    );
  }

  final List<SpeedZoomRule> speedZoomRules;
  final List<StyleZoomTiltPoint> tiltRelation;
  final bool followBearing;
  final bool followStyleZoom;
  final bool followTilt;
  final bool zoomRestrictionEnabled;
  final double minZoom;
  final double maxZoom;
  final int followReturnDelaySeconds;
  final int styleZoomSpeedRangesAnimationMs;
  final int zoomInBeforeManeuverAnimationMs;
  final int zoomOutAfterManeuverAnimationMs;
  final double distanceGapToManeuverMm;

  CameraTuneState copyWith({
    List<SpeedZoomRule>? speedZoomRules,
    List<StyleZoomTiltPoint>? tiltRelation,
    bool? followBearing,
    bool? followStyleZoom,
    bool? followTilt,
    bool? zoomRestrictionEnabled,
    double? minZoom,
    double? maxZoom,
    int? followReturnDelaySeconds,
    int? styleZoomSpeedRangesAnimationMs,
    int? zoomInBeforeManeuverAnimationMs,
    int? zoomOutAfterManeuverAnimationMs,
    double? distanceGapToManeuverMm,
  }) => CameraTuneState(
    speedZoomRules: speedZoomRules ?? this.speedZoomRules,
    tiltRelation: tiltRelation ?? this.tiltRelation,
    followBearing: followBearing ?? this.followBearing,
    followStyleZoom: followStyleZoom ?? this.followStyleZoom,
    followTilt: followTilt ?? this.followTilt,
    zoomRestrictionEnabled: zoomRestrictionEnabled ?? this.zoomRestrictionEnabled,
    minZoom: minZoom ?? this.minZoom,
    maxZoom: maxZoom ?? this.maxZoom,
    followReturnDelaySeconds: followReturnDelaySeconds ?? this.followReturnDelaySeconds,
    styleZoomSpeedRangesAnimationMs: styleZoomSpeedRangesAnimationMs ?? this.styleZoomSpeedRangesAnimationMs,
    zoomInBeforeManeuverAnimationMs: zoomInBeforeManeuverAnimationMs ?? this.zoomInBeforeManeuverAnimationMs,
    zoomOutAfterManeuverAnimationMs: zoomOutAfterManeuverAnimationMs ?? this.zoomOutAfterManeuverAnimationMs,
    distanceGapToManeuverMm: distanceGapToManeuverMm ?? this.distanceGapToManeuverMm,
  );

  /// Builds the pigeon payload sent to the native side.
  NavigationCameraSettings toMessage() => NavigationCameraSettings(
    speedZoomRules: speedZoomRules,
    freeRoamSpeedZoomRules: speedZoomRules,
    tiltRelation: tiltRelation,
    followBehaviour: CameraFollowBehaviourMessage(
      followBearing: followBearing,
      followStyleZoom: followStyleZoom,
      followTilt: followTilt,
    ),
    minZoom: zoomRestrictionEnabled ? minZoom : null,
    maxZoom: zoomRestrictionEnabled ? maxZoom : null,
    followReturnDelaySeconds: followReturnDelaySeconds,
    zoomTuning: ZoomFollowTuning(
      styleZoomSpeedRangesAnimationMs: styleZoomSpeedRangesAnimationMs,
      zoomInBeforeManeuverAnimationMs: zoomInBeforeManeuverAnimationMs,
      zoomOutAfterManeuverAnimationMs: zoomOutAfterManeuverAnimationMs,
      distanceGapToManeuverMm: distanceGapToManeuverMm,
    ),
  );
}

/// Holds the current navigation-camera settings and pushes them to the native
/// side. Navigation/free-roam start sites read [toMessage] from this provider so
/// any live tuning done in the debug panel survives a navigation restart within
/// the session.
@Riverpod(keepAlive: true)
class NavigationCameraSettingsController extends _$NavigationCameraSettingsController {
  @override
  CameraTuneState build() => CameraTuneState.initial();

  /// Pushes the current settings to the active map. Safe to call before or after
  /// navigation has started.
  Future<void> apply() async {
    final controller = await ref.read(dgisControllerProvider.future);
    await controller.setNavigationCameraSettings(state.toMessage());
  }

  void _update(CameraTuneState next) {
    state = next;
    unawaited(apply());
  }

  void setFollowBearing(bool value) => _update(state.copyWith(followBearing: value));

  void setFollowStyleZoom(bool value) => _update(state.copyWith(followStyleZoom: value));

  void setFollowTilt(bool value) => _update(state.copyWith(followTilt: value));

  void setZoomRestrictionEnabled(bool value) => _update(state.copyWith(zoomRestrictionEnabled: value));

  void setMinZoom(double value) => _update(state.copyWith(minZoom: value));

  void setMaxZoom(double value) => _update(state.copyWith(maxZoom: value));

  void setFollowReturnDelaySeconds(int value) => _update(state.copyWith(followReturnDelaySeconds: value));

  void setDistanceGapToManeuverMm(double value) => _update(state.copyWith(distanceGapToManeuverMm: value));

  /// Replaces the tilt at the [index]-th control point, keeping its zoom anchor.
  void setTiltAt(int index, double tiltDegrees) {
    if (index < 0 || index >= state.tiltRelation.length) {
      return;
    }
    final updated = [...state.tiltRelation];
    updated[index] = StyleZoomTiltPoint(
      styleZoom: updated[index].styleZoom,
      tiltDegrees: tiltDegrees,
    );
    _update(state.copyWith(tiltRelation: updated));
  }

  /// Replaces the style zoom of both the "near" and "cruise" rules in the
  /// [bandIndex]-th speed band, preserving the +1 near-maneuver delta.
  void setBandZoom(int bandIndex, double cruiseZoom) {
    final nearIndex = bandIndex * 2;
    final farIndex = nearIndex + 1;
    if (farIndex >= state.speedZoomRules.length) {
      return;
    }
    final updated = [...state.speedZoomRules];
    final near = updated[nearIndex];
    final far = updated[farIndex];
    updated[nearIndex] = SpeedZoomRule(
      minSpeed: near.minSpeed,
      maxSpeed: near.maxSpeed,
      minDistanceToManeuverMm: near.minDistanceToManeuverMm,
      maxDistanceToManeuverMm: near.maxDistanceToManeuverMm,
      styleZoom: cruiseZoom + 1,
    );
    updated[farIndex] = SpeedZoomRule(
      minSpeed: far.minSpeed,
      maxSpeed: far.maxSpeed,
      minDistanceToManeuverMm: far.minDistanceToManeuverMm,
      maxDistanceToManeuverMm: far.maxDistanceToManeuverMm,
      styleZoom: cruiseZoom,
    );
    _update(state.copyWith(speedZoomRules: updated));
  }

  /// Restores the canonical defaults.
  void reset() => _update(CameraTuneState.initial());
}
