import 'package:dgis_map/library.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_in_rect.g.dart';

@riverpod
class SearchInRect extends _$SearchInRect {
  @override
  (GeoRectMessage?, bool) build() {
    final filter = ref.watch(searchByRubricsQueryProvider);
    if (filter == null) {
      return (null, false);
    }

    final dgisController = ref.watch(dgisControllerProvider).value;

    final subscription =
        dgisController?.visibleRectEvents.listen((event) async {
      state = (
        state.$1,
        await _buttonVisible(event.visibleRect.geoRectMessage(), state.$1)
      );
    });
    ref.onDispose(() {
      subscription?.cancel();
    });

    return (
      ref
          .read(dgisControllerProvider.notifier)
          .visibleRectSubject
          .value
          ?.visibleRect
          .geoRectMessage(),
      false,
    );
  }

  void update() {
    final dgisController = ref.read(dgisControllerProvider.notifier);

    state = (
      dgisController.visibleRectSubject.value?.visibleRect.geoRectMessage(),
      false
    );
  }

  Future<bool> _buttonVisible(
      GeoRectMessage oldRect, GeoRectMessage? newRect) async {
    if (newRect == null) {
      return false;
    }

    final distance = CommonFunctions.distance(
          oldRect.northEast.latitude,
          oldRect.northEast.longitude,
          newRect.northEast.latitude,
          newRect.northEast.longitude,
        ) +
        CommonFunctions.distance(
          oldRect.southWest.latitude,
          oldRect.southWest.longitude,
          newRect.southWest.latitude,
          newRect.southWest.longitude,
        );

    final contains = await ref
        .read(dgisControllerProvider)
        .value!
        .containsRect(oldRect, newRect);

    return distance > 5 && contains;
  }
}
