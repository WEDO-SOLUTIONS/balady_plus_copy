import 'dart:convert';

import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dio/dio.dart' show DioError;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;
import '../../domain/entity/MunicipalityLookUp.dart';
import '../../domain/entity/city_entity.dart';
import '../../domain/entity/observer_status_entity.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

import '../../domain/entity/register_observer_request.dart';

abstract class CertifiedObserverRemoteDataSource {
  Future<ResponseBodyModel<ObserverStatusEntity>> getObserverStatus(
      String identityNumber);

  Future<ResponseBodyModel<List<MunicipalityLookUp>>> getMuncipalityList();

  Future<ResponseBodyModel<bool>> checkMuncipalityAcceptance(String id);

  Future<ResponseBodyModel<List<CityEntity>>> getCityList(
      String municipalityId);

  Future<List<DistrictsEntity>> getDistrictByCityIdList(String cityId);

  Future<bool> registrationObserver(RegisterObserverRequest request);

  Future<Map<String, dynamic>> getAvailabilityOfFreelancerCertificateUser(
      ObserverStatusEntity request);
}

class CertifiedObserverRemoteDataSourceImplementation
    implements CertifiedObserverRemoteDataSource {
  final WebService webService;

  CertifiedObserverRemoteDataSourceImplementation({required this.webService});

  @override
  Future<ResponseBodyModel<ObserverStatusEntity>> getObserverStatus(
      String identityNumber) async {
    var response;
    try {
      response =
          await webService.dio.get(ApiUrl.getObserverStatus(identityNumber));
      final data = response.data;

      var parsedResult = data != null
          ? ObserverStatusEntity.fromJson(data["data"]["result"])
          : null;
      final decodedResponse = ResponseBodyModel<ObserverStatusEntity>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<MunicipalityLookUp>>>
      getMuncipalityList() async {
    var response;
    try {
      response = await webService.dio.get(ApiUrl.getMuncipalitList);
      var data = response.data["data"]?["result"];

      List<MunicipalityLookUp> parsedResult = data != null
          ? List<MunicipalityLookUp>.from(
              data.map((x) => MunicipalityLookUp.fromJson(x)))
          : [];

      final decodedResponse =
          ResponseBodyModel<List<MunicipalityLookUp>>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<ResponseBodyModel<bool>> checkMuncipalityAcceptance(String id) async {
    var response;
    try {
      response =
          await webService.dio.get(ApiUrl.checkMuncipalityAcceptance(id));
      var data = response.data["data"]?["result"];

      bool? parsedResult =
          data != null ? data['RegisterNewCertifiedObservers'] : false;
      final decodedResponse = ResponseBodyModel<bool>.fromMap(response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      var s = error.response?.data["data"];
      throw ServerException(
        error.toString(),
        errorCode: error.response?.data["data"]['responseCode'],
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<CityEntity>>> getCityList(
      String municipalityId) async {
    var response;
    try {
      response =
          await webService.dio.get(ApiUrl.getMuncipalityCites(municipalityId));
      var data = response.data["data"]?["result"];

      List<CityEntity> parsedResult = data != null
          ? List<CityEntity>.from(data.map((x) => CityEntity.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<CityEntity>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<List<DistrictsEntity>> getDistrictByCityIdList(String cityId) async {
    var response;
    try {
      response = await webService.dio.get(
        "${ApiUrl.urlDistrictsList}/$cityId",
      );

      var data = response.data["data"]?["result"];

      List<DistrictsEntity> parsedResult = data != null
          ? List<DistrictsEntity>.from(
              data.map(
                (x) => DistrictsEntity.fromJson(x),
              ),
            )
          : [];

      return parsedResult;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<bool> registrationObserver(RegisterObserverRequest request) async {
    var response;
    try {
      response = await webService.dio
          .post(ApiUrl.registerObserver, data: request.toJson());

      return response.data["data"] != null ? true : false;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<Map<String, dynamic>> getAvailabilityOfFreelancerCertificateUser(
      ObserverStatusEntity request) async {
    var response;
    try {
      response = await webService.dio.post(
        ApiUrl.registerObserver,
        data: request.toJson(),
      );

      return response.data["data"];
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }
}
