import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';

import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

abstract class CommercialLicenseDetailsRemoteDataSource {
  Future<CommercialLicenceDetails> getCommercialLicenseDetails(
    int commercialLicenseId,
  );
}

class CommercialLicenseDetailsRemoteDataSourceImplementation
    implements CommercialLicenseDetailsRemoteDataSource {
  final WebService webService;

  CommercialLicenseDetailsRemoteDataSourceImplementation(
      {required this.webService});

  @override
  Future<CommercialLicenceDetails> getCommercialLicenseDetails(
      int commercialLicenseId) async {
    Response? response;
    try {
      response = await webService.dio.get(
        ApiUrl.getCommercialLicenseDetails(commercialLicenseId),
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      return CommercialLicenceDetails.fromJson(result!);
    } on DioError catch (error) {
      // "DioError $error".errorLog();
      // if (error is NoDataFoundException) {
      //   rethrow;
      // }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      throw ServerException(
        "errors_server_error_2".tr(),
        exception: APIException(
          errorMessage: ex.toString(),
        ),
        response: response,
      );
    }
  }
}

// on Exception catch (exception) {
//   CommonFunctions.sendEvent(
//     dioError: exception is DioException ? exception : null,
//     response: response,
//     ex: exception,
//   );
//
//   throw ServerException(exception.toString());
//
// } catch (exception) {
//   CommonFunctions.sendEvent(
//     dioError: null,
//     response: response,
//     ex: Exception(exception.toString()),
//   );
//   throw ServerException(exception.toString());
// }
//}

// @override
// Future<List<CommercialLicenseDetailsModel>> getInvoiceStatuses() async {
//   var response;
//
//   try {
//     response = await webService.dio.get(
//       ApiUrl.invoiceStatuses,
//     );
//
//     final data = response.data;
//     data.toString().successLog();
//
//     final result = ResponseBodyModel.fromMap(data).data?.result;
//
//     return result
//         .map<InvoiceStatusModel>(
//             (e) => InvoiceStatusModel.fromMap(e as Map<String, dynamic>))
//         .toList();
//   } on DioError catch (error) {
//     "DioError $error".errorLog();
//     if (error is NoDataFoundException) {
//       rethrow;
//     }
//     throw ServerException(
//       error.toString(),
//       statusCode: error.response?.statusCode,
//       dioError: error,
//     );
//   } catch (ex) {
//     "Catched $ex".errorLog();
//     if (ex is ServerException) {
//       rethrow;
//     } else {
//       throw ServerException("errors_server_error_2".tr(),
//           exception: APIException(
//             errorMessage: ex.toString(),
//           ),
//           response: response);
//     }
//   }
// }
