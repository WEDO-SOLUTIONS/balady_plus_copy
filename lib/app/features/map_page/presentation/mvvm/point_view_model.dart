import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/extensions/json_conversion.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'map_view_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

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
      isLoadingData.value = true;
      isLoadingData.notifyListeners();
      try {
        dataPoint.value = await controller.searchByObjectId(point);
      } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
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
      }
      if (dataPoint.value != null) {
        //getPhotos(dataPoint.value!);
      }
      isLoadingData.value = false;
      isLoadingData.notifyListeners();
      // dataPoint.value = await controller.(point);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      ///
    }
  }
}
