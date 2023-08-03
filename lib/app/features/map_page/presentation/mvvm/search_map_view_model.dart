import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';

class SearchMapViewModel extends BaseViewModel {
  TextEditingController searchController = TextEditingController();

  final DgisMapController controller;

  SearchMapViewModel(this.controller);

  Future<void> performSearch({required String queryText}) async {
    try {
      searchController.text = queryText;
      SearchResultMessage data = await controller.search(
        queryText,
        sortingType: SortingTypeMessage.byRelevance,
        isOpenNow: false,
      );
      if (data.firstPage?.items != null) {
        final responseDistance = await controller.getDistanceTo(
          _mapToDistanceRequest(
            data.firstPage!.items
                .map((e) => e as DirectoryObjectMessage)
                .toList(),
          ),
        );
        print(responseDistance);
      }
      print(data);
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
