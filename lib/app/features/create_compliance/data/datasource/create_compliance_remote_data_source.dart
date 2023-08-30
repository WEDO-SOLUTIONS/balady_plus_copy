import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/services_exports.dart';
import '../../../../core/utils/constants/apis/api_info.dart';
import '../../../vd/data/model/create_incident/create_incident_response_model.dart';
import '../models/apply_create_compliance_request_model.dart';
import '../models/apply_create_compliance_response_model.dart';
import '../models/comliance_request_details_model.dart';
import '../models/save_location_compliance_request.dart';

abstract class CreateComplianceRemoteDataSource {
  Future<ApplyCreateComplianceResponseModel> applyCreateCompliance(
    ApplyCreateComplianceRequest params,
  );

  Future<ComplianceRequestDetailsModel> getComplianceByRequestId(
    String params,
  );

  Future<bool> saveLocationCompliance(
    SaveLocationComplianceRequest params,
  );
}

class CreateComplianceRemoteDataSourceImpl
    extends CreateComplianceRemoteDataSource {
  final WebService webService;

  CreateComplianceRemoteDataSourceImpl({required this.webService});

  @override
  Future<ApplyCreateComplianceResponseModel> applyCreateCompliance(
      ApplyCreateComplianceRequest params) async {
    var response;

    try {
      response = await webService.dio.post(
        ApiUrl.applyBeneficiaryCompliance,
        data: params.toMap(),
      );

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return ApplyCreateComplianceResponseModel.fromMap(result);
    } on DioError catch (error) {
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<ApplyCreateComplianceResponseModel>.fromMap(
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
        try {} catch (ex) {}
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<ComplianceRequestDetailsModel> getComplianceByRequestId(
      String params) async {
    var response;

    try {
      response = await webService.dio.get(
        ApiUrl.getComplianceRequestById + params,
      );

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return ComplianceRequestDetailsModel.fromJson(result);
    } on DioError catch (error) {
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<ComplianceRequestDetailsModel>.fromMap(
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
        try {} catch (ex) {}
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<bool> saveLocationCompliance(
      SaveLocationComplianceRequest params) async {
    var response;

    try {
      response = await webService.dio
          .post(ApiUrl.saveLocationCompliance, data: params.toMap());

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return true;
    } on DioError catch (error) {
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<ComplianceRequestDetailsModel>.fromMap(
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
        try {} catch (ex) {}
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }
}
