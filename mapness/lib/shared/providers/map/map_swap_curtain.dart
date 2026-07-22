import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
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
/// surface-colored cover. Shown synchronously by
/// [DynamicStyleController.applyOverrides] / [resetToBundled] right before
/// the recreate protocol starts; hidden when the fresh map restores the
/// stashed camera ([PendingCameraSnapshot] transitions to null), with a
/// failsafe timeout in case the restore never runs.
final mapSwapCurtainProvider = NotifierProvider<MapSwapCurtain, MapSwapCurtainState>(MapSwapCurtain.new);

@immutable
class MapSwapCurtainState {
  const MapSwapCurtainState({required this.visible, this.image});

  static const hidden = MapSwapCurtainState(visible: false);

  final bool visible;

  /// PNG bytes of the map frame captured just before the teardown; null when
  /// the snapshot failed and the curtain should be a plain color.
  final Uint8List? image;
}

class MapSwapCurtain extends Notifier<MapSwapCurtainState> {
  Timer? _failsafe;

  static const _failsafeTimeout = Duration(seconds: 6);

  @override
  MapSwapCurtainState build() {
    ref
      ..listen<CameraPositionMessage?>(pendingCameraSnapshotProvider, (previous, next) {
        if (state.visible && previous != null && next == null) {
          hide();
        }
      })
      ..onDispose(() => _failsafe?.cancel());
    return MapSwapCurtainState.hidden;
  }

  void show({Uint8List? image}) {
    _failsafe?.cancel();
    _failsafe = Timer(_failsafeTimeout, () {
      logger.log('$_logTag failsafe timeout — hiding without camera-restore signal');
      hide();
    });
    state = MapSwapCurtainState(visible: true, image: image);
    logger.log('$_logTag shown (snapshot: ${image != null ? '${image.length} bytes' : 'none'})');
  }

  void hide() {
    _failsafe?.cancel();
    _failsafe = null;
    if (state.visible) {
      // Keep the image so the fade-out animation still draws it while the
      // opacity goes to zero; the next show() replaces it anyway.
      state = MapSwapCurtainState(visible: false, image: state.image);
      logger.log('$_logTag hidden');
    }
  }
}
