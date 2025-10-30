import 'dart:async';
import 'dart:core';

import 'package:balady_plus/app/core/utils/utils_exports.dart' show WithDelay;
import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show
        CategoryResponseModel,
        CategoryParams,
        SplResponseModel,
        SplParams,
        SPLDetailsParams,
        GISParams,
        GISResponseModel,
        SPLDetailsResponseModel,
        UploadFileResponseModel,
        UploadFileParams,
        OTPResponseModel,
        OTPParams,
        CreateIncidentParams,
        CreateIncidentResponseModel;
import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/services_exports.dart'
    show WebService;
import 'package:balady_plus/app/core/utils/common_functions.dart';

import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/apis/api_info.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class VDRemoteDataSource {
  Future<CategoryResponseModel> getCatgories({required CategoryParams params});

  Future<SplResponseModel> getSpecialClassifications(
      {required SplParams params});

  Future<GISResponseModel> getGISData({required GISParams params});

  Future<SPLDetailsResponseModel> getSPLDetails(
      {required SPLDetailsParams params});

  Future<UploadFileResponseModel> uploadFile(
      {required UploadFileParams params});
  Future<OTPResponseModel> getOTP({required OTPParams params});

  Future<ResponseBodyModel<CreateIncidentResponseModel>>
      createIncidentUnRegistered({required CreateIncidentParams params});

  Future<ResponseBodyModel<CreateIncidentResponseModel>>
      createIncidentRegistered({required CreateIncidentParams params});

  Future<bool> checkCR({required String params});
}

class VDRemoteDataSourceImpl extends VDRemoteDataSource {
  final WebService webService;

  VDRemoteDataSourceImpl({required this.webService});

  @override
  Future<CategoryResponseModel> getCatgories(
      {required CategoryParams params}) async {
    var response;
    String categoriesAPI = ApiUrl.vdCategories;

    if (CommonProperties.isLoggedInMunicipality) {
      categoriesAPI = ApiUrl.vdCategoriesRegistered;
    }

    try {
      response = await webService.dio.get(categoriesAPI,
          queryParameters: params.toMap(),
          options: Options(headers: {
            if (CommonProperties.isLoggedInMunicipality)
              "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data["data"]?["result"];

      final decodedResponse = CategoryResponseModel.fromMap(data);

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
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<SplResponseModel> getSpecialClassifications(
      {required SplParams params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.vdSpecialClassifications,
        queryParameters: params.toMap(),
      );

      var data = response.data["data"];
      final decodedResponse = SplResponseModel.fromMap(data);

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
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<GISResponseModel> getGISData({required GISParams params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.gis,
        queryParameters: params.toMap(),
      );

      var data = response.data["data"]["result"];

      final decodedResponse = GISResponseModel.fromMap(data);

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
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<SPLDetailsResponseModel> getSPLDetails(
      {required SPLDetailsParams params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.vdSpecialClassificationDetails,
        queryParameters: params.toMap(),
      );

      var data =
          response.data["data"]["result"]["specialClassificationDetails"];
      var parsedResult =
          data != null ? SPLDetailsResponseModel.fromJson(data) : null;
      final decodedResponse = SPLDetailsResponseModel.fromJson(data);

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
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<UploadFileResponseModel> uploadFile(
      {required UploadFileParams params}) async {
    var response;

    try {
      response = await webService.dio.post(
        ApiUrl.vdUploadFile,
        data: params.toVDMap(),
      );

      var data = response.data["data"]["result"];

      final decodedResponse = UploadFileResponseModel.fromMap(data);

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
          //MM     CommonFunctions.sendExceptionLog(exception:  error, response: response);
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
  Future<OTPResponseModel> getOTP({required OTPParams params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.getOTP,
        queryParameters: params.toMap(),
      );

      var data = response.data["data"]["result"];

      final decodedResponse = OTPResponseModel.fromMap(data);

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
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
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
  Future<ResponseBodyModel<CreateIncidentResponseModel>>
      createIncidentRegistered({required CreateIncidentParams params}) async {
    var response;

    try {
      response = await webService.dio.post(ApiUrl.createIncidentRegistered,
          data: params.toMap(),
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

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
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
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
  Future<ResponseBodyModel<CreateIncidentResponseModel>>
      createIncidentUnRegistered({required CreateIncidentParams params}) async {
    var response;

    try {
      response = await webService.dio.post(ApiUrl.createIncidentUnRegistered,
          data: params.toMap(isGuest: !CommonProperties.isLoggedInMunicipality));

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
        try {
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
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
  Future<bool> checkCR({required String params}) async {
    var response;

    try {
      response = await webService.dio.get(
        "${ApiUrl.vdCrExists}/$params",
      );

      var data = response.data["data"]["result"];

      return data;
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
          //MM    CommonFunctions.sendExceptionLog(exception:  error, response: response);
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
