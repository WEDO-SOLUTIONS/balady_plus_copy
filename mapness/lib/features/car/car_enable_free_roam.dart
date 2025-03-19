import 'package:dgis_map/library.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/providers/car_connection.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'car_enable_free_roam.g.dart';

@Riverpod(keepAlive: true)

/// open free roam page when car is connected.
/// this make user pin look as car and show navigation instructions,
/// speed limit and etc in CarPlay and Android Auto
class CarEnableFreeRoam extends _$CarEnableFreeRoam {
  @override
  Future<void> build() async {
    final controller = await ref.watch(dgisControllerProvider.future);
    final carConnection = await ref.watch(carConnectionProvider.future);
    final router = ref.watch(appRouterProvider);

    // only run when car connects
    if (!carConnection) {
      return;
    }

    final navState = await controller.getCurrentNavigationState();
    final isFreeRoamPageActive = router.isRouteActive(FreeRoamRoute.name);

    // if already have nav state then dont break it
    if (navState.state == NavigationState.navigation || isFreeRoamPageActive) {
      return;
    }

    await router.push(const FreeRoamRoute());
  }
}
