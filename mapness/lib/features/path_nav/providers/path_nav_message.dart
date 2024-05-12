import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'path_nav_message.g.dart';

@riverpod
class _PathNavMessage extends _$PathNavMessage {
  StreamSubscription<NaviMessageEvent>? subscription;

  @override
  NaviMessageEventState? build() {
    final mapController = ref.watch(dgisControllerProvider);

    subscription =
        mapController.value?.naviMessageController.events.listen((event) {
      if (state == NaviMessageEventState.none) {
        state = null;
      } else {
        state = event.state;
      }
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
