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
      List<ObjectInfoMessage> data = await controller.search(
        queryText,
        searchMarker: MarkerIconMessage(
          path: "assets/maps/icons/ic_marker.svg",
          width: 24,
        ),
        sortingType: SortingTypeMessage.byDistance,
        isOpenNow: true,
      );
      if (data.isNotEmpty) {
        final responseDistance = await controller.getDistanceTo(
          _mapToDistanceRequest(data),
        );
        print(responseDistance);
      }
      print(data);
    } catch (e) {
      print(e);
    }
  }

  List<DistanceRequestMessage> _mapToDistanceRequest(
          List<ObjectInfoMessage> values) =>
      values
          .where((element) => element.dgisObjectId != null)
          .where((element) => element.markerPosition != null)
          .map((e) => DistanceRequestMessage(
                geoPoint: e.markerPosition!.point,
                dgisObjectId: e.dgisObjectId!,
              ))
          .toList();
}
