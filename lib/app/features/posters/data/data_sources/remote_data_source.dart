import 'dart:convert';

import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/extensions/log.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/posters/data/models/permits_alerts_response.dart';
import 'package:balady_plus/app/features/posters/data/models/posters_upload_response_model.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mime/mime.dart';
import '../../../../core/remote_services/web_service.dart' as web;

import '../../../../core/base/base_view_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/apis/api_info.dart';
import '../../domain/entities/permit_apply_group_request_params.dart';
import '../../domain/entities/permit_licenses_requests_params.dart';
import '../../domain/entities/permit_required_types_params.dart';
import '../../domain/entities/save_poster_request_params.dart';
import '../models/allowed_actions_response.dart';
import '../models/attachment_resposne_model.dart';
import '../models/group_item_response_model.dart';
import '../models/permit_apply_group_response_model.dart';
import '../models/permit_license_response_model.dart';
import '../models/permit_poster_types_response.dart';
import '../models/permit_submit_response_model.dart';
import '../models/poster_request_details_model.dart';

abstract class PostersRemoteDataSource {
  Future<PermitsLicensesResponse> getLicensePermits(
      {required PermitLicenseRequestParams params});

  Future<GroupItemResponseModel> getGroupItems();

  Future<dynamic> savePoster({required SavePosterRequestParams params});

  Future<AttachmentResponseModel> getAttachmentTypes(
      {required PermitRequiredTypesParams params});

  Future<PermitPosterTypeResponse> getPErmitPosterTypes();

  Future<PermitApplyGroupResponse> applyPermitLicenseGroup(
      {required PermitApplyGroupRequestParams params});

  Future<PostersUploadResponse> uploadPosterFile(
      {required PermitAttachmentItem params});

  Future<PostersSubmitResponseModel> submit({required int params});
  Future<bool> addIndivisualRequests({required int params});

  Future<PosterRequestDetailsModel> getPosterRequestDetails(
      {required int params});

  Future<bool> deleteLicenseFromRequest(
      {required int requestId, required int licenseId});

  Future<PermitAlertsResponse> getPermitsAlerts();

  Future<bool> deletePermitRequest({required int requestId});

  Future<PermitApplyGroupResponse> applyLicense({required int? params});

  Future<PosterAllowedAction> getAllowedActionsOnRequest(
      {required int? params});
}

class PostersRemoteDataSourceImpl implements PostersRemoteDataSource {
  final WebService webService;

  PostersRemoteDataSourceImpl({required this.webService});

  @override
  Future<PermitsLicensesResponse> getLicensePermits(
      {required PermitLicenseRequestParams params}) async {
    var response;
    try {
      response = await webService.dio.get(
          ApiUrl.getLicensesForPermits(
              crNumber: params.crNumber!, groupId: params.groupId!),
          queryParameters: params.toMap(),
          options: Options(
              headers: {"crType": CommonProperties.selectedDelegator?.crType}));

      final data = response.data;
      data.toString().successLog();

      return PermitsLicensesResponse.fromJson(data["data"]);
    } on DioError catch (error) {
      "DioError $error".errorLog();

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      print(ex);
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
  Future<GroupItemResponseModel> getGroupItems() async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.getGroupsItems,
      );

      final data = response.data;
      data.toString().successLog();

      return GroupItemResponseModel.fromJson(data["data"]);
    } on DioError catch (error) {
      "DioError $error".errorLog();

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
  Future savePoster({required SavePosterRequestParams params}) async {
    var response;
    try {
      response = await webService.dio
          .post(ApiUrl.savePoster(params.requestId!), data: params.toJson());

      final data = response.data;
      data.toString().successLog();

      return true;
    } on DioError catch (error) {
      "DioError $error".errorLog();

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
  Future<AttachmentResponseModel> getAttachmentTypes(
      {required PermitRequiredTypesParams params}) async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.getPermitAttachmentTypes(
            requestId: params.requestId!, typeId: params.typeId!),
      );

      final data = response.data;
      data.toString().successLog();

      return AttachmentResponseModel.fromJson(data["data"]);
    } on DioError catch (error) {
      "DioError $error".errorLog();

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
  Future<PermitPosterTypeResponse> getPErmitPosterTypes() async {
    var response;
    try {
      response = await webService.dio.get(ApiUrl.getPermitPosterTypes);

      final data = response.data;
      data.toString().successLog();

      return PermitPosterTypeResponse.fromJson(data["data"]);
    } on DioError catch (error) {
      "DioError $error".errorLog();

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
  Future<PermitApplyGroupResponse> applyPermitLicenseGroup(
      {required PermitApplyGroupRequestParams params}) async {
    var response;
    try {
      response = await webService.dio
          .post(ApiUrl.applyPermitGroupLicense, data: params.toJson());

      final data = response.data;
      data.toString().successLog();

      return PermitApplyGroupResponse.fromJson(data["data"]["result"]);
    } on DioError catch (error) {
      "DioError $error".errorLog();

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
  Future<PostersUploadResponse> uploadPosterFile(
      {required PermitAttachmentItem params}) async {
    print("uploadPosterFile");
    final mimeType = lookupMimeType(params.filePath ?? "");

    final body = await locator<web.WebService>().uploadFileSSO(
        ApiUrl.permitUploadAttachment(params.requestId!, params.id!),
        base64: base64Decode(params.base64 ?? ""),
        fileName: params.fileName,
        mimeType: mimeType,
        key: params.key);
    ;
    bool state = body['state'];
    dynamic data = body['data'];
    String error = body['error'] ?? ("errors_server_error_1").tr();

    try {
      if (state == true) {
        return PostersUploadResponse.fromJson(
            json.decode(body["data"])["data"]["result"]);
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
            url: ApiUrl.permitUploadAttachment(params.requestId!, params.id!),
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
  Future<PostersSubmitResponseModel> submit({required int params}) async {
    var response;
    try {
      response = await webService.dio.post(
        ApiUrl.postersSubmit(params),
      );

      final data = response.data;
      data.toString().successLog();

      return PostersSubmitResponseModel.fromJson(data["data"]["result"]);
    } on DioError catch (error) {
      "DioError $error".errorLog();

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
  Future<bool> addIndivisualRequests({required int params}) async {
    var response;
    try {
      response = await webService.dio.post(
        ApiUrl.addIndivisualRequests(params),
      );

      final data = response.data;
      data.toString().successLog();

      return data["data"]["result"] as bool;
    } on DioError catch (error) {
      "DioError $error".errorLog();

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
  Future<PosterRequestDetailsModel> getPosterRequestDetails(
      {required int params}) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.postersRequestDetails(params),
      );

      final data = response.data;
      data.toString().successLog();

      return PosterRequestDetailsModel.fromJson(data["data"]?["result"]);
    } on DioError catch (error) {
      print(error);
      "DioError $error".errorLog();

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      print(ex);
      ;
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
  Future<bool> deleteLicenseFromRequest(
      {required int requestId, required int licenseId}) async {
    var response;
    try {
      response = await webService.dio.delete(
        ApiUrl.deleteLicenseFromPermit(requestId, licenseId),
      );

      final data = response.data;
      data.toString().successLog();

      return data["data"]["result"] as bool;
    } on DioError catch (error) {
      "DioError $error".errorLog();

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
  Future<bool> deletePermitRequest({required int requestId}) async {
    var response;
    try {
      response = await webService.dio.delete(
        ApiUrl.deletePermitRequest(requestId),
      );

      final data = response.data;
      data.toString().successLog();

      return data["data"]["result"] as bool;
    } on DioError catch (error) {
      "DioError $error".errorLog();

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
  Future<PermitAlertsResponse> getPermitsAlerts() async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.postersAlerts,
      );

      final data = response.data;
      data.toString().successLog();

      return PermitAlertsResponse.fromJson(data["data"]);
    } on DioError catch (error) {
      "DioError $error".errorLog();

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
  Future<PermitApplyGroupResponse> applyLicense({required int? params}) async {
    var response;
    try {
      response = await webService.dio.post(ApiUrl.applyLicense(params));

      final data = response.data;
      data.toString().successLog();

      return PermitApplyGroupResponse.fromJson(data["data"]["result"]);
    } on DioError catch (error) {
      "DioError $error".errorLog();

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
  Future<PosterAllowedAction> getAllowedActionsOnRequest(
      {required int? params}) async {
    var response;
    try {
      response =
          await webService.dio.get(ApiUrl.posterRequestAlllowedAction(params));

      final data = response.data;
      data.toString().successLog();

      return PosterAllowedAction.fromJson(data["data"]);
    } on DioError catch (error) {
      "DioError $error".errorLog();

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
}
