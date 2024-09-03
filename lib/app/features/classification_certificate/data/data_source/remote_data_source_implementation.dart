
import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dio/dio.dart' show DioError;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

import '../model/classification_certificate_details_model.dart';
import 'remote_data_source.dart';

class ClassificationCertificateRemoteDataSource implements ClassificationCertificateSearchRemoteDataSource {
  final WebService webService;

  ClassificationCertificateRemoteDataSource(
      {required this.webService});

  @override
  Future<ClassificationCertificateDetailsModel> searchClassificationCertificate(
      int licenseNumber, String date) async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.getConstructionLicenseData(licenseNumber, date),
      );
      final data = response.data;

      var parsedResult = data != null
          ? ClassificationCertificateDetailsModel.fromJson(data["data"]["result"])
          : null;
      final decodedResponse =
          ResponseBodyModel<ClassificationCertificateDetailsModel>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.data!.result!;

      // final result = ResponseBodyModel.fromMap(data).data?.result;
      // CommercialLicenseDataModel commercialLicencedata = CommercialLicenseDataModel.fromJson(result!);
      // return  commercialLicencedata;
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
}
