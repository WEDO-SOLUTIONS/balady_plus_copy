import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/extensions/json_conversion.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'map_view_model.dart';

class PointViewModel extends BaseViewModel {
  final WebService webService;
  final DgisMapController controller;
  final DgisObjectIdMessage point;
  final dataPoint = ValueNotifier<DirectoryObjectMessage?>(null);
  final isLoadingData = ValueNotifier<bool?>(false);

  PointViewModel(
      {required this.controller,
      required this.point,
      required this.webService}) {
    performSearch();
  }

  Future<void> performSearch() async {
    try {
      print("performSearch");
      isLoadingData.value = true;
      isLoadingData.notifyListeners();
      try {
        dataPoint.value = await controller.searchByObjectId(point);
      } catch (ex) {
        print("performSearch: ${ex}");
        isLoadingData.value = false;
        isLoadingData.notifyListeners();
        MapViewModel mapViewModel = Provider.of<MapViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);

        mapViewModel.viewHomeBottomSheet.value = true;
        mapViewModel.viewHomeBottomSheet.notifyListeners();
        mapViewModel.bottomSheetSize.notifyListeners();
        mapViewModel.selectedPointId.value = null;
        mapViewModel.selectedPointId.notifyListeners();
        mapViewModel.controller.setHighlighted([]);
      }
      if (dataPoint.value != null) {
        print(dataPoint.value?.title.toString());
        //getPhotos(dataPoint.value!);
      }
      isLoadingData.value = false;
      isLoadingData.notifyListeners();
      // dataPoint.value = await controller.(point);
      print(dataPoint);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getPhotos(DirectoryObjectMessage dataPoint) async {
    try {
      final data = await webService.dio.get(
        'https://sandbox-api.photo.2gis.com/2.0/photo/get',
        queryParameters: {
          "key": "mobile_ios",
          "object_id": dataPoint.id?.objectId.toString(),
          "object_type": dataPoint.types[0]?.type.name,
          "album_code": "common",
          "preview_size": "100x100",
        },
      );
      print(data);
    } catch (e) {
      print(e);
    }
  }
}
