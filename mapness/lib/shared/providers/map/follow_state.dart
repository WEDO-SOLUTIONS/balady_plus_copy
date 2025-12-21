import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_state.g.dart';

class Follow {
  Follow({
    required this.enabled,
    required this.type,
  });
  final bool enabled;
  final LocationFollowType type;

  Follow copyWith({
    bool? enabled,
    LocationFollowType? type,
  }) =>
      Follow(
        enabled: enabled ?? this.enabled,
        type: type ?? this.type,
      );
}

@riverpod
class FollowState extends _$FollowState {
  @override
  Follow build() {
    final dgisController = ref.watch(dgisControllerProvider);
    final typeSubscription = dgisController.value?.locationFollowEvents.listen(_followTypeListener);
    final enabledSubscription = dgisController.value?.locationEnabledEvents.listen(_locationEnabledListener);
    ref.onDispose(
      () {
        typeSubscription?.cancel();
        enabledSubscription?.cancel();
      },
    );

    return Follow(
      enabled: false,
      type: LocationFollowType.off,
    );
  }

  void _followTypeListener(LocationFollowType event) {
    state = state.copyWith(type: event);
  }

  void _locationEnabledListener(LocationEnabledEvent event) {
    state = state.copyWith(enabled: event.isEnabled);
  }

  void toggleFollowState() {
    ref.read(dgisControllerProvider).value?.toggleFollowState();
  }
}
