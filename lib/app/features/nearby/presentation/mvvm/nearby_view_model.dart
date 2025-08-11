import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/map_page/extensions/search_category_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';

class NearByViewModel extends BaseViewModel {
  ValueNotifier<SearchCategoryMessage?> selectedCategory = ValueNotifier(null);

  final DgisMapController controller;
  final isSearchLoading = ValueNotifier(false);
  final ValueNotifier<SearchResultMessage?> searchResultMessage =
      ValueNotifier(null);

  List<DistanceResponseMessage>? responseDistance;

  NearByViewModel(this.controller) {
    selectCategory(category: SearchCategoryMessage.mousques);
  }

  Future<void> selectCategory({required SearchCategoryMessage category}) async {
    selectedCategory.value = category;
    isSearchLoading.value = true;
    isSearchLoading.notifyListeners();
    await performSearch();
    isSearchLoading.value = false;
    isSearchLoading.notifyListeners();
  }

  Future<void> performSearch() async {
    try {
      searchResultMessage.value = await controller.searchByRubrics(
        selectedCategory.value!.rubrics,
        sortingType: SortingTypeMessage.byRelevance,
        isOpenNow: false,
        pageSize: 50,
      );
      if (searchResultMessage.value!.firstPage?.items != null) {
        responseDistance = await controller.getDistanceTo(
          _mapToDistanceRequest(
            searchResultMessage.value!.firstPage!.items
                .map((e) => e as DirectoryObjectMessage)
                .toList(),
          ),
        );
      }
      if (searchResultMessage.value!.firstPage != null) {
        await controller.releasePage(searchResultMessage.value!.firstPage!);
      }
      searchResultMessage.notifyListeners();
    } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
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
