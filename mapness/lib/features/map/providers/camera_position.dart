import 'package:dgis_map/library.dart';
import 'package:mapness/features/map/providers/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_position.g.dart';

@riverpod
class CameraPosition extends _$CameraPosition {
  @override
  CameraPositionMessage? build() {
    final dgisController = ref.watch(dgisControllerProvider);
    final cameraPositionSubscription =
        dgisController?.cameraPositionEvents.listen(_cameraPositionListener);
    ref.onDispose(
      () {
        cameraPositionSubscription?.cancel();
      },
    );

    return null;
  }

  Future<void> animateTo(CameraPositionMessage position) async {
    final dgisController = ref.watch(dgisControllerProvider);

    await dgisController?.moveCamera(
      position,
      1,
      CameraAnimationTypeMessage.linear,
    );
  }

  Future<void> setPadding(CameraSetPaddingMessage padding) async {
    final dgisController = ref.watch(dgisControllerProvider);

    await dgisController?.setCameraPadding(padding);
  }

  void _cameraPositionListener(CameraPositionMessage event) {
    state = event;
  }
}
