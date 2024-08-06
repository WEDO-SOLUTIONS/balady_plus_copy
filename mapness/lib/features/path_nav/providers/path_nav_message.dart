import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/entities/path_nav/models/path_nav_message.dart';
import 'package:mapness/features/path_nav/lib/extensions.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'path_nav_message.g.dart';

@riverpod
class _PathNavMessage extends _$PathNavMessage {
  StreamSubscription<NaviMessageEvent>? subscription;

  @override
  PathNavMessage? build() {
    final mapController = ref.watch(dgisControllerProvider);

    subscription = mapController.value?.naviMessageController.events.listen((event) {
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
