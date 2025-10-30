import 'dart:io';

import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/classification_certificate/data/model/details/classification_certificate_details_model.dart';
import 'package:balady_plus/app/features/classification_certificate/data/model/lookups/classification_certificate_lookups_model.dart';
import 'package:dio/dio.dart'
    show BaseOptions, Dio, DioException, Options,  ResponseType;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

import '../../core/endpoints.dart';
import '../model/classification_certificate_list.dart';
import '../model/details/details_request_model.dart';
import '../model/lookups/activity_lookups_model.dart';
import '../model/search_request/activities_request_model.dart';
import '../model/search_request/lookups_request_model.dart';
import '../model/search_request/search_request_model.dart';
import 'remote_data_source.dart';

class ClassificationCertificateRemoteDataSource
    implements
        ClassificationCertificateSearchRemoteDataSource,
        ClassificationCertificateDetailsRemoteDataSource,
        ClassificationCertificateLookupsRemoteDataSource {
  final WebService webService;

  ClassificationCertificateRemoteDataSource({required this.webService});

  @override
  Future<ClassificationCertificateLookupsModel> getLookups(
      LookupsRequestModel params) async {
    var response;
    try {
      response = await webService.dio.get(
        EndpointsClassificationCertificate.getLookups,
        queryParameters: params.toJson(),
      );
      final data = response.data;
      var result = data["data"]["result"] as Map<String, dynamic>;
      var parsedResult = ClassificationCertificateLookupsModel.fromJson(result);
      return parsedResult;
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      // "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
        errorCode: error.response?.data['data']?['responseCode'] ?? -1,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      // "Catched $error".errorLog();

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
  Future<List<ActivityLookupsModel>> getActivitiesBySectors(
      ActivitiesRequestModel params) async {
    var response;
    try {
      response = await webService.dio.get(
        EndpointsClassificationCertificate.getActivities(params.sectors),
        queryParameters: params.toJson(),
      );
      final data = response.data;
      List<ActivityLookupsModel> list = List<ActivityLookupsModel>.from(
        data["data"]["result"]['items'].map(
          (x) => ActivityLookupsModel.fromJson(x),
        ),
      );

      return list;
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      // "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
        errorCode: error.response?.data['data']?['responseCode'] ?? -1,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      // "Catched $error".errorLog();

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
  Future<ClassificationCertificateList> searchClassificationCertificate(
      SearchRequestModel params) async {
    var response;
    try {
      response = await webService.dio.get(
        EndpointsClassificationCertificate.searchEndPoints,
        queryParameters: params.toJson(),
      );
      final data = response.data;
      var parsedResult = data != null
          ? ClassificationCertificateList.fromJson(data["data"]["result"])
          : null;
      final decodedResponse =
          ResponseBodyModel<ClassificationCertificateList>.fromMap(
        response.data,
        parsedResult: parsedResult,
      );
      return decodedResponse.data!.result!;
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      // "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
        errorCode: error.response?.data['data']?['responseCode'] ?? -1,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      // "Catched $error".errorLog();

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
  Future<ClassificationCertificateDetails> getDetailsClassificationCertificate(
      DetailsRequestModel params) async {
    var response;
    try {
      response = await webService.dio.get(
        EndpointsClassificationCertificate.getEstablishmentsDetails(
          params.serialNumber,
        ),
        queryParameters: params.toJson(),
      );
      final data = response.data;
      var parsedResult = data != null
          ? ClassificationCertificateDetails.fromJson(
              data["data"]["result"],
            )
          : null;
      final decodedResponse =
          ResponseBodyModel<ClassificationCertificateDetails>.fromMap(
        response.data,
        parsedResult: parsedResult,
      );
      return decodedResponse.data!.result!;
    } on DioException catch (error, stackTrace) {
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
        errorCode: error.response?.data['data']?['responseCode'] ?? -1,
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
          exception: APIException(errorMessage: error.toString()),
          response: response,
        );
      }
    }
  }

  @override
  Future<File> getAttachedClassificationCertificate(
      String attachUrl, String path) async {
    var response;
    try {
      //webService.dio.
      response = await Dio(
        BaseOptions(baseUrl: RemoteConfig.apigeeURL),
      ).get(
        attachUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        File file = File(path);
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response!.data);
        await raf.close();
        return file;
      }
      throw ServerException(
        "errors_server_error_2".tr(),
        statusCode: response.statusCode ,
        errorCode: response.statusCode,
      );
    } on DioException catch (error, stackTrace) {
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
        errorCode: error.response?.statusCode != 500
            ? error.response!.data['data']['responseCode'].toString()
            : "-1",
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
          exception: APIException(errorMessage: error.toString()),
          // response: response,
        );
      }
    }
  }
}
