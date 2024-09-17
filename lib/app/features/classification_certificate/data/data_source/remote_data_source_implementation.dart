import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/classification_certificate/data/model/details/classification_certificate_details_model.dart';
import 'package:dio/dio.dart' show DioError;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

import '../../core/endpoints.dart';
import '../model/classification_certificate_list.dart';
import '../model/details/details_request_model.dart';
import '../model/search_request/search_request_model.dart';
import 'remote_data_source.dart';

class ClassificationCertificateRemoteDataSource
    implements
        ClassificationCertificateSearchRemoteDataSource,
        ClassificationCertificateDetailsRemoteDataSource {
  final WebService webService;

  ClassificationCertificateRemoteDataSource({required this.webService});

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
    } on DioError catch (error, stackTrace) {
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
