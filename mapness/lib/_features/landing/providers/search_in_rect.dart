import 'package:dgis_map/library.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_in_rect.g.dart';

@riverpod
class SearchInRect extends _$SearchInRect {
  @override
  (GeoRectMessage?, bool) build() {
    final dgisController = ref.watch(dgisControllerProvider).value;

    final subscription = dgisController?.visibleRectEvents.listen((event) async {
      _setDefaultValue(event);

      final isSearchRunning = ref.watch(searchProvider(SearchScopeEnum.map.value).notifier).isSearchRunning;
      if (!isSearchRunning) {
        state = (event.visibleRect.geoRectMessage(), false);
      } else {
        state = (
          state.$1,
          _buttonVisible(
            state.$1,
            event.visibleRect.geoRectMessage(),
          )
        );
      }
    });
    ref.onDispose(() {
      subscription?.cancel();
    });

    return (
      ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect.geoRectMessage(),
      false,
    );
  }

  void _setDefaultValue(VisibleRectEvent event) {
    if (state.$1 == null) {
      state = (
        event.visibleRect.geoRectMessage(),
        state.$2,
      );
    }
  }

  void update() {
    final dgisController = ref.read(dgisControllerProvider.notifier);

    state = (dgisController.visibleRectSubject.value?.visibleRect.geoRectMessage(), false);
  }

  bool _buttonVisible(GeoRectMessage? oldRect, GeoRectMessage newRect) {
    if (oldRect == null) {
      return false;
    }

    final diag = CommonFunctions.distance(
      oldRect.northEast.latitude,
      oldRect.northEast.longitude,
      oldRect.southWest.latitude,
      oldRect.southWest.longitude,
    );

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

    return distance > diag / 2;
  }
}
