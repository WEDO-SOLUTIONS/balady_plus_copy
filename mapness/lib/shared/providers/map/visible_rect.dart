import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'visible_rect.g.dart';

@riverpod
class _VisibleRect extends _$VisibleRect {
  @override
  VisibleRect? build() {
    final dgisController = ref.watch(dgisControllerProvider);
    final visibleRectSubscription = dgisController.value?.visibleRectEvents.listen(_visibleRectListener);
    ref.onDispose(
      () {
        visibleRectSubscription?.cancel();
      },
    );

    return null;
  }

  void _visibleRectListener(VisibleRectEvent event) {
    if (!ref.mounted) {
      return;
    }
    state = event.visibleRect;
  }
}

final visibleRectProvider = _visibleRectProvider;
