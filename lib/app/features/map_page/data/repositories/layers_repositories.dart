import 'dart:async';

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

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/services/global/web_service.dart';
import '../../../entry_point/presentation/cubit/auth_cubit.dart';
import '../../data/model/layers.dart';

import '../model/investment_details_response.dart';
import '../model/rental_details_response.dart';
import '../model/requests/map_requests_params.dart';
import '../model/resturant_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class LayersRepositories {
  final WebService webService;

  LayersRepositories({required this.webService});

  Future<List<Layers>?> getMinLayers() async {
    Response<dynamic> layersType;
    try {
      layersType = await webService.dio.get(
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
                  element.id != 6 &&
                  element.id != 5 &&
                  element.id != 9,
            )
            .toList();
      }
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    return null;
  }

  Future<List<SubLayers>?> getSubLayers(int layersId) async {
    try {
      final layersType = await webService.dio.get(
        '${Constants.mainUrl}$layersId',
        options: Options(
          /*  headers: {
            'verifyingKEY': CommonFunctions.hashRequest(
              Constants.mainUrl,
              "GET",
            )
          },*/
        ),
      );
      if (layersType.data != null) {
        return subLayersFromJson(layersType.data['data']['result']['drawingInfo']['renderer']['uniqueValueInfos']);
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    return null;
  }

  Future<List<PointLayersData>?> getPointsInLayers({required MapRequestParams params}) async {
    Response<dynamic> points;
    try {
      String q = "${Constants.mainUrl}/${params.layer.layerId}/query?";
      params.toMap().forEach((key, value) {
        q += "$key=$value&";
      });
      q = q.substring(0, q.length - 1);

      points = await webService.dio.get(
        '${Constants.mainUrl}/${params.layer.layerId}/query',
        queryParameters: params.toMap(),
        options: Options(
          headers: {
            ApiHeader.requiresToken.eName: false,
            ApiHeader.verifyingKEY.name: CommonFunctions.hashRequest(q, "GET"),
          },
        ),
        /* queryParameters: {
          // "where":"1=1",
          // "text": "",
          // "objectIds": "",
          "outFields": "*",
          "resultRecordCount": '50',
          /////////////////// to can send lat and long
          "geometryType": "esriGeometryEnvelope", //"esriGeometryPoint",
          "geometry":
              "$southWestLongitude,$southWestLlatitude,$northEastLongitude,$northEastLatitude",
          ////////////////////////// To get data in a specific area
          // "distance": 100,
          // "supportsQueryWithDistance": true,
          // // The unit for calculating the buffer distance. If unit is not specified, the default will be esriSRUnit_Foot
          // "units": "esriSRUnit_Kilometer"
        }*/
        /*options: Options(headers: {
          ApiHeader.requiresToken.eName: false,
          'verifyingKEY': CommonFunctions.hashRequest(
              '${Constants.mainUrl}/$layerId/query?outFields=CONTRACTOR_NAME,PROJECTSTARTDATE,PROJECTENDDATE,START_POINT_X,START_POINT_Y,END_POINT_X,END_POINT_Y,SERVTYPE,PROJECT_DESC,PROJECT_NAME,OBJECTID&resultOffset=50&geometryType=esriGeometryEnvelope&geometry=$southWestLongitude,$southWestLlatitude,$northEastLongitude,$northEastLatitude',
              "GET")
        }),*/
      );

      switch (params.layer.layerId) {
        case 1: //     المطاعم
          return resturantFromJson(points.data['data']['result']['features']);
        case 2: //     المواقع الاستثمارية
          return investmentSitesFromJson(points.data['data']['result']['features']);
        case 5: //   الحفريات
          return excavationsFromJson(points.data['data']['result']['features']);
        case 7: //   شهادة امتثال المباني
          return buildingComplianceCertificateFromJson(points.data['data']['result']['features']);
        /*case 8: //   اراضي مطلوب تسويرها
          return landsFencedFromJson(
            points.data['data']['result']['features'],
          );*/
        case 8: //   اراضي بيضاء
          return whiteLandsFromJson(points.data['data']['result']['features']);
        //case 10: //       حدود قطع الأراضي
        //   return boundariesPlotsFromJson(
        //   points.data['data']['result']['features'],
        //  );
        case 9: //       حدود المخططات التقسيمية
          return divisionalChartBoundariesFromJson(points.data['data']['result']['features']);
      }
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    return null;
  }

  Future<List<PointLayersData>?> getPointDetailsInLayers({required MapRequestParams params}) async {
    try {
      final points = await webService.dio.get(
        '${Constants.mainUrl}/${params.layer.layerId}/query',
        queryParameters: params.toMap(pointsDetails: true),
        options: Options(headers: {ApiHeader.requiresToken.eName: false}),
      );

      switch (params.layer.layerId) {
        case 2: //     المواقع الاستثمارية
          return investmentSitesFromJson(points.data['data']['result']['features']);
        case 5: //   الحفريات
          return excavationsFromJson(points.data['data']['result']['features']);
        case 7: //   شهادة امتثال المباني
          return buildingComplianceCertificateFromJson(points.data['data']['result']['features']);
        case 8: //   اراضي مطلوب تسويرها
          return landsFencedFromJson(points.data['data']['result']['features']);
        case 9: //   اراضي بيضاء
          return whiteLandsFromJson(points.data['data']['result']['features']);
        case 10: //       حدود قطع الأراضي
          return boundariesPlotsFromJson(points.data['data']['result']['features']);
        case 11: //       حدود المخططات التقسيمية
          return divisionalChartBoundariesFromJson(points.data['data']['result']['features']);
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    return null;
  }

  Future<InvestmentDetailsResponse?> getInvetmentDetails(String investmentId, String type) async {
    try {
      await sl<EntryPointCubit>().refreshAPIGeeToken();

      final response = await webService.dio.get(
        "${sl<EnvType>().domain}v1/ims/investment-details",
        queryParameters: {'Type': type, 'RFPID': investmentId},
        options: Options(headers: {'Authorization': "Bearer ${sl<EntryPointCubit>().state.apigeeToken?.accessToken}"}),
      );

      InvestmentDetailsResponse? investmentDetailsResponse = InvestmentDetailsResponse.fromJson(response.data);

      return investmentDetailsResponse;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    return null;
  }

  Future<RentalDetailsResponse?> getTempRentalDetails(String investmentId, String type) async {
    try {
      await sl<EntryPointCubit>().refreshAPIGeeToken();

      final response = await webService.dio.get(
        "${sl<EnvType>().domain}v1/ims/temp-rental-details",
        queryParameters: {'Type': type, 'RFPID': investmentId},
        options: Options(headers: {'Authorization': "Bearer ${sl<EntryPointCubit>().state.apigeeToken?.accessToken}"}),
      );

      RentalDetailsResponse? investmentDetailsResponse = RentalDetailsResponse.fromJson(response.data);

      return investmentDetailsResponse;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    return null;
  }
}
