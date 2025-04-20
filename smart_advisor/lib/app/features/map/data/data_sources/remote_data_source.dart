import 'dart:convert';

import 'package:dio/src/response.dart';
import 'package:smart_advisor/app/features/map/data/models/building_compliance_certificate.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/apis/env_types.dart';
import '../models/map_requests_params.dart';
import '../models/point_layers_data.dart';
import '/app/core/utils/constants/apis/apis_get.dart';
import '/app/features/map/data/models/gis_data_response_model.dart';
import '/app/features/map/data/models/validate_point_response_model.dart';
import '/app/features/map/data/models/zone_item_model.dart';
import '/app/features/map/domain/entities/get_zones_request.dart';
import '/app/features/map/domain/entities/gis_data_request.dart';
import '/app/features/map/domain/entities/validate_point_request.dart';
import 'package:dio/dio.dart' show DioException, Options, Options;
import '/app/core/utils/constants/language.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';

import '../../../../core/errors/errors_exports.dart' show ServerException;
import '../../../../core/services/services_exports.dart'
    show SmartAdvisorWebService;
import '../../../_shared_feature_/presentation/models/response_body_model.dart';

abstract class SmartAdvisorMapRemoteDataSource {
  Future<List<ZoneItemModel>> getZones(GetZonesRequest params);

  Future<List<ValidatePointResponseModel>> validatePoint(
      ValidatePointRequest params);

  Future<GisDataResponseModel> getGISData(GISDataRequest params);

  Future<List<PointLayersData>?> getPointsInLayers(
      {required MapRequestParams params});
}

class SmartAdvisorMapRemoteDataSourceImplementation
    implements SmartAdvisorMapRemoteDataSource {
  final SmartAdvisorWebService webService;

  SmartAdvisorMapRemoteDataSourceImplementation({required this.webService});

  @override
  Future<List<PointLayersData>?> getPointsInLayers(
      {required MapRequestParams params}) async {
    Response points;
    try {
      String q = "${ApiUrls.getMapLayers}/${params.layer.layerId}/query?";
      params.toMap().forEach((key, value) {
        q += "$key=$value&";
      });
      q = sl<EnvType>().domain + q.substring(0, q.length - 1);

      print("wwwww $q");
      points = await webService.dio.get(
        '${ApiUrls.getMapLayers}/${params.layer.layerId}/query',
        queryParameters: params.toMap(),
        options: Options(headers: {
          "verifyingKEY": CommonFunctions.hashRequest(
            q, "GET",
            // authorization: BaladyServices.token.isNotEmpty ? true : false
          )
        }),
      );

      switch (params.layer.layerId) {
        case 1: //     المطاعم

        case 7: //   شهادة امتثال المباني
          return buildingComplianceCertificateFromJson(
            points.data['data']['result']['features'],
          );
      }
    } on DioException catch (error, stackTrace) {
      print(error);
      //"DioError $error".errorLog();
    }
    return null;
  }

  @override
  Future<GisDataResponseModel> getGISData(GISDataRequest params) async {
    try {
      final response = await webService.dio
          .get(ApiUrls.gisInfo, queryParameters: params.toMap());
      print(response.data);

      final result = ResponseBodyModel<GisDataResponseModel>.fromMap(
              response.data,
              parsedResult: GisDataResponseModel.fromJson(
                  response.data["data"]["result"]))
          .data
          ?.result;

      return result!;
    } on DioException catch (error) {
      throw ServerException(error.toString());
    } catch (ex) {
      print(ex);
      print("JJ");
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errorsServerError".tr());
      }
    }
  }

  @override
  Future<List<ZoneItemModel>> getZones(GetZonesRequest params) async {
    try {
      final response = await webService.dio.get(
          ApiUrls.getZones(params.activityId),
          queryParameters: params.toMap());
      print(response.data);
      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      return result
              ?.map<ZoneItemModel>(
                  (e) => ZoneItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
    } on DioException catch (error) {
      throw ServerException(error.toString());
    } catch (ex) {
      print(ex);
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errorsServerError".tr());
      }
    }
  }

  @override
  Future<List<ValidatePointResponseModel>> validatePoint(
      ValidatePointRequest params) async {
    try {
      final verifyingKEY = CommonFunctions.hashRequest(
        sl<EnvType>().domain + ApiUrls.validatePoint, "POST",
        body: json.encode(params.toJson()),
        // authorization: BaladyServices.token.isNotEmpty ? true : false
      );

      final response = await webService.dio.post(ApiUrls.validatePoint,
          data: params.toJson(),
          options: Options(headers: {"verifyingKEY": verifyingKEY}));
      print(response.data);
      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      return result
              ?.map<ValidatePointResponseModel>((e) =>
                  ValidatePointResponseModel.fromJson(
                      e as Map<String, dynamic>))
              .toList() ??
          [];
    } on DioException catch (error) {
      throw ServerException(error.toString());
    } catch (ex) {
      print(ex);
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errorsServerError".tr());
      }
    }
  }
}
