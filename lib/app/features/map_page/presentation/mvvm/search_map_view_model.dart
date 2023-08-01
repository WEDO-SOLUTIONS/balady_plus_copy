import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';

import '../../constants/constants.dart';

class SearchMapViewModel extends BaseViewModel {
  TextEditingController searchController = TextEditingController();

  final DgisMapController controller;

  SearchMapViewModel(this.controller);

  Future<void> performSearch({required String queryText}) async {
    /*try {
      searchController.text = queryText;
      List<DirectoryObjectMessage> data = await controller.search(
        queryText,
        sortingType: SortingTypeMessage.byDistance,
        searchMarker:
            MarkerIconMessage(path: Constants.icMarkerRestaurant, width: 30),
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
    }*/
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
