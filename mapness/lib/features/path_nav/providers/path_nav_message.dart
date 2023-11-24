import 'package:dgis_map/library.dart';
import 'package:mapness/entities/path_nav/models/path_nav_message.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_message_widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'path_nav_message.g.dart';

@riverpod
class _PathNavMessage extends _$PathNavMessage {
  @override
  PathNavMessage? build() {
    final mapController = ref.watch(dgisControllerProvider);

    final subscription =
        mapController?.naviMessageController.events.listen((event) {
      switch (event.state) {
        case NaviMessageEventState.gpsLost:
          state = const PathNavMessage(
            state: PathNavManeuverState.error,
            comment: 'GPS Signal lost',
          );
          break;
        case NaviMessageEventState.routeResearch:
          state = const PathNavMessage(
            state: PathNavManeuverState.reroute,
            comment: 'rerouting',
          );
          break;
        case NaviMessageEventState.none:
          state = null;
      }
    });
    ref.onDispose(() {
      subscription?.cancel();
    });

    return null;
  }
}

final pathNavMessageProvider = _pathNavMessageProvider;
