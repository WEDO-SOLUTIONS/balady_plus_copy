import 'dart:async';
import 'dart:math';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/map_page/constants/constants.dart';
import 'package:balady_plus/app/features/map_page/data/data_sources/point_layers_data.dart';
import 'package:balady_plus/app/features/map_page/data/model/building_compliance_certificate.dart';
import 'package:balady_plus/app/features/map_page/data/model/divisional_chart_boundaries.dart';
import 'package:balady_plus/app/features/map_page/data/model/excavations.dart';
import 'package:balady_plus/app/features/map_page/data/model/investment_sites.dart';
import 'package:balady_plus/app/features/map_page/data/model/boundaries_plots.dart';
import 'package:balady_plus/app/features/map_page/data/model/lands_fenced.dart';
import 'package:balady_plus/app/features/map_page/data/model/white_lands.dart';
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
        options: Options(headers: {ApiHeader.requiresToken.eName: false}),
      );
      if (layersType.data != null) {
        return layersFromJson(layersType.data['data']['result']['layers'])
            .where(
              (element) =>
                  element.id != 0 &&
                  element.id != 1 &&
                  element.id != 3 &&
                  element.id != 4 &&
                  element.id != 6,
            )
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
        options: Options(
          headers: {
            'verifyingKEY': CommonFunctions.hashRequest(
              Constants.mainUrl,
              "GET",
            )
          },
        ),
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
    required double northEastLongitude,
    required double northEastLatitude,
    required double southWestLongitude,
    required double southWestLlatitude,
  }) async {
    try {
      print(
          '${Constants.mainUrl}/$layerId/query?outFields=*&geometryType=esriGeometryEnvelope&geometry=$southWestLongitude,$southWestLlatitude,$northEastLongitude,$northEastLatitude');
      final points = await webService.dio.get(
        '${Constants.mainUrl}/$layerId/query',
        queryParameters: {
          // "where":"1=1",
          // "text": "",
          // "objectIds": "",
          "outFields": "*",
          /////////////////// to can send lat and long
          "geometryType": "esriGeometryEnvelope" , //"esriGeometryPoint",
          "geometry": "$southWestLongitude,$southWestLlatitude,$northEastLongitude,$northEastLatitude",
          ////////////////////////// To get data in a specific area
          // "distance": 100,
          // "supportsQueryWithDistance": true,
          // // The unit for calculating the buffer distance. If unit is not specified, the default will be esriSRUnit_Foot
          // "units": "esriSRUnit_Kilometer"
        },
        options: Options(headers: {
          ApiHeader.requiresToken.eName: false,
          'verifyingKEY': CommonFunctions.hashRequest(
              '${Constants.mainUrl}/$layerId/query?outFields=*&geometryType=esriGeometryEnvelope&geometry=$southWestLongitude,$southWestLlatitude,$northEastLongitude,$northEastLatitude',
              "GET")
        }),
      );

      switch (layerId) {
        case 2: //     المواقع الاستثمارية
          return investmentSitesFromJson(
            points.data['data']['result']['features'],
          );
        case 5: //   الحفريات
          return excavationsFromJson(
            points.data['data']['result']['features'],
          );
        case 7: //   شهادة امتثال المباني
          return buildingComplianceCertificateFromJson(
            points.data['data']['result']['features'],
          );
        case 8: //   اراضي مطلوب تسويرها
          return landsFencedFromJson(
            points.data['data']['result']['features'],
          );
        case 9: //   اراضي بيضاء
          return  whiteLandsFromJson(
            points.data['data']['result']['features'],
          );
        case 10: //       حدود قطع الأراضي
          return boundariesPlotsFromJson(
            points.data['data']['result']['features'],
          );
        case 11: //       حدود المخططات التقسيمية
          return divisionalChartBoundariesFromJson(
            points.data['data']['result']['features'],
          );
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
