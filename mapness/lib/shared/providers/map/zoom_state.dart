import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'zoom_state.g.dart';

class Zoom {
  Zoom({
    required this.zoomInEnabled,
    required this.zoomOutEnabled,
  });
  final bool zoomInEnabled;
  final bool zoomOutEnabled;

  Zoom copyWith({
    bool? zoomInEnabled,
    bool? zoomOutEnabled,
  }) =>
      Zoom(
        zoomInEnabled: zoomInEnabled ?? this.zoomInEnabled,
        zoomOutEnabled: zoomOutEnabled ?? this.zoomOutEnabled,
      );
}

@riverpod
class ZoomState extends _$ZoomState {
  @override
  Zoom build() {
    final dgisController = ref.watch(dgisControllerProvider);
    final zoomSubscription = dgisController.value?.zoomControlEnabledEvents.listen(_zoomListener);

    ref.onDispose(
      () {
        zoomSubscription?.cancel();
      },
    );

    return Zoom(
      zoomInEnabled: true,
      zoomOutEnabled: true,
    );
  }

  void _zoomListener(ZoomControlEnabledEvent event) {
    if (event.button == ZoomControlType.zoomIn) {
      state = state.copyWith(zoomInEnabled: event.isEnabled);
    } else {
      state = state.copyWith(zoomOutEnabled: event.isEnabled);
    }
  }

  void onTapUp(ZoomControlType type) {
    ref.read(dgisControllerProvider).value?.naviZoomController.onTapUp(type);
  }

  void onTapDown(ZoomControlType type) {
    ref.read(dgisControllerProvider).value?.naviZoomController.onTapDown(type);
  }
}
