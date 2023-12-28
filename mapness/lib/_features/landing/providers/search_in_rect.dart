import 'package:dgis_map/library.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_in_rect.g.dart';

@riverpod
class SearchInRect extends _$SearchInRect {
  @override
  (GeoRectMessage?, bool) build() {
    final filter = ref.watch(searchByRubricsQueryProvider);
    if (filter == null) return (null, false);

    final subscription = ref
        .watch(dgisControllerProvider)
        .value
        ?.visibleRectEvents
        .listen((event) {
      state = (state.$1, true);
    });
    ref.onDispose(() {
      subscription?.cancel();
    });

    return (null, false);
  }

  void update() {
    final dgisController = ref.read(dgisControllerProvider.notifier);

    state = (
      dgisController.visibleRectSubject.value.visibleRect.geoRectMessage(),
      false
    );
  }
}
