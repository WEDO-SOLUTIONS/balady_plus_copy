import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/data/models/commercial_license_details_model.dart';
import 'package:dio/dio.dart' show DioError, Options;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/commercial_model/commercial_model_end_points.dart';

abstract class RequestCommercialLicenseDetailsRemoteDataSource {
  Future<RequestCommercialLicenseDetailsModel>
      getRequestCommercialLicenseDetails(
    int requestId,
  );
}

class RequestCommercialLicenseDetailsRemoteDataSourceImplementation
    implements RequestCommercialLicenseDetailsRemoteDataSource {
  final WebService webService;

  RequestCommercialLicenseDetailsRemoteDataSourceImplementation(
      {required this.webService});

  @override
  Future<RequestCommercialLicenseDetailsModel>
      getRequestCommercialLicenseDetails(int requestId) async {
    var response;
    try {
      response = await webService.dio
          .get(CommercialModelEndPoints.getRequestCommercialLicenseDetails(requestId),
              options: Options(headers: {
                'x-channel-id': 'mobile',
              }));
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      return RequestCommercialLicenseDetailsModel.fromJson(result!);
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
      print(error);
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
