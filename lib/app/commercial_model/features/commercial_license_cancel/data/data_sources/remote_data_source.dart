import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:dio/dio.dart' show DioError;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/commercial_model/commercial_model_end_points.dart';

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
    var response;
    try {
      response = await webService.dio.get(
        CommercialModelEndPoints.getCommercialLicenseDetails(commercialLicenseId),
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      CommercialLicenceDetails commercialLicenceDetails =
          CommercialLicenceDetails.fromJson(result!);
      return commercialLicenceDetails;
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

// @override
// Future<List<CommercialLicenseDetailsModel>> getInvoiceStatuses() async {
//   var response;
//
//   try {
//     response = await webService.dio.get(
//       CommercialModelEndPoints.invoiceStatuses,
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
//   } on DioError catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//     "DioError $error".errorLog();
//     if (error is NoDataFoundException) {
//       rethrow;
//     }
//     throw ServerException(
//       error.toString(),
//       statusCode: error.response?.statusCode,
//       dioError: error,
//     );
//   } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//     "Catched $error".errorLog();
//     if (error is ServerException) {
//       rethrow;
//     } else {
//       throw ServerException("errors_server_error_2".tr(),
//           exception: APIException(
//             errorMessage: error.toString(),
//           ),
//           response: response);
//     }
//   }
// }
}
