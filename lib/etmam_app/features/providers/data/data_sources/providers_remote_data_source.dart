import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse, ApigeeResponseModel, ProvidersResponseModel;

import 'package:dio/dio.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show APIException, ServerException;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show ApiUrl, ApiParams, WithDelay;
import 'package:balady_plus/etmam_app/features/providers/providers_exports.dart'
    show ProviderParams, ProviderDetailsParams, ProviderDetailsResponseModel;
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../app/core/dependency_injection/injection_container.dart';
import '../../../etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class ProvidersRemoteDataSource {
  Future<ApigeeResponse<ProvidersResponseModel>> getProviders(
      {required ProviderParams params});
  Future<ApigeeResponse<ProviderDetailsResponseModel>> getProviderDetails(
      {required ProviderDetailsParams params});
}

class ProvidersRemoteDataSourceImpl extends ProvidersRemoteDataSource {
  final WebService webService;

  ProvidersRemoteDataSourceImpl({required this.webService});

  @override
  Future<ApigeeResponse<ProvidersResponseModel>> getProviders(
      {required ProviderParams params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.topOrderedServiceProviders,
        queryParameters: {
          ApiParams.cityId: params.cityId,
          ApiParams.maxCount: params.pageIndex,
          "classification-id": sl<EtmamEntryPointCubit>().classificationId
        },
      );

      var data = response.data["data"]?["result"];

      var parsedResult =
          data != null ? ProvidersResponseModel.fromMap(data) : null;
      final decodedResponse =
          ApigeeResponseModel<ProvidersResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);

      if (response.statusCode != 200) {
        String errorMessage = decodedResponse.data?.responseMessage ??
            decodedResponse.statusDetails?.message ??
            trans("errors_server_error_1");
        throw ServerException(errorMessage, statusCode: response.statusCode);
      }

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      final decodedResponse =
          ApigeeResponseModel<ProvidersResponseModel>.fromMap(
              error.response?.data,
              parsedResult: null);

      String? errorMessage =
          decodedResponse.data?.responseCode == "2" ? "no_data".tr() : null;
      print("HEREEEEEEEE11111");
      throw ServerException(
        errorMessage ?? error.toString(),
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
      if (error is ServerException)
        throw error;
      else {
        try {
          CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<ApigeeResponse<ProviderDetailsResponseModel>> getProviderDetails(
      {required ProviderDetailsParams params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.providers + params.providerId,
        queryParameters: {
          ApiParams.cityId: params.cityId,
        },
      );

      var data = response.data["data"]?["result"];

      var parsedResult =
          data != null ? ProviderDetailsResponseModel.fromMap(data) : null;
      final decodedResponse =
          ApigeeResponseModel<ProviderDetailsResponseModel>.fromMap(
              response.data,
              parsedResult: parsedResult);

      if (response.statusCode != 200) {
        String errorMessage = decodedResponse.data?.responseMessage ??
            decodedResponse.statusDetails?.message ??
            trans("errors_server_error_1");
        throw ServerException(errorMessage, statusCode: response.statusCode);
      }

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
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
      if (error is ServerException)
        throw error;
      else {
        try {
          CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }
}
