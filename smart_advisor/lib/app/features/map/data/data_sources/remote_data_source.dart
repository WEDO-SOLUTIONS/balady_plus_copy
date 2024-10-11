import '/app/core/utils/constants/apis/apis_get.dart';
import '/app/features/map/data/models/gis_data_response_model.dart';
import '/app/features/map/data/models/validate_point_response_model.dart';
import '/app/features/map/data/models/zone_item_model.dart';
import '/app/features/map/domain/entities/get_zones_request.dart';
import '/app/features/map/domain/entities/gis_data_request.dart';
import '/app/features/map/domain/entities/validate_point_request.dart';
import 'package:dio/dio.dart' show DioError;
import '/app/core/utils/constants/language.dart';

import '../../../../core/errors/errors_exports.dart' show ServerException;
import '../../../../core/services/services_exports.dart'
    show SmartAdvisorWebService;
import '../../../_shared_feature_/presentation/models/response_body_model.dart';

abstract class SmartAdvisorMapRemoteDataSource {
  Future<List<ZoneItemModel>> getZones(GetZonesRequest params);

  Future<List<ValidatePointResponseModel>> validatePoint(
      ValidatePointRequest params);

  Future<GisDataResponseModel> getGISData(GISDataRequest params);
}

class SmartAdvisorMapRemoteDataSourceImplementation
    implements SmartAdvisorMapRemoteDataSource {
  final SmartAdvisorWebService webService;

  SmartAdvisorMapRemoteDataSourceImplementation({required this.webService});

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
    } on DioError catch (error) {
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
    } on DioError catch (error) {
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
      final response = await webService.dio
          .post(ApiUrls.validatePoint, data: params.toJson());
      print(response.data);
      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      return result
              ?.map<ValidatePointResponseModel>((e) =>
                  ValidatePointResponseModel.fromJson(
                      e as Map<String, dynamic>))
              .toList() ??
          [];
    } on DioError catch (error) {
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
