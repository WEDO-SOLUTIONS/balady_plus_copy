import '/app/core/utils/constants/apis/apis_get.dart';
import 'package:dio/dio.dart' show DioError;
import '/app/core/utils/constants/language.dart';

import '../../../../core/errors/errors_exports.dart' show ServerException;
import '../../../../core/services/services_exports.dart'
    show SmartAdvisorWebService;
import '../../../_shared_feature_/presentation/models/response_body_model.dart';
import '../models/qr_license_details_response_model.dart';

abstract class QrScanRemoteDataSource {
  Future<QrDetailsResponse> getQrData(String params);
}

class QrScanRemoteDataSourceImplementation implements QrScanRemoteDataSource {
  final SmartAdvisorWebService webService;

  QrScanRemoteDataSourceImplementation({required this.webService});

  @override
  Future<QrDetailsResponse> getQrData(String params) async {
    try {
      final response = await webService.dio.get(
        ApiUrls.getQR(params),
      );

      final result = ResponseBodyModel<QrDetailsResponse>.fromMap(response.data,
              parsedResult:
                  QrDetailsResponse.fromJson(response.data["data"]["result"]))
          .data
          ?.result;

      return result!;
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
