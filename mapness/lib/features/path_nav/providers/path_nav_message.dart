import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/entities/path_nav/models/path_nav_message.dart';
import 'package:mapness/features/path_nav/lib/extensions.dart';
import 'package:mapness/shared/lib/urbi_metrics_utils.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'path_nav_message.g.dart';

@riverpod
class _PathNavMessage extends _$PathNavMessage {
  StreamSubscription<NaviMessageEvent>? subscription;

  @override
  PathNavMessage? build() {
    final mapController = ref.watch(dgisControllerProvider);

    /// Send lost GPS signal to analytics if the user lost GPS signal and close the app
    /// So here we will not have duration of lost GPS signal
    AdvancedMetrics.instance.sendLostGPS();

    subscription = mapController.value?.naviMessageController.events.listen((event) {
      if (event == NaviMessageEventState.gpsLost) {
        AdvancedMetrics.instance.addLostGPS();
      } else if (event == NaviMessageEventState.routeResearch) {
        // We will not send the event if gps signal was not lost
        // So we can send it without any additional checks
        AdvancedMetrics.instance.addRestoreGPS();
      }
      state = event.state.getNaviMessage();
    });

    ref.onDispose(() {
      subscription?.cancel();
    });

    return null;
  }

  void stopNavigation() {
    subscription?.cancel();
  }
}

final pathNavMessageProvider = _pathNavMessageProvider;
