import 'dart:async';
import 'dart:ui' as ui;

import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:mapness/shared/providers/map/map_recreation.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod/riverpod.dart';

const _logTag = '[map_swap_curtain]';

/// BALADY-3772: curtain over the map while a style swap recreates the native
/// MapView. Without it the platform-view teardown flashes white for a few
/// frames before the fresh map cold-decodes the new archive.
///
/// When the native snapshot succeeded the curtain shows the last real map
/// frame ([MapSwapCurtainState.image]); otherwise it falls back to a plain
/// map-ground-colored cover. Raised by [DynamicStyleController.applyOverrides]
/// / [resetToBundled] right before the recreate protocol starts — [show]
/// completes only once the curtain has actually been rasterized, so the
/// teardown never happens behind a still-transparent overlay. Hidden when the
/// fresh map restores the stashed camera ([PendingCameraSnapshot] transitions
/// to null), with a failsafe timeout in case the restore never runs.
final mapSwapCurtainProvider = NotifierProvider<MapSwapCurtain, MapSwapCurtainState>(MapSwapCurtain.new);

@immutable
class MapSwapCurtainState {
  const MapSwapCurtainState({required this.visible, this.image});

  static const hidden = MapSwapCurtainState(visible: false);

  final bool visible;

  /// Already-decoded map frame captured just before the teardown; null when
  /// the snapshot failed and the curtain should be a plain color.
  ///
  /// Decoded up front rather than handed to `Image.memory`: async decoding
  /// left the overlay transparent on exactly the frame the old platform view
  /// disappeared, and that transparent frame *was* the white flash. Owned by
  /// [MapSwapCurtain] — widgets must clone it (`RawImage` does) and never
  /// dispose this handle.
  final ui.Image? image;
}

class MapSwapCurtain extends Notifier<MapSwapCurtainState> {
  Timer? _failsafe;
  Timer? _graceHide;
  Timer? _releaseImage;

  static const _failsafeTimeout = Duration(seconds: 6);

  /// The camera-restore signal fires right after the style loads, but the
  /// fresh MapView still needs to decode tiles/models before its first real
  /// frame — hiding immediately exposed a black Metal/GL surface for a few
  /// hundred ms (video: BALADY-3772, 10.18–10.38s). Keep the snapshot up a
  /// bit longer; the SDK has no public waitForRendering to key off instead.
  static const _hideGracePeriod = Duration(milliseconds: 800);

  /// Fade-out of the overlay once the fresh map is ready. Shared with the
  /// widget so the provider knows when the last frame that painted the image
  /// is gone and the [ui.Image] can be released.
  static const fadeOutDuration = Duration(milliseconds: 300);

  /// Upper bound for a single frame to come through in [show]. Frames stop
  /// while the app is backgrounded; the swap must not hang on that.
  static const _frameTimeout = Duration(milliseconds: 300);

  @override
  MapSwapCurtainState build() {
    ref
      ..listen<CameraPositionMessage?>(pendingCameraSnapshotProvider, (previous, next) {
        if (state.visible && previous != null && next == null) {
          _scheduleHide();
        }
      })
      ..onDispose(() {
        _failsafe?.cancel();
        _graceHide?.cancel();
        _releaseImage?.cancel();
        state.image?.dispose();
      });
    return MapSwapCurtainState.hidden;
  }

  /// Raises the curtain and completes once it is really on screen.
  ///
  /// The state change alone only *schedules* a rebuild; the caller is about
  /// to tear the platform view down, and doing that before the overlay has
  /// been rasterized is exactly the white flash this curtain exists to hide.
  /// Waits for two frames — the first builds and paints the overlay, the
  /// second guarantees the first has left the pipeline — bounded per frame so
  /// a paused engine (no frames at all) can't stall the style swap.
  Future<void> show({ui.Image? image}) async {
    _graceHide?.cancel();
    _graceHide = null;
    _releaseImage?.cancel();
    _releaseImage = null;
    _failsafe?.cancel();
    _failsafe = Timer(_failsafeTimeout, () {
      logger.log('$_logTag failsafe timeout — hiding without camera-restore signal');
      hide();
    });
    final previous = state.image;
    state = MapSwapCurtainState(visible: true, image: image);
    // Only after the state no longer references it (see [_dropImage]).
    if (previous != null && !identical(previous, image)) {
      previous.dispose();
    }
    logger.log('$_logTag shown (snapshot: ${image != null ? '${image.width}x${image.height}' : 'none'})');

    try {
      final binding = SchedulerBinding.instance;
      await binding.endOfFrame.timeout(_frameTimeout);
      await binding.endOfFrame.timeout(_frameTimeout);
    } on TimeoutException {
      logger.log('$_logTag no frame within timeout — proceeding with the swap anyway');
    }
  }

  void _scheduleHide() {
    _graceHide?.cancel();
    _graceHide = Timer(_hideGracePeriod, hide);
  }

  void hide() {
    _failsafe?.cancel();
    _failsafe = null;
    _graceHide?.cancel();
    _graceHide = null;
    if (state.visible) {
      // Keep the image so the fade-out animation still draws it while the
      // opacity goes to zero, then release it. It is deliberately NOT kept
      // for the next show(): reusing it made the *previous* swap's frame pop
      // up for a moment on the second cursor change.
      state = MapSwapCurtainState(visible: false, image: state.image);
      logger.log('$_logTag hidden');
      _releaseImage?.cancel();
      _releaseImage = Timer(fadeOutDuration + const Duration(milliseconds: 100), _dropImage);
    }
  }

  void _dropImage() {
    _releaseImage = null;
    final image = state.image;
    if (image == null) {
      return;
    }
    // Drop the reference first so no widget can clone a disposed handle.
    state = MapSwapCurtainState(visible: state.visible);
    image.dispose();
  }
}
