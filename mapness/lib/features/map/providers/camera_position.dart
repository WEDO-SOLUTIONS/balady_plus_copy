import 'package:dgis_map/library.dart';
import 'package:mapness/features/map/providers/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_position.g.dart';

GeoRectMessage saRect = GeoRectMessage(
  northEast: GeoPointMessage(latitude: 32.568765, longitude: 56.694472),
  southWest: GeoPointMessage(latitude: 15.506104, longitude: 32.61185),
);

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

  void _cameraPositionListener(CameraPositionMessage event) async {
    state = event;
  }
}
