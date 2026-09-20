import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_public_transport_route.g.dart';

// keepAlive: this is the only source of truth for the metro panel shown in
// PathNavPage. It is driven purely by a native "changed" event that never
// replays its last value (see PublicTransportEventHandler), so if this
// provider were autoDispose it could get rebuilt with a `null` state while
// PathNavPage briefly loses its listener (e.g. across a device lock/unlock)
// and never recover until the native route genuinely changes again
// (BALADY-3790).
@Riverpod(keepAlive: true)
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
