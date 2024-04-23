import 'dart:convert';

import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/core/utils/extensions/json_conversion.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/comercial_license_renew/domain/entities/cr_attachment_request.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/approval_sequence/data/models/request_attachments/request_attachments.dart';
import 'package:balady_plus/app/features/health_certificate/license_management_exports.dart';
import 'package:dio/dio.dart' show DioError, DioException, Response;
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;
import 'package:mime/mime.dart';

import '../../../../../core/base/base_view_model.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../commercial_license/domain/entities/save_shop_details_request.dart';
import '../../domain/entities/save_selected_requests_permits_request.dart';
import '../../domain/entities/save_shop_info_request.dart';
import '../models/request_permits_model/permit.dart';
import '../models/request_permits_model/request_permits_model.dart';
import '../models/submit_approvel_model.dart';
import '../models/transfer_attachment_response/request_attachments_response.dart';

import '../models/upload_attachments.dart';
import '../../../../../core/remote_services/web_service.dart' as web;

abstract class RequestPermitsRemoteDataSource {
  Future<RequestPermitsModel> getRequestPermits(int requestNumber);

  Future<bool> saveSelectedRequestsPermits(
      int requestNumber, SaveSelectedRequestsPermitsRequest params);
  Future saveShopDetails({required SaveShopDetailsRequest params});
  Future<bool> saveShopInfo(int requestNumber, SaveShopInfoRequest params);
  Future<List<RequestAttachmentsResponse>> requestAttachments(int requestNumber);
  Future<bool>? uploadAttachments({required CrAttachmentRequest params});
  Future<bool> saveAttachment( CrAttachmentRequest params);
  Future<bool>? uploadCredence( CrAttachmentRequest params);
  Future<bool> submitApprovel(int requestNumber);



}

class RequestPermitsRemoteDataSourceImplementation
    implements RequestPermitsRemoteDataSource {
  final WebService webService;

  RequestPermitsRemoteDataSourceImplementation({required this.webService});

  @override
  Future<RequestPermitsModel> getRequestPermits(int requestNumber) async {
    Response? response;

    try {
      response =
          await webService.dio.get(ApiUrl.getRequestPermits(requestNumber));
      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return RequestPermitsModel.fromJson(result);
    } on DioException catch (error) {
      if (error is NoDataFoundException) {
        rethrow;
      }

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: ex.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<bool> saveSelectedRequestsPermits(
      int requestNumber, SaveSelectedRequestsPermitsRequest params) async {
    Response? response;

    try {
      response = await webService.dio.post(
          ApiUrl.saveSelectedRequestPermits(requestNumber),
          data: params.toJson());
      final data = response.data;

      final statusCode = ResponseBodyModel.fromMap(data).statusDetails!.code;
      if (statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (error) {
      if (error is NoDataFoundException) {
        rethrow;
      }

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: ex.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<bool> saveShopInfo(
      int requestNumber, SaveShopInfoRequest params) async {
    Response? response;

    try {
      response = await webService.dio
          .post(ApiUrl.transferShopInfo(requestNumber), data: params.toJson());
      final data = response.data;

      final statusCode = ResponseBodyModel.fromMap(data).statusDetails!.code;
      if (statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (error) {
      if (error is NoDataFoundException) {
        rethrow;
      }

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: ex.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<bool> saveShopDetails({required SaveShopDetailsRequest params}) async {
    var response;

    try {
      response = await webService.dio.post(
          ApiUrl.ComercialLicenseTransferShopInfo(
            params.requestId!,
          ),
          data: params.toMap());



      final decodedResponse =
          ResponseBodyModel<dynamic>.fromMap(response.data, parsedResult: null);

      return true;
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
  Future<List<RequestAttachmentsResponse>> requestAttachments(int requestNumber) async {
    Response? response;

    try {
      response =
          await webService.dio.get(ApiUrl.transferRequestAttachments(requestNumber));
      final data = response.data;

      // final dataResponse = ResponseBodyModel.fromMap(data).data!;




      List<RequestAttachmentsResponse> lst = (data["data"]["result"] as List)
          .map((data) => RequestAttachmentsResponse.fromJson(data))
          .toList();

      return lst;

    } on DioException catch (error) {
      if (error is NoDataFoundException) {
        rethrow;
      }

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: ex.toString(),
          ),
          response: response,
        );
      }
    }
  }


  @override
  Future<bool>? uploadAttachments({required CrAttachmentRequest params}) async {
    final mimeType = lookupMimeType(params.data?.filePath ?? "");

    final body = await locator<web.WebService>().uploadFileSSO(
      ApiUrl.uploadCredences(params.requestId!, params.data!.id),
      base64: base64Decode(params.data?.base64 ?? ""),
      fileName: params.data?.fileName,
      mimeType: mimeType,
    );
    ;
    print(ApiUrl.uploadCredences(params.requestId!, params.data!.id));
    bool state = body['state'];
    dynamic data = body['data'];

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
  Future<bool> saveAttachment( CrAttachmentRequest params) async {
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
  Future<bool>? uploadCredence( CrAttachmentRequest params) async {
    final mimeType = lookupMimeType(params.data?.filePath ?? "");

    final body = await locator<web.WebService>().uploadFileSSO(
      ApiUrl.uploadCredences(params.requestId!, params.data!.id),
      base64: base64Decode(params.data?.base64 ?? ""),
      fileName: params.data?.fileName,
      mimeType: mimeType,
    );
    ;
    print(ApiUrl.uploadCredences(params.requestId!, params.data!.id));
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
  Future<bool> submitApprovel(
      int requestNumber) async {
    Response? response;

    try {

      SubmitApprovelModel obj = SubmitApprovelModel();
      response = await webService.dio
          .post(ApiUrl.submitApprovel(requestNumber) ,data: obj.toJson());
      final data = response.data;

      final statusCode = ResponseBodyModel.fromMap(data).statusDetails!.code;
      if (statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (error) {
      if (error is NoDataFoundException) {
        rethrow;
      }

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: ex.toString(),
          ),
          response: response,
        );
      }
    }
  }


}
