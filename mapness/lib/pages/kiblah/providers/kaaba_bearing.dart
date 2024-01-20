import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'kaaba_bearing.g.dart';

final GeoPointMessage kaabaLocation =
    GeoPointMessage(latitude: 21.422512, longitude: 39.82618);

@riverpod
class KaabaBearing extends _$KaabaBearing {
  @override
  double build() {
    final dgisController = ref.watch(dgisControllerProvider);
    ref.listen(
      locationProvider,
      (previous, next) async {
        if (next != null) {
          state = await dgisController.value!.pointBearing(next, kaabaLocation);
        }
      },
    );

    return 0;
  }
}
