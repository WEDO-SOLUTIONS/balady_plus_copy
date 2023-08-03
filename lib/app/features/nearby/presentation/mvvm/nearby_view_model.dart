import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/features/map_page/extensions/search_category_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';

class NearByViewModel extends BaseViewModel {
  ValueNotifier<SearchCategoryMessage?> selectedCategory = ValueNotifier(null);

  final DgisMapController controller;
  final isSearchLoading = ValueNotifier(false);
  final ValueNotifier<SearchResultMessage?> searchResultMessage =
      ValueNotifier(null);

  NearByViewModel(this.controller);

  Future<void> selectCategory({required SearchCategoryMessage category}) async {
    if (category == selectedCategory.value) {
      selectedCategory.value = null;
    } else {
      selectedCategory.value = category;
    }
    isSearchLoading.value = true;

    isSearchLoading.notifyListeners();
    performSearch(
        // queryText: selectedCategory.value!.displayName(),
        );
    isSearchLoading.value = false;
    isSearchLoading.notifyListeners();
  }

  Future<void> performSearch() async {
    try {
      // searchController.text = selectedCategory.value != null
      //     ? selectedCategory.value!.displayName()
      //     : queryText;

      searchResultMessage.value = await controller.searchByCategory(
        selectedCategory.value!,
        sortingType: SortingTypeMessage.byDistance,
        // searchRect: _lastHandledEvent?.visibleRect.geoRectMessage(),
      );

      if (searchResultMessage.value!.firstPage?.items != null) {
        final responseDistance = await controller.getDistanceTo(
          _mapToDistanceRequest(
            searchResultMessage.value!.firstPage!.items
                .map((e) => e as DirectoryObjectMessage)
                .toList(),
          ),
        );
        print(responseDistance);
      }
      if (searchResultMessage.value!.firstPage != null) {
        print("Releasing Page");
        await controller.releasePage(searchResultMessage.value!.firstPage!);
      }
      notifyListeners();
      // print(data);
    } catch (e) {
      print(e);
    }
  }

  List<DistanceRequestMessage> _mapToDistanceRequest(
          List<DirectoryObjectMessage> values) =>
      values
          .where((element) => element.id != null)
          .where((element) => element.markerPosition != null)
          .map((e) => DistanceRequestMessage(
                geoPoint: GeoPointMessage(
                  latitude: e.markerPosition!.latitude,
                  longitude: e.markerPosition!.longitude,
                ),
                dgisObjectId: e.id!,
              ))
          .toList();
}
