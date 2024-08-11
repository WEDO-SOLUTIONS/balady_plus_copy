import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/services_exports.dart';
import '../../../../core/utils/constants/apis/api_info.dart';
import '../../../vd/data/model/create_incident/create_incident_response_model.dart';
import '../../domain/entities/vehicle_item_params.dart';
import '../model/create_retrive_car_request.dart';
import '../model/vehicle_response_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class DCRetriveRemoteDataSource {
  Future<ResponseBodyModel<VehicleResponseModel>> getMyVehicles(
      {required VehicleItemParams params});

  Future<ResponseBodyModel<CreateIncidentResponseModel>> createRetriveCar(
      {required CreateRetriveCarRequest params});
}

class DCRetriveRemoteDataSourceImpl extends DCRetriveRemoteDataSource {
  final WebService webService;

  DCRetriveRemoteDataSourceImpl({required this.webService});

  @override
  Future<ResponseBodyModel<VehicleResponseModel>> getMyVehicles(
      {required VehicleItemParams params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.vehicles,
        queryParameters: params.toMap(),
      );

      var data = response.data["data"]["result"];

      var parsedResult =
          data != null ? VehicleResponseModel.fromMap(data) : null;
      final decodedResponse = ResponseBodyModel<VehicleResponseModel>.fromMap(
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
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<VehicleResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
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
          //MM      CommonFunctions.sendExceptionLog(exception:  error, response: response);
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
  Future<ResponseBodyModel<CreateIncidentResponseModel>> createRetriveCar(
      {required CreateRetriveCarRequest params}) async {
    var response;

    try {
      response = await webService.dio.post(
        ApiUrl.vehicleRecovery,
        data: params.toMap(),
      );

      var data = response.data["data"]["result"];

      var parsedResult =
          data != null ? CreateIncidentResponseModel.fromMap(data) : null;
      final decodedResponse =
          ResponseBodyModel<CreateIncidentResponseModel>.fromMap(response.data,
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
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<CreateIncidentResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
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
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }
}
