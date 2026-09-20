import 'package:dgis_map/library.dart';
import 'package:mapness/features/landing/models/search_in_rect_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/transformers.dart';

part 'search_in_rect.g.dart';

@riverpod
class SearchInRect extends _$SearchInRect {
  @override
  SearchInRectState build(String scope) {
    final dgisController = ref.watch(dgisControllerProvider).value;

    final subscription = dgisController?.visibleRectEvents.debounceTime(const Duration(milliseconds: 300)).listen((
      event,
    ) async {
      if (!ref.mounted) {
        return;
      }
      _setDefaultValue(event);

      final isSearchRunning = ref.read(searchProvider(scope).notifier).isSearchRunning;
      if (!isSearchRunning) {
        state = SearchInRectState(
          rect: event.visibleRect.geoRectMessage(),
          isButtonVisible: false,
        );
      } else {
        state = SearchInRectState(
          rect: state.rect,
          isButtonVisible: _buttonVisible(
            state.rect,
            event.visibleRect.geoRectMessage(),
          ),
        );
      }
    });
    ref.onDispose(() {
      subscription?.cancel();
    });

    return SearchInRectState(
      rect: ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect.geoRectMessage(),
      isButtonVisible: false,
    );
  }

  void _setDefaultValue(VisibleRectEvent event) {
    if (ref.mounted && state.rect == null) {
      state = SearchInRectState(
        rect: event.visibleRect.geoRectMessage(),
        isButtonVisible: state.isButtonVisible,
      );
    }
  }

  void update() {
    if (!ref.mounted) {
      return;
    }
    final dgisController = ref.read(dgisControllerProvider.notifier);

    state = SearchInRectState(
      rect: dgisController.visibleRectSubject.valueOrNull?.visibleRect.geoRectMessage(),
      isButtonVisible: false,
    );
  }

  void searchInThisAreaSwitch({required bool value}) {
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(isSearchInThisAreaRequest: value);
  }

  bool _buttonVisible(GeoRectMessage? oldRect, GeoRectMessage newRect) {
    final zoom = ref.read(cameraPositionProvider)?.zoom;
    if (oldRect == null || (zoom != null && zoom == 14)) {
      return false;
    }

    // Check if the new rectangle is entirely within the old rectangle
    final bool isNextInsidePrev =
        newRect.northEast.latitude <= oldRect.northEast.latitude &&
        newRect.northEast.longitude <= oldRect.northEast.longitude &&
        newRect.southWest.latitude >= oldRect.southWest.latitude &&
        newRect.southWest.longitude >= oldRect.southWest.longitude;

    // If the new rectangle is within the old one, return false
    if (isNextInsidePrev) {
      return false;
    }

    final oldCenterLat = (oldRect.northEast.latitude + oldRect.southWest.latitude) / 2;
    final oldCenterLng = (oldRect.northEast.longitude + oldRect.southWest.longitude) / 2;
    final newCenterLat = (newRect.northEast.latitude + newRect.southWest.latitude) / 2;
    final newCenterLng = (newRect.northEast.longitude + newRect.southWest.longitude) / 2;

    // Calculate the distance between the centers of the two rectangles
    final distance = CommonFunctions.distance(
      oldCenterLat,
      oldCenterLng,
      newCenterLat,
      newCenterLng,
    );

    final diag = CommonFunctions.distance(
      oldRect.northEast.latitude,
      oldRect.northEast.longitude,
      oldRect.southWest.latitude,
      oldRect.southWest.longitude,
    );

    // Check if the distance is greater than half the diagonal of the old rectangle
    return distance > diag / 2;
  }
}
