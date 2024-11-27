import 'dart:convert';
import 'package:balady_plus/app/core/errors/errors_exports.dart' as balday;
import 'package:balady_plus/app/core/errors/failures.dart' ;
import 'package:http_parser/http_parser.dart';

import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/utils/extensions/json_conversion.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/data/models/bidding_type/bidding_type_response_model.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/data/models/form_data_response_model.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/data/models/offers/offers_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/data/models/submit/submit_form_response_model.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/data/models/validate/validate_form_response_model.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_type/bidding_type_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/get_data_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/offers/get_offers_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/submit/submit_form_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/validate/validate_form_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/dynamic_forms_exports.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/remote_services/pega_web_service.dart' as web;

import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    as EtmamCommonProperties hide Log;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse, ApigeeResponseModel;

import 'package:dio/dio.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show APIException, ServerException;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show ApiUrl, ApiParams, WithDelay;
import 'package:mime/mime.dart';

import '../../../../../app/core/base/base_view_model.dart';
import '../../../../../app/core/services/global/web_service.dart';
import '../../../../../app/core/utils/common_functions.dart'
    show CommonProperties;
import '../../../../../app/features/_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../../app/features/_shared_feature_/data/models/drop_down_item_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class DynamicFormRemoteDataSource {
  Future<ApigeeResponse<List<CreateFormItemResponseModel>>> createForm(
      {required CreateFormParams params});

  Future<ApigeeResponse<List<DropDownItem>>> getFormFieldData(
      {required GetDataParams params});

  Future<ApigeeResponse<List<BiddingTypeResponse>>> findByRequestType();

  Future<ApigeeResponse<SubmitFormResponseModel>> submitForm(
      SubmitFormParams params);

  Future<ApigeeResponse<ValidateFormResponseModel>> validateForm(
      {required ValidateFormParams params});

  Future<ApigeeResponse<FormDataResponseModel>> getFormData(
      {required String paramas});

  Future<ApigeeResponse<OffersResponseModel>> getOffers(
      {required GetOffersParams paramas});

  Future<ApigeeResponse<dynamic>> acceptOffer({required String paramas});

  Future<ApigeeResponse<dynamic>> rejectOffer({required String paramas});

  Future<ApigeeResponse<dynamic>> submitOrder({required String paramas});

  Future<ApigeeResponse<dynamic>> cancelRequest({required String paramas});

  Future<ApigeeResponse<CreateFormItemResponseModel>> getEditFormData(
      {required String paramas});

  Future<ApigeeResponse<SubmitFormResponseModel>> editForm(
      SubmitFormParams params);

  Future<ApigeeResponse<UploadBidAttachmentResponseModel>> uploadBidAttachment(
      UploadBidAttachment params);
}

class DynamicFormRemoteDataSourceImpl extends DynamicFormRemoteDataSource {
  final WebService webService;

  DynamicFormRemoteDataSourceImpl({required this.webService});

  @override
  Future<ApigeeResponse<List<CreateFormItemResponseModel>>> createForm(
      {required CreateFormParams params}) async {
    var response;
    print("HEREEEE");
    try {
      response = await webService.dio.post(ApiUrl.createDynamicForm,
          data: params.toMap(),
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));
      print(response.data["data"]);
      List<CreateFormItemResponseModel>? list = params.services
          ?.map((e) => CreateFormItemResponseModel.fromJson(
              response.data["data"]?["result"][e]))
          .toList();

      /* List<CreateFormItemResponseModel>.from(
          response.data["data"]?["result"].map((x) => x));

      var parsedResult =
          data != null ? CreateFormItemResponseModel.fromJson(data) : null;
     */

      final decodedResponse =
          ApigeeResponseModel<List<CreateFormItemResponseModel>>.fromMap(
              response.data,
              parsedResult: list);

      if (response.statusCode != 200) {
        String errorMessage = decodedResponse.data?.responseMessage ??
            decodedResponse.statusDetails?.message ??
            trans("errors_server_error_1");
        throw ServerException(
          errorMessage,
          statusCode: response.statusCode,
        );
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
        dioError: error,
        statusCode: error.response?.statusCode,
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
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse<List<DropDownItem>>> getFormFieldData(
      {required GetDataParams params}) async {
    var response;
    print("HEREEEE");
    print("${ApiUrl.getFormFieldsData}/${params.fieldId}");
    try {

      response = await webService.dio.post(
          "${ApiUrl.getFormFieldsData}/${params.fieldId}",
          data: params.toMap(),
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data["data"]?["result"]?["items"];

      List<DropDownItem>? list = List<DropDownItem>.from(
          data.map((x) => DropDownItemModel.fromMap(x)));

      final decodedResponse = ApigeeResponseModel<List<DropDownItem>>.fromMap(
          response.data,
          parsedResult: list);

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

      print(error);
      if( error is balday.NoInternetConnectionException){
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
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse<List<BiddingTypeResponse>>> findByRequestType() async {
    var response;
    try {
      response = await webService.dio.get(ApiUrl.findByRequestType,
          queryParameters: {
            "city-id": EtmamCommonProperties.CommonProperties.cityId
          },
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data["data"]?["result"];

      var parsedResult = data != null
          ? List<dynamic>.from(data)
              .map((e) => BiddingTypeResponseModel.fromMap(e))
              .toList()
          : null;

      final decodedResponse =
          ApigeeResponseModel<List<BiddingTypeResponse>>.fromMap(response.data,
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
      var errorCode;
      try {
        final decodedResponse =
            ApigeeResponseModel<List<BiddingTypeResponse>>.fromMap(
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
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse<SubmitFormResponseModel>> submitForm(
      SubmitFormParams params) async {
    var response;
    try {
      response = await webService.dio.post(ApiUrl.submitBiddingForm,
          data: params.toMap(),
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data["data"];

      var parsedResult =
          data != null ? SubmitFormResponseModel.fromMap(data) : null;

      print(data);
      final decodedResponse =
          ApigeeResponseModel<SubmitFormResponseModel>.fromMap(response.data,
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
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse<ValidateFormResponseModel>> validateForm(
      {required ValidateFormParams params}) async {
    var response;
    try {
      response = await webService.dio.post(
          "${ApiUrl.validateBiddingForm}${params.formId}",
          data: params.toMap(),
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data;
      print("HEREEE22");
      var parsedResult =
          data != null ? ValidateFormResponseModel.fromJson(data) : null;
      parsedResult!.isSuccess = true;
      print("HEREEE");
      print(parsedResult);
      final decodedResponse =
          ApigeeResponseModel<ValidateFormResponseModel>.fromMap(response.data,
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
      var data = error.response?.data;

      if (data != null) {
        var parsedResult =
            data != null ? ValidateFormResponseModel.fromJson(data) : null;
        print(data);
        final decodedResponse =
            ApigeeResponseModel<ValidateFormResponseModel>.fromMap(data,
                parsedResult: parsedResult);

        return decodedResponse.toFuture();
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
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse<FormDataResponseModel>> getFormData(
      {required String paramas}) async {
    var response;
    print("HEREEEE");
    try {
      response = await webService.dio.get("${ApiUrl.viewFormData}/$paramas",
          queryParameters: {
            ApiParams.profileId: sl<EtmamEntryPointCubit>().state.profile?.id
          },
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));
      print(response.data["data"]);
      var parsedResult =
          FormDataResponseModel.fromJson(response.data["data"]?["result"]);

      final decodedResponse =
          ApigeeResponseModel<FormDataResponseModel>.fromMap(response.data,
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
      print(error);
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
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse<OffersResponseModel>> getOffers(
      {required GetOffersParams paramas}) async {
    var response;
    try {
      response = await webService.dio.get(
          "${ApiUrl.getOffers}/${paramas.requestId}",
          queryParameters: {
            ApiParams.profileId: sl<EtmamEntryPointCubit>().state.profile?.id,
            if (paramas.status != "accepted") "status": paramas.status,
            if (paramas.status == "accepted") "accepted": true
          },
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));
      print(response.data["data"]);
      var parsedResult =
          OffersResponseModel.fromJson(response.data["data"]?["result"]);

      final decodedResponse = ApigeeResponseModel<OffersResponseModel>.fromMap(
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
      var errorCode;
      try {
        final decodedResponse =
            ApigeeResponseModel<OffersResponseModel>.fromMap(
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
        statusCode: error.response?.statusCode,
        errorCode: errorCode,
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
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse> acceptOffer({required String paramas}) async {
    var response;
    try {
      response = await webService.dio.put("${ApiUrl.acceptOffers}/${paramas}",
          queryParameters: {
            ApiParams.profileId: sl<EtmamEntryPointCubit>().state.profile?.id
          },
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));
      print(response.data["data"]);

      final decodedResponse =
          ApigeeResponseModel<dynamic>.fromMap(response.data);

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
      print(error);
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
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse> rejectOffer({required String paramas}) async {
    var response;
    try {
      response = await webService.dio.put("${ApiUrl.rejectOffers}/${paramas}",
          queryParameters: {
            ApiParams.profileId: sl<EtmamEntryPointCubit>().state.profile?.id
          },
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));
      print(response.data["data"]);

      final decodedResponse =
          ApigeeResponseModel<dynamic>.fromMap(response.data);

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
      print(error);
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
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse> submitOrder({required String paramas}) async {
    var response;
    try {
      response = await webService.dio.post("${ApiUrl.submitOrder}/${paramas}",
          queryParameters: {
            ApiParams.profileId: sl<EtmamEntryPointCubit>().state.profile?.id
          },
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));
      print(response.data["data"]);

      final decodedResponse =
          ApigeeResponseModel<dynamic>.fromMap(response.data);

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
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
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
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse> cancelRequest({required String paramas}) async {
    var response;
    try {
      response = await webService.dio.put("${ApiUrl.cancelRequest}/${paramas}",
          data: {},
          queryParameters: {
            ApiParams.profileId: sl<EtmamEntryPointCubit>().state.profile?.id
          },
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));
      print(response.data["data"]);

      final decodedResponse =
          ApigeeResponseModel<dynamic>.fromMap(response.data);

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
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
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
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse<CreateFormItemResponseModel>> getEditFormData(
      {required String paramas}) async {
    var response;
    print("HEREEEE");
    try {
      response = await webService.dio.get("${ApiUrl.viewEditFormData}/$paramas",
          queryParameters: {
            ApiParams.profileId: sl<EtmamEntryPointCubit>().state.profile?.id
          },
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));
      print(response.data["data"]);
      var parsedResult = CreateFormItemResponseModel.fromJson(
          response.data["data"]?["result"]);

      final decodedResponse =
          ApigeeResponseModel<CreateFormItemResponseModel>.fromMap(
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
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
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
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse<SubmitFormResponseModel>> editForm(
      SubmitFormParams params) async {
    var response;
    try {
      response = await webService.dio.put(ApiUrl.editBiddingForm,
          data: params.toEditMap(),
          options: Options(headers: {
            "Authorization": "Bearer " + (CommonProperties.token ?? "")
          }));

      var data = response.data["data"];

      var parsedResult =
          data != null ? SubmitFormResponseModel.fromMap(data) : null;

      print(data);
      final decodedResponse =
          ApigeeResponseModel<SubmitFormResponseModel>.fromMap(response.data,
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
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
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
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }

  @override
  Future<ApigeeResponse<UploadBidAttachmentResponseModel>> uploadBidAttachment(
      UploadBidAttachment params) async {
    final mimeType = lookupMimeType(params.filePath);

    String fileName = params.filePath.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(params.filePath,
          filename: fileName, contentType: MediaType.parse(mimeType!)),
      'request-type-id': params.requestTypeId,
      'attachment-type-id': params.attachmentTypeId,
    });
    try {
      print("HEREEEE");
      var response = await webService.dio.post(ApiUrl.bidAttachments,
          data: formData,
          options: Options(headers: {
            'fileContentType': mimeType ?? "",
            'authorization': 'Bearer ${CommonProperties.token}',
            'x-channel-id': "MOBILE",
            ApiHeaders.xCorrelationId: CommonFunctions.generateGUID(),
            /* "x-sso-session-id":
                EtmamCommonProperties.CommonProperties.sessionId ??
                    CommonFunctions.generateGUID(),*/
            "Accept-Language": translator.activeLanguageCode,
            'Content-Type': 'multipart/form-data'
          }));
      print("HEREEE 3333");

      var data = response.data["data"];

      var parsedResult = data != null
          ? UploadBidAttachmentResponseModel.fromJson(data["result"])
          : null;

      print(data);
      final decodedResponse =
          ApigeeResponseModel<UploadBidAttachmentResponseModel>.fromMap(
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
      print(error);
      print(error);
      throw ServerException(error.toString(),
          statusCode: error.response?.statusCode, dioError: error);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {
          CommonFunctions.sendExceptionLog(
            exception:  error,
          );
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException(trans("errors_server_error_2"));
      }
    }
  }
}
