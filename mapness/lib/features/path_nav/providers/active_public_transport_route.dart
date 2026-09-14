import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_public_transport_route.g.dart';

@riverpod
class ActivePublicTransportRoute extends _$ActivePublicTransportRoute {
  @override
  BriefPublicTransportModel? build() {
    detach(_subscribe(), tag: 'activePublicTransportRoute.subscribe');
    return null;
  }

  Future<void> _subscribe() async {
    final dgisController = await ref.read(dgisControllerProvider.future);

    final subscription = dgisController.publicTransportActiveRouteChangedEvents.listen((event) {
      state = event.route.brief;
    });

    ref.onDispose(() {
      subscription.cancel();
    });
  }
}
