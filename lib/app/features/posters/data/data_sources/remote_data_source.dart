import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/extensions/log.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants/apis/api_info.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../../domain/entities/permit_apply_group_request_params.dart';
import '../../domain/entities/permit_licenses_requests_params.dart';
import '../../domain/entities/permit_required_types_params.dart';
import '../../domain/entities/save_poster_request_params.dart';
import '../models/attachment_resposne_model.dart';
import '../models/group_item_response_model.dart';
import '../models/permit_apply_group_response_model.dart';
import '../models/permit_license_response_model.dart';
import '../models/permit_poster_types_response.dart';

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
      );

      final data = response.data;
      data.toString().successLog();

      return PermitsLicensesResponse.fromJson(data["data"]);
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
  Future<PermitPosterTypeResponse> getPErmitPosterTypes() async {
    var response;
    try {
      response = await webService.dio.get(ApiUrl.getPermitPosterTypes);

      final data = response.data;
      data.toString().successLog();

      return PermitPosterTypeResponse.fromJson(data["data"]);
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
  Future<PermitApplyGroupResponse> applyPermitLicenseGroup(
      {required PermitApplyGroupRequestParams params}) async {
    var response;
    try {
      response = await webService.dio.post(ApiUrl.applyPermitGroupLicense);

      final data = response.data;
      data.toString().successLog();

      return PermitApplyGroupResponse.fromJson(data["data"]["result"]);
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
}
