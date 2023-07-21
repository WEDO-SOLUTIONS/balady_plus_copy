import 'dart:async';
import 'dart:math';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/features/map_page/constants/constants.dart';
import 'package:balady_plus/app/features/map_page/data/data_sources/point_layers_data.dart';
import 'package:balady_plus/app/features/map_page/data/model/excavations.dart';
import 'package:balady_plus/app/features/map_page/data/model/investment_sites.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../core/services/global/web_service.dart';
import '../../data/model/layers.dart';
import 'package:flutter/foundation.dart';

class LayersRepositories {
  final WebService webService;

  LayersRepositories({required this.webService});

  Future<List<Layers>?> getMinLayers() async {
    try {
      final layersType = await webService.dio.get(
        Constants.mainUrl,
        options: Options(headers: {'verifyingKEY': Constants.verifyingKEY}),
      );
      if (layersType.data != null) {
        return layersFromJson(layersType.data['data']['result']['layers'])
            .where((element) => element.id == 4 || element.id == 2)
            .toList();
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<SubLayers>?> getSubLayers(int layersId) async {
    try {
      final layersType = await webService.dio.get(
        '${Constants.mainUrl}$layersId',
        options: Options(headers: {'verifyingKEY': Constants.verifyingKEY}),
      );
      if (layersType.data != null) {
        return subLayersFromJson(layersType.data['data']['result']
            ['drawingInfo']['renderer']['uniqueValueInfos']);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<PointLayersData>?> getPointsInLayers({
    required int layerId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final points = await webService.dio.get(
        '${Constants.mainUrl}/$layerId/query',
        queryParameters: {
          // "text": "",
          // "objectIds": "",
          "outFields": "*",
          /////////////////// to can send lat and long
          // "geometryType": "esriGeometryPoint",
          "geometry": "$latitude,$longitude",
          ////////////////////////// To get data in a specific area
          // "distance": 4,
          // "supportsQueryWithDistance": true,
          // // The unit for calculating the buffer distance. If unit is not specified, the default will be esriSRUnit_Foot
          // "units": "esriSRUnit_Kilometer"
        },
        options: Options(headers: {'verifyingKEY': Constants.verifyingKEY}),
      );
      switch (layerId) {
        case 2: //     المواقع الاستثمارية
          return investmentSitesFromJson(
            points.data['data']['result']['features'],
          );
        case 4: //الحفريات
          return excavationsFromJson(
            points.data['data']['result']['features'],
          );
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
