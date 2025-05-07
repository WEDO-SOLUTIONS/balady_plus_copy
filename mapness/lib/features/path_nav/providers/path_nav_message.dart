import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/entities/path_nav/models/path_nav_message.dart';
import 'package:mapness/features/path_nav/lib/extensions.dart';
import 'package:mapness/shared/lib/urbi_metrics_utils.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'path_nav_message.g.dart';

@Riverpod(keepAlive: true)
class _PathNavMessage extends _$PathNavMessage {
  StreamSubscription<NaviMessageEvent>? subscription;

  @override
  PathNavMessage? build() {
    final mapController = ref.watch(dgisControllerProvider);

    /// Send lost GPS signal to analytics if the user lost GPS signal and close the app
    /// So here we will not have duration of lost GPS signal
    AdvancedMetrics.instance.sendLostGPS(track: ref.read(urbiAnalyticsProvider).track);

    subscription = mapController.value?.naviMessageController.events.listen((event) {
      if (event.state == NaviMessageEventState.gpsLost) {
        AdvancedMetrics.instance.addLostGPS();
      } else {
        // We will not send the event if gps signal was not lost
        // So we can send it without any additional checks
        AdvancedMetrics.instance.addRestoreGPS(track: ref.read(urbiAnalyticsProvider).track);
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
