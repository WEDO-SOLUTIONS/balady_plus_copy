import 'package:dgis_map/library.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dgis_controller.g.dart';

final GeoPointMessage kingdomTower =
    GeoPointMessage(latitude: 24.712301, longitude: 46.674175);

@riverpod
class DgisController extends _$DgisController {
  @override
  DgisMapController? build() => null;

  Future<void> onMapCreated(DgisMapController controller) async {
    await initialize(controller);
    state = controller;
  }

  Future<void> initialize(DgisMapController controller) async {
    await controller.initialize();

    await controller.loadStyles("assets/maps/styles/common-styles.2gis");
    await controller.overrideLocales(["ar-SA"]);
    await controller.onLocationPremissionGranted(
        desiredAccuracy: DesiredAccuracyMessage.high);

    await controller.setCameraPosition(
      CameraPositionMessage(
        point: kingdomTower,
        zoom: 17,
        tilt: 45,
        bearing: 0,
      ),
    );
  }
}
