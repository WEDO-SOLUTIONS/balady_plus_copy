import 'dart:convert';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mime/mime.dart';
import '../../../../core/base/base_view_model.dart';
import '../../../../core/errors/errors_exports.dart';
import '../../../../core/services/local/helpers.dart';
import '../../../../core/services/services_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../commercial_license_exports.dart';
import '../../domain/entities/cr_submit_request.dart';
import '../../domain/entities/save_shop_details_request.dart';
import '../models/cr_attachment_response_model.dart';
import '../models/cr_submit_response_model.dart';
import '../models/save_com_submitter_and_owner_request_model.dart';
import '../../../../core/remote_services/web_service.dart' as web;

abstract class CrRemoteDataSource {
  Future<ResponseBodyModel<RecordInfoModel>> getRecordInfo(
      {required String crNumber, required String role});
  Future<List<SubActivityModel>> getSubActivities({required String isicCode});
  Future<ResponseBodyModel<SubActivityModelDetailsModel>> getSubActivityDetails(
      {required String subActivityId});
  Future<bool> addIsicActivities({required AddIsicActivitiesParams params});
  Future<List<CrLookupsModel>> getAccommodationTypes();

  Future<int> saveComSubmitterAndOwner(
      {SaveComSubmitterAndOwnerRequestModel? params});

  Future<int> saveActivityDetails({SubmitActivityDetailRequest? params});

  Future<SaveLocationResponseModel> saveLocationDetails(
      {SaveLocationDataRequest? params});

  Future<DeedInfoResponseModel> getDeedInfo({DeedInfoRequest? params});

  Future<EjarInfoResponseModel> getEjarInfo({EjarInfoRequest? params});

  Future<CleanContractsResponseModel> getCleanContracts(
      {CleanContractsRequest? params});

  Future<InvestmentContractResponseModel> getInvestmentContracts(
      {InvestmentContractRequest? params});

  Future<CrAttachmentResponseModel> getCRAttachment({int? params});

  Future<bool> saveAttachment({required CrAttachmentRequest params});
  Future<dynamic> saveShopDetails({required SaveShopDetailsRequest params});

  Future<CrCalculateFeesResponseModel> crCalculateFees(
      {required CrCalculateFeesRequest params});
  Future<int> addBeneficiaryNotes({required CrAddNotesRequest params});

  Future<CrSubmitResponseModel> submitCr({required CrSubmitRequest params});
}

class CrRemoteDataSourceImpl extends CrRemoteDataSource {
  final WebService webService;

  CrRemoteDataSourceImpl({required this.webService});

  @override
  Future<List<CrLookupsModel>> getAccommodationTypes() async {
    var response;

    try {
      response = await webService.dio.get(ApiUrl.accommodationTypesCL);

      var data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<CrLookupsModel>(
              (e) => CrLookupsModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<bool> addIsicActivities(
      {required AddIsicActivitiesParams params}) async {
    var response;

    try {
      response = await webService.dio.post(ApiUrl.addIsicActivities,
          data: params.toJson(),
          options: Options(
            headers: {"sid": ""},
          ));

      final decodedResponse =
          ResponseBodyModel<bool>.fromMap(response.data, parsedResult: true);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error) {
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //MM   CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<ResponseBodyModel<RecordInfoModel>> getRecordInfo(
      {required String crNumber, required String role}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.recordInfo(crNumber: crNumber, role: role),
      );

      var data = response.data["data"]["result"];

      var parsedResult = data != null ? RecordInfoModel.fromJson(data) : null;
      final decodedResponse = ResponseBodyModel<RecordInfoModel>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error) {
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<RecordInfoModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<SubActivityModel>> getSubActivities(
      {required String isicCode}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.subActivities.replaceAll("isicCode", isicCode),
      );

      var data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<SubActivityModel>(
              (e) => SubActivityModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<ResponseBodyModel<SubActivityModelDetailsModel>> getSubActivityDetails(
      {required String subActivityId}) async {
    var response;

    try {
      response =
          await webService.dio.get(ApiUrl.subActivityDetails + subActivityId);

      var data = response.data["data"]["result"];

      var parsedResult =
          data != null ? SubActivityModelDetailsModel.fromJson(data) : null;
      final decodedResponse =
          ResponseBodyModel<SubActivityModelDetailsModel>.fromMap(response.data,
              parsedResult: parsedResult);

      print(decodedResponse);
      return decodedResponse.toFuture();
    } on DioError catch (error) {
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<SubActivityModelDetailsModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      print(ex);
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<int> saveComSubmitterAndOwner(
      {SaveComSubmitterAndOwnerRequestModel? params}) async {
    var response;

    try {
      response = await webService.dio
          .post(ApiUrl.saveComSubmitterAndOwner, data: params?.toMap());

      var data = response.data["data"]?["result"];

      return data["requestNumber"];
    } on DioError catch (error) {
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<SubActivityModelDetailsModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      print(ex);
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<int> saveActivityDetails({SubmitActivityDetailRequest? params}) async {
    var response;

    try {
      response = await webService.dio.post(
          ApiUrl.saveActivityDetails(params!.requestId!),
          data: params.toMap());

      var data = response.data["data"]?["result"];

      return data["requestId"];
    } on DioError catch (error) {
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<dynamic>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      print(ex);
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<SaveLocationResponseModel> saveLocationDetails(
      {SaveLocationDataRequest? params}) async {
    var response;

    try {
      response = await webService.dio.post(
          ApiUrl.saveLocationDetails(params!.requestId!),
          data: params?.toMap());

      var data = response.data["data"]["result"];

      var parsedResult =
          data != null ? SaveLocationResponseModel.fromJson(data) : null;
      final decodedResponse =
          ResponseBodyModel<SaveLocationResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);

      print(decodedResponse);
      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error) {
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<SaveLocationResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      print(ex);
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<CleanContractsResponseModel> getCleanContracts(
      {CleanContractsRequest? params}) async {
    var response;

    try {
      response = await webService.dio
          .post(ApiUrl.cleanContracts(params!.requestId), data: params.toMap());

      var data = response.data["data"];

      var parsedResult =
          data != null ? CleanContractsResponseModel.fromJson(data) : null;
      final decodedResponse =
          ResponseBodyModel<CleanContractsResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error) {
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<CleanContractsResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      print(ex);
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<DeedInfoResponseModel> getDeedInfo({DeedInfoRequest? params}) async {
    var response;

    try {
      response = await webService.dio.get(ApiUrl.deedInfo(params!.hashCode));

      var data = response.data["data"]["result"];

      var parsedResult =
          data != null ? DeedInfoResponseModel.fromJson(data) : null;
      final decodedResponse = ResponseBodyModel<DeedInfoResponseModel>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error) {
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<DeedInfoResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      print(ex);
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<EjarInfoResponseModel> getEjarInfo({EjarInfoRequest? params}) async {
    var response;

    try {
      response =
          await webService.dio.post(ApiUrl.ejarInfo, data: params?.toMap());

      var data = response.data["data"]["result"];

      var parsedResult =
          data != null ? EjarInfoResponseModel.fromJson(data) : null;
      final decodedResponse = ResponseBodyModel<EjarInfoResponseModel>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error) {
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<EjarInfoResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      print(ex);
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<InvestmentContractResponseModel> getInvestmentContracts(
      {InvestmentContractRequest? params}) async {
    var response;

    try {
      response = await webService.dio.get(
          ApiUrl.investmentContracts(params!.requestId),
          data: params.toMap());

      var data = response.data["data"];

      var parsedResult =
          data != null ? InvestmentContractResponseModel.fromJson(data) : null;
      final decodedResponse =
          ResponseBodyModel<InvestmentContractResponseModel>.fromMap(
              response.data,
              parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error) {
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<InvestmentContractResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      print(ex);
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<CrAttachmentResponseModel> getCRAttachment({int? params}) async {
    var response;

    try {
      response = await webService.dio.get(ApiUrl.crIssueAttachments(params!));

      var data = response.data["data"];

      var parsedResult =
          data != null ? CrAttachmentResponseModel.fromMap(data) : null;
      final decodedResponse =
          ResponseBodyModel<CrAttachmentResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error) {
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<CrAttachmentResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      print(ex);
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<bool> saveAttachment({required CrAttachmentRequest params}) async {
    final mimeType = lookupMimeType(params.data?.filePath ?? "");

    final body = await locator<web.WebService>().uploadFileSSO(
      ApiUrl.crAttachment(params.requestId!, params.data!.id!),
      base64: base64Decode(params.data?.base64 ?? ""),
      fileName: params.data?.fileName,
      mimeType: mimeType,
    );
    ;
    bool state = body['state'];
    dynamic data = body['data'];
    String error = body['error'] ?? ("errors_server_error_1").tr();

    try {
      if (state == true) {
        return true;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: data,
          ),
        );
      }
    } catch (ex) {
      print(ex);
      try {
        Helpers.sendLog(
            url: ApiUrl.complianceAttachment(
                params.requestId.toString(), params.data!.id),
            data: data,
            errorMsg: ex.toString());
      } catch (ex) {}

      throw ServerException(
        "errors_server_error_2".tr(),
        exception: APIException(
          errorMessage: ex.toString(),
        ),
      );
    }
  }

  @override
  Future<CrCalculateFeesResponseModel> crCalculateFees(
      {required CrCalculateFeesRequest params}) async {
    var response;

    try {
      response = await webService.dio.post(
          ApiUrl.crCalculateFess(
            params.requestId!,
          ),
          data: params.toMap());

      var data = response.data["data"];

      var parsedResult =
          data != null ? CrCalculateFeesResponseModel.fromJson(data) : null;
      final decodedResponse =
          ResponseBodyModel<CrCalculateFeesResponseModel>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error) {
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<CrCalculateFeesResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      print(ex);
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<int> addBeneficiaryNotes({required CrAddNotesRequest params}) async {
    var response;

    try {
      response = await webService.dio.post(
          ApiUrl.addBeneficiaryNotes(
            params.requestId!,
          ),
          data: params.toMap());

      final decodedResponse =
          ResponseBodyModel<int>.fromMap(response.data, parsedResult: null);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error) {
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<CrCalculateFeesResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      print(ex);
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<CrSubmitResponseModel> submitCr(
      {required CrSubmitRequest params}) async {
    var response;

    try {
      response = await webService.dio.post(
          ApiUrl.crSubmit(
            params.requestId!,
          ),
          data: params.toMap());

      final decodedResponse = ResponseBodyModel<CrSubmitResponseModel>.fromMap(
          response.data,
          parsedResult: null);

      return decodedResponse.data!.result!.toFuture();
    } on DioError catch (error) {
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<CrCalculateFeesResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      print(ex);
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future saveShopDetails({required SaveShopDetailsRequest params}) async {
    var response;

    try {
      response = await webService.dio.post(
          ApiUrl.saveShopDetails(
            params.requestId!,
          ),
          data: params.toMap());

      final decodedResponse =
          ResponseBodyModel<dynamic>.fromMap(response.data, parsedResult: null);

      return null;
    } on DioError catch (error) {
      print(error);
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<dynamic>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      print(ex);
      if (ex is ServerException)
        throw ex;
      else {
        try {
          //MM    CommonFunctions.sendExceptionLog(exception: ex, response: response);
        } catch (ex) {}
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }
}
