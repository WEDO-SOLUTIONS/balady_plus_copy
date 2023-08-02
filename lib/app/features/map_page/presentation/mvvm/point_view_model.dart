import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';

class PointViewModel extends BaseViewModel {
  final WebService webService;
  final DgisMapController controller;
  final DgisObjectIdMessage point;
  final dataPoint = ValueNotifier<DirectoryObjectMessage?>(null);

  PointViewModel(
      {required this.controller,
      required this.point,
      required this.webService}) {
    performSearch();
  }

  Future<void> performSearch() async {
    try {
      print("performSearch");
      dataPoint.value = await controller.searchByObjectId(point);
      if (dataPoint.value != null) {
        print(dataPoint.value?.externalIds);
        getPhotos(dataPoint.value!);
      }
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
