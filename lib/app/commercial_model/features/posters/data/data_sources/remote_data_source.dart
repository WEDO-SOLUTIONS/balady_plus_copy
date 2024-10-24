import 'dart:convert';

import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/extensions/log.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/commercial_model/features/posters/data/models/permits_alerts_response.dart';
import 'package:balady_plus/app/commercial_model/features/posters/data/models/posters_upload_response_model.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mime/mime.dart';
import 'package:balady_plus/app/core/remote_services/pega_web_service.dart' as web;

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import '../../../../../features/_shared_feature_/data/models/response_body_model.dart';
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
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/commercial_model/commercial_model_end_points.dart';

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
          CommercialModelEndPoints.getLicensesForPermits(
              crNumber: params.crNumber!, groupId: params.groupId!),
          queryParameters: params.toMap(),
          options: Options(
              headers: {"crType": CommonProperties.selectedDelegator?.crType}));

      final data = response.data;
      data.toString().successLog();

      return PermitsLicensesResponse.fromJson(data["data"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

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
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
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
        CommercialModelEndPoints.getGroupsItems,
      );

      final data = response.data;
      data.toString().successLog();

      return GroupItemResponseModel.fromJson(data["data"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

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
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
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
          .post(CommercialModelEndPoints.savePoster(params.requestId!), data: params.toJson());

      final data = response.data;
      data.toString().successLog();

      return true;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

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
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
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
        CommercialModelEndPoints.getPermitAttachmentTypes(
            requestId: params.requestId!, typeId: params.typeId!),
      );

      final data = response.data;
      data.toString().successLog();

      return AttachmentResponseModel.fromJson(data["data"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

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
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<PermitPosterTypeResponse> getPErmitPosterTypes() async {
    var response;
    try {
      response = await webService.dio.get(CommercialModelEndPoints.getPermitPosterTypes);

      final data = response.data;
      data.toString().successLog();

      return PermitPosterTypeResponse.fromJson(data["data"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

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
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
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
          .post(CommercialModelEndPoints.applyPermitGroupLicense, data: params.toJson());

      final data = response.data;
      data.toString().successLog();

      return PermitApplyGroupResponse.fromJson(data["data"]["result"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

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
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
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

    final body = await locator<web.PegaWebService>().uploadFileSSO(
        CommercialModelEndPoints.permitUploadAttachment(params.requestId!, params.id!),
        base64: base64Decode(params.base64 ?? ""),
        fileName: params.fileName,
        mimeType: mimeType,
        key: params.key,
        posterId: params.posterId,
        posterTypeId: params.posterTypeId);
    ;
    bool state = body['state'];
    dynamic data = body['data'];
    String errorString = body['error'] ?? ("errors_server_error_1").tr();
    print(params.id!);
    try {
      print(body["data"]);
      if (state == true) {
        return PostersUploadResponse.fromJson(
            json.decode(body["data"])["data"]["result"]);
      } else {
        print("fff");
        errorString = ResponseBodyModel.fromMap(json.decode(body["data"]))
                .data
                ?.responseMessage ??
            errorString;
        print(errorString);

        throw ServerException(
          errorString,
          exception: APIException(
            errorMessage: data,
          ),
        );
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      try {
        Helpers.sendLog(
            url: CommercialModelEndPoints.permitUploadAttachment(params.requestId!, params.id!),
            data: data,
            errorMsg: error.toString());
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }
      errorString = ResponseBodyModel.fromMap(json.decode(body["data"]))
              .data
              ?.responseMessage ??
          errorString;

      throw ServerException(
        errorString.toString(),
        exception: APIException(
          errorMessage: error.toString(),
        ),
      );
    }
  }

  @override
  Future<PostersSubmitResponseModel> submit({required int params}) async {
    var response;
    try {
      response = await webService.dio.post(
        CommercialModelEndPoints.postersSubmit(params),
      );

      final data = response.data;
      data.toString().successLog();

      return PostersSubmitResponseModel.fromJson(data["data"]["result"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

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
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
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
        CommercialModelEndPoints.addIndivisualRequests(params),
      );

      final data = response.data;
      data.toString().successLog();

      return data["data"]["result"] as bool;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

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
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
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
        CommercialModelEndPoints.postersRequestDetails(params),
      );

      final data = response.data;
      data.toString().successLog();

      return PosterRequestDetailsModel.fromJson(data["data"]?["result"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      "DioError $error".errorLog();

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
      ;
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
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
        CommercialModelEndPoints.deleteLicenseFromPermit(requestId, licenseId),
      );

      final data = response.data;
      data.toString().successLog();

      return data["data"]["result"] as bool;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

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
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
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
        CommercialModelEndPoints.deletePermitRequest(requestId),
      );

      final data = response.data;
      data.toString().successLog();

      return data["data"]["result"] as bool;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

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
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
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
        CommercialModelEndPoints.postersAlerts,
      );

      final data = response.data;
      data.toString().successLog();

      return PermitAlertsResponse.fromJson(data["data"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

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
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<PermitApplyGroupResponse> applyLicense({required int? params}) async {
    var response;
    try {
      response = await webService.dio.post(CommercialModelEndPoints.applyLicense(params));

      final data = response.data;
      data.toString().successLog();

      return PermitApplyGroupResponse.fromJson(data["data"]["result"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

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
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
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
          await webService.dio.get(CommercialModelEndPoints.posterRequestAlllowedAction(params));

      final data = response.data;
      data.toString().successLog();

      return PosterAllowedAction.fromJson(data["data"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

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
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }
}
