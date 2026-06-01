import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_controls_overlay_provider.g.dart';

/// Whether the BE-193 navigation-camera tuning controls are mirrored as a
/// translucent overlay on top of the main screen. Toggled from the debug sheet;
/// consumed by `CameraControlsOverlay`.
@Riverpod(keepAlive: true)
class CameraControlsOverlayVisible extends _$CameraControlsOverlayVisible {
  @override
  bool build() => false;

  void toggle() => state = !state;

  void hide() => state = false;
}
