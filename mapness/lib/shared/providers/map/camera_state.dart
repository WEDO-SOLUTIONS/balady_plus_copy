import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_state.g.dart';

@riverpod
class _CameraState extends _$CameraState {
  @override
  CameraState? build() {
    final dgisController = ref.watch(dgisControllerProvider);
    final cameraStateSubscription = dgisController.value!.cameraStateEvents.listen(_cameraStateListener);
    ref.onDispose(
      cameraStateSubscription.cancel,
    );

    return CameraState.free;
  }

  void _cameraStateListener(CameraStateEvent event) {
    state = event.state;
  }
}

final cameraStateProvider = _cameraStateProvider;
