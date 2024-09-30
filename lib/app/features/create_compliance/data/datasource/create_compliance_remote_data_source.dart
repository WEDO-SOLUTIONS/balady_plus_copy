import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/compliance_engoffice_details_model.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/complinace_engoffice_response_model.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/land_subsidy_contract_model.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/ownership_doc_type_response_model.dart';
import 'package:balady_plus/app/features/create_compliance/domain/entities/compliance_attachment_request.dart';
import 'package:balady_plus/app/features/create_compliance/domain/entities/land_subsidy_contract_request.dart';
import 'package:balady_plus/app/features/create_compliance/domain/entities/verify_otp_request.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart' as http;

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mime/mime.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    as EtmamCommonProperties hide Log;
import '../../../../core/remote_services/pega_web_service.dart' as web;

import '../../../../core/base/base_view_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/local/helpers.dart';
import '../../../../core/services/services_exports.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/apis/api_info.dart';
import '../../../transaction_inquiry/customer_voice_exports.dart';
import '../../../vd/data/model/create_incident/create_incident_response_model.dart';
import '../../../vd/domain/entities/gis/gis_params.dart';
import '../../create_compliance_exports.dart';
import '../../domain/entities/compliance_appointment_response.dart';
import '../../domain/entities/compliance_deed_info_request.dart';
import '../../domain/entities/ownership_doc_type_response.dart';
import '../../domain/entities/send_otp_response.dart';
import '../models/apply_create_compliance_request_model.dart';
import '../models/apply_create_compliance_response_model.dart';
import '../models/comliance_request_details_model.dart';
import '../models/compliance_certificate_item_request.dart';
import '../models/compliance_certificate_items_request.dart';
import '../models/compliance_deed_info_model.dart';
import '../models/compliance_gis_resopnseـmodel.dart';
import '../models/complinace_licenses_response_model.dart';
import '../models/save_contract_info_request.dart';
import '../models/save_location_compliance_request.dart';
import '../../../../core/remote_services/pega_web_service.dart' as web;
import '../models/upload_dms_attachment_response.dart';

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

  Future<bool> saveContractInfo(
    SaveContractInfoRequest params,
  );

  Future<bool> saveComplianceCertificateItems(
    ComplianceCertificateItemsRequest params,
  );

  Future<bool> saveComplianceCertificateItem(
    ComplianceCertificateItemRequest params,
  );

  Future<(String, bool?)> submitRequest(
      String id, SubmitEmtithalRequest params);

  Future<ComplinaceLookUpResponseModel> getOwnerShipDocTypeResponse();

  Future<ComplinaecLicensesReponseModel> getComplianceLicense();

  Future<ComplinaceLookUpResponseModel> getMainUsages();

  Future<ComplinaceLookUpResponseModel> getSubUsages({required int mainId});

  Future<ComplinaecEngOfficeReponseModel> getComplianceEngOffices();

  Future<ComplianceEngOfficeDetailsModel> getComplianceEngOfficeDetails(
      {required String id});

  Future<ComplainceGISResponseModel> getGISInfo({required GISParams params});

  Future<bool> saveAttachment({required ComplinaceAttachmentRequest params});

  Future<SendOtpResponse> sendOTP({required String params});

  Future<bool> verifyOTP({required VerifyOTPRequest params});

  Future<Uint8List?> downLoadCertificate({required String params});

  Future<bool?> deleteComplianceRequwst({required String params});

  Future<String?> getEtmamId({required String params});

  Future<ComplinaceLookUpResponseModel> getReciptTypes();

  Future<ComplianceDeedInfoModel> getDeedInfo(ComplianceDeedInfoRequest params);

  Future<LandSubsidyContractModel> getLandContract(
      LandSubsidyContractRequest params);

  Future<UploadDmsAttachmentResponse> uploadClauseAttachment(
      FileDataItem params, int requestId);

  Future<bool> validateComplianceCertificateItem(int params);

  Future<bool> cancelComplianceCertificate(int params);

  Future<ComplainceAppointmentResponse> getComplainceAppointment(
      String x, String y);
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
        options: params.requestId != null
            ? Options(headers: {"requestId": params.requestId})
            : null,
      );

      final data = response.data;

      return ApplyCreateComplianceResponseModel(
          result: ResponseBodyModel.fromMap(data).data?.result);
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
            ResponseBodyModel<ApplyCreateComplianceResponseModel>.fromMap(
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
        try {} catch (error, stackTrace) {
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
            ResponseBodyModel<ComplianceRequestDetailsModel>.fromMap(
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
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {} catch (error, stackTrace) {
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
  Future<bool> saveLocationCompliance(
      SaveLocationComplianceRequest params) async {
    var response;

    try {
      response = await webService.dio.post(
          ApiUrl.saveLocationCompliance + params.requsestId.toString(),
          data: params.toMap());

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return true;
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
            ResponseBodyModel<ComplianceRequestDetailsModel>.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<bool> saveContractInfo(SaveContractInfoRequest params) async {
    var response;

    try {
      response = await webService.dio.post(
          ApiUrl.saveContractCompliance + params.requestId.toString(),
          data: params.toMap());

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return true;
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<bool> saveComplianceCertificateItems(
      ComplianceCertificateItemsRequest params) async {
    var response;

    try {
      response = await webService.dio.post(
          ApiUrl.saveComplianceCertificateItems + params.requestId.toString(),
          data: params.toRequest());

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return true;
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<(String, bool?)> submitRequest(
      String id, SubmitEmtithalRequest params) async {
    var response;

    try {
      response = await webService.dio
          .post(ApiUrl.submitComplianceRequest + id, data: params.toMap());

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return (result["message"] as String, result["isPrintable"] as bool?);
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<ComplinaceLookUpResponseModel> getOwnerShipDocTypeResponse() async {
    var response;

    try {
      response = await webService.dio.get(ApiUrl.complicanecOwnershioDocType);

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return ComplinaceLookUpResponseModel.fromJson(result);
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<ComplinaecLicensesReponseModel> getComplianceLicense() async {
    var response;
    String url = ApiUrl.complianceMyLicenses(
        id: CommonProperties.userInfo?.idNo ?? "", type: "HIMSELF");

    if (CommonProperties.getCurrentUserProfile() != null) {
      url = ApiUrl.complianceMyLicenses(
          id: CommonProperties.getCurrentUserProfile()?.id ?? "",
          type: CommonProperties.getCurrentUserProfile()?.getRole() ?? "");
    }

    try {
      response = await webService.dio.get(url,
          options: Options(
              headers: (CommonProperties.selectedDelegator != null)
                  ? {"x-owner-type": CommonProperties.selectedDelegator?.crType}
                  : {}));

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return ComplinaecLicensesReponseModel.fromJson(result);
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<ComplinaceLookUpResponseModel> getMainUsages() async {
    var response;

    try {
      response = await webService.dio.get(ApiUrl.complianceMainUsage);

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return ComplinaceLookUpResponseModel.fromJson(result);
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<ComplinaceLookUpResponseModel> getSubUsages(
      {required int mainId}) async {
    var response;

    try {
      response = await webService.dio.get(ApiUrl.complianceSubUsage(mainId));

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return ComplinaceLookUpResponseModel.fromJson(result);
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<ComplinaecEngOfficeReponseModel> getComplianceEngOffices() async {
    var response;

    try {
      response = await webService.dio.get(ApiUrl.complianceEngOffices);

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return ComplinaecEngOfficeReponseModel.fromJson(result);
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<ComplianceEngOfficeDetailsModel> getComplianceEngOfficeDetails(
      {required String id}) async {
    var response;

    try {
      response =
          await webService.dio.get(ApiUrl.complinaceEngOfficesDetails(id));

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return ComplianceEngOfficeDetailsModel.fromJson(result);
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<ComplainceGISResponseModel> getGISInfo(
      {required GISParams params}) async {
    var response;

    try {
      response = await webService.dio
          .get(ApiUrl.complianceGIS, queryParameters: params.toMap());

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return ComplainceGISResponseModel.fromJson(result);
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<bool> saveAttachment(
      {required ComplinaceAttachmentRequest params}) async {
    final mimeType = lookupMimeType(params.attahment.filePath ?? "");

    final body = await locator<web.PegaWebService>().uploadFileSSO(
      ApiUrl.complianceAttachment(
          params.requestId.toString(), params.attahment.id),
      base64: base64Decode(params.attahment.base64 ?? ""),
      fileName: params.attahment.fileName,
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
        ResponseBodyModel? r =
            data != null ? ResponseBodyModel.fromMap(json.decode(data)) : null;
        String error = r?.data?.responseMessage ?? "errors_server_error_2".tr();
        throw ServerException(
          error,
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
      if (error is ServerException) rethrow;
      try {
        Helpers.sendLog(
            url: ApiUrl.complianceAttachment(
                params.requestId.toString(), params.attahment.id),
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

      throw ServerException(
        "errors_server_error_2".tr(),
        exception: APIException(
          errorMessage: error.toString(),
        ),
      );
    }
  }

  @override
  Future<SendOtpResponse> sendOTP({required String params}) async {
    var response;

    try {
      response = await webService.dio.post(
        ApiUrl.complianceSendOTP,
        options: Options(headers: {
          ApiHeaders.xFeappId: CommonProperties.appName,
          ApiHeaders.xCorrelationId: CommonFunctions.generateGUID(),
          ApiHeaders.xSessionId:
              EtmamCommonProperties.CommonProperties.sessionId,
          "x-fe-deployment-id":
              EtmamCommonProperties.CommonProperties.appVersion,
          "Accept-Language": translator.activeLanguageCode,
          "x-fe-service-id": "compliance",
          "Content-Type": "application/json",
        }),
        data: {"mobileNumber": params},
      );

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return SendOtpResponse.fromJson(result);
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<bool> verifyOTP({required VerifyOTPRequest params}) async {
    var response;

    try {
      response = await webService.dio.post(ApiUrl.complianceVerify,
          options: Options(headers: {
            ApiHeaders.xFeappId: CommonProperties.appName,
            ApiHeaders.xCorrelationId: CommonFunctions.generateGUID(),
            ApiHeaders.xSessionId:
                EtmamCommonProperties.CommonProperties.sessionId,
            "x-fe-deployment-id":
                EtmamCommonProperties.CommonProperties.appVersion,
            "Accept-Language": translator.activeLanguageCode,
            "x-fe-service-id": "compliance",
            "Content-Type": "application/json",
          }),
          data: params.toMap());

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;
      NavigationService.goBack();
      return true;
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<Uint8List?> downLoadCertificate({required String params}) async {
    final body = await locator<web.PegaWebService>()
        .getNewApigeeRequestWithoutUTF(ApiUrl.downLoadBuildingLicense(params));
    bool state = body['state'];
    dynamic data = body['data'];
    Uint8List? result;
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_1");
    String? contentType = body['Content-Type'];

    try {
      if (state) result = data;

      if (!state) {
        //   error = result.data?.responseMessage ?? error;

        try {
          Helpers.sendLog(
              url: ApiUrl.downLoadBuildingLicense(params),
              data: data,
              errorMsg: body.toString() ?? "");
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    return Future.value(result);
  }

  @override
  Future<bool?> deleteComplianceRequwst({required String params}) async {
    var response;

    try {
      response = await webService.dio
          .delete(ApiUrl.deleteComplianceRequest + params, data: params);

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return true;
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<String?> getEtmamId({required String params}) async {
    var response;

    try {
      response = await webService.dio.post(ApiUrl.etmamProfileEntity, data: {
        "platformId": "balady",
        "entities": [
          {
            "entityId": "service",
            "ids": ["1130"]
          }
        ]
      });

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result["entities"]["service"]["profiles"]["1130"]["internalId"];
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<ComplinaceLookUpResponseModel> getReciptTypes() async {
    var response;

    try {
      response = await webService.dio.get(ApiUrl.complianceReciptTypes);

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return ComplinaceLookUpResponseModel.fromJson(result);
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<ComplianceDeedInfoModel> getDeedInfo(
      ComplianceDeedInfoRequest params) async {
    var response;

    try {
      response = await webService.dio
          .get(ApiUrl.complianceDeedInfo, queryParameters: params.toMap());

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return ComplianceDeedInfoModel.fromJson(result);
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<LandSubsidyContractModel> getLandContract(
      LandSubsidyContractRequest params) async {
    var response;

    try {
      response = await webService.dio.get(ApiUrl.complianceLandContract,
          queryParameters: {if (params.id != null) "id_number": params.id});

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return LandSubsidyContractModel.fromJson(result);
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<bool> saveComplianceCertificateItem(
      ComplianceCertificateItemRequest params) async {
    var response;

    try {
      response = await webService.dio.post(
          ApiUrl.saveComplianceCertificateItem(params.requestId!),
          data: params.toMap());

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return true;
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<UploadDmsAttachmentResponse> uploadClauseAttachment(
      FileDataItem params, int requestId) async {
    var response;

    try {



      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      String newFileName = params.fileName.replaceRange(0, params.fileName.indexOf("."), "$timeStamp");
      String contentTyp = lookupMimeType(params.filePath)!;
      final formData = FormData.fromMap(
        {
          "file": await MultipartFile.fromFile(
            params.filePath,
            filename:  newFileName , //params.fileName,
            contentType: http.MediaType.parse(contentTyp),
          ),
        },
      );
      response = await webService.dio.post(
        ApiUrl.uploadComplianceAttachment(
          requestId,
        ),
        data: formData,
        options: Options(
          headers: {
            "X-Content-Type": contentTyp,
          },
        ),
      );

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return UploadDmsAttachmentResponse.fromJson(result);
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<bool> validateComplianceCertificateItem(int params) async {
    var response;

    try {
      response = await webService.dio.post(
        ApiUrl.validateComplianceCertificate(params),
      );

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return true;
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<bool> cancelComplianceCertificate(int params) async {
    var response;

    try {
      response = await webService.dio.delete(
        ApiUrl.cancelComplianceCertificate(params),
      );

      final data = response.data;

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return true;
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
  Future<ComplainceAppointmentResponse> getComplainceAppointment(
      String x, String y) async {
    var response;

    try {
      response = await webService.dio
          .get(ApiUrl.complainceAppointments, queryParameters: {
        "latitude": y,
        "longitude": x,
      });

      final data = response.data;

      ComplainceAppointmentResponse parsedResult =
          ComplainceAppointmentResponse.fromJson(data["data"]);
      //  final result = ResponseBodyModel<ComplainceAppointmentResponse>.fromMap(data, parsedResult: parsedResult).data?.result;

      return parsedResult;
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
        final decodedResponse = ResponseBodyModel.fromMap(
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
        try {} catch (error, stackTrace) {
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
