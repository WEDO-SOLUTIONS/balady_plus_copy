import 'package:dgis_map/library.dart';
import 'package:mapness/features/map/providers/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_zoom.g.dart';

class ZoomState {
  final bool zoomInEnabled;
  final bool zoomOutEnabled;

  ZoomState({
    required this.zoomInEnabled,
    required this.zoomOutEnabled,
  });

  ZoomState copyWith({
    bool? zoomInEnabled,
    bool? zoomOutEnabled,
  }) =>
      ZoomState(
        zoomInEnabled: zoomInEnabled ?? this.zoomInEnabled,
        zoomOutEnabled: zoomOutEnabled ?? this.zoomOutEnabled,
      );
}

@riverpod
class MapZoom extends _$MapZoom {
  @override
  ZoomState build() {
    final dgisController = ref.watch(dgisControllerProvider);
    final zoomSubscription =
        dgisController?.zoomControlEnabledEvents.listen(_zoomListener);

    ref.onDispose(
      () {
        zoomSubscription?.cancel();
      },
    );

    return ZoomState(
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
    ref.watch(dgisControllerProvider)?.naviZoomController.onTapUp(type);
  }

  void onTapDown(ZoomControlType type) {
    print(type);
    ref.watch(dgisControllerProvider)?.naviZoomController.onTapDown(type);
  }
}
