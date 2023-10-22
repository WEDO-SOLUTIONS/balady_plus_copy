import 'package:dgis_map/library.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dgis_controller.g.dart';

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
  }
}
