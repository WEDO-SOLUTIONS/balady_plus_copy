import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/data/models/commercial_licence_details.dart';
import 'package:dio/dio.dart' show DioError, DioException, Options;
import 'package:dio/src/response.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';

abstract class RequestOwnershipTransferDetailsRemoteDataSource {
  Future<CommercialLicenceDetails> getRequestOwnershipTransferDetails(
    String requestLicenseId,
  );
  Future<bool> acceptCommercialRequestTransfer(
    String requestLicenseId,
  );
  Future<bool> rejectCommercialRequestTransfer(
    String requestLicenseId,
  );
}

class RequestOwnershipTransferRemoteDataSourceImplementation
    implements RequestOwnershipTransferDetailsRemoteDataSource {
  final WebService webService;

  RequestOwnershipTransferRemoteDataSourceImplementation(
      {required this.webService});

  @override
  Future<CommercialLicenceDetails> getRequestOwnershipTransferDetails(
      String commercialRequestId) async {
    Response? response;
    try {
      response = await webService.dio.get(
        ApiUrl.getOwnershipCommercialRequestDetails(
            int.parse(commercialRequestId)),
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      return CommercialLicenceDetails.fromJson(result!);
    } on Exception catch (exception) {
      CommonFunctions.sendEvent(
        dioError: exception is DioException ? exception : null,
        response: response,
        ex: exception,
      );
      throw ServerException(exception.toString(),
          exception: APIException(),
          response: response);
    } catch (exception) {
      CommonFunctions.sendEvent(
        dioError: null,
        response: response,
        ex: Exception(exception.toString()),
      );
      throw ServerException(exception.toString(),
          exception: APIException(),
          response: response);
    }
  }

  @override
  Future<bool> acceptCommercialRequestTransfer(
      String commercialRequestId) async {
    Response? response;
    try {
      response = await webService.dio.post(
          ApiUrl.acceptCommercialRequestTransfer(
              int.parse(commercialRequestId)));
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).statusDetails!.code;
      if (result == 200) {
        return true;
      } else {
        return false;
      }
    } on ServerException catch (exception) {
      CommonFunctions.sendEvent(
        dioError: null,
        response: response,
        ex: exception,
      );

      throw ServerException(exception.toString(),
          exception: APIException(),
          response: response);

    } catch (exception) {
      CommonFunctions.sendEvent(
        dioError: null,
        response: response,
        ex: Exception(exception.toString()),
      );

      throw ServerException(exception.toString(),
          exception: APIException(),
          response: response);



  }


  }

  @override
  Future<bool> rejectCommercialRequestTransfer(
      String commercialRequestId) async {
    Response? response;
    try {
      response = await webService.dio.post(
          ApiUrl.rejectCommercialRequestTransfer(
              int.parse(commercialRequestId)));
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).statusDetails!.code;
      if (result == 200) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (exception) {
      CommonFunctions.sendEvent(
        dioError: exception is DioException ? exception : null,
        response: response,
        ex: exception,
      );
      throw ServerException(exception.toString(),
          exception: APIException(),
          response: response);
    } catch (exception) {
      CommonFunctions.sendEvent(
        dioError: null,
        response: response,
        ex: Exception(exception.toString()),
      );
      throw ServerException(exception.toString(),
          exception: APIException(),
          response: response);
    }
  }

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
}
