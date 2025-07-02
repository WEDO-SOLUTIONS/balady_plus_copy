import 'dart:convert';
import 'dart:typed_data';

import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/health_certificate/presentation/core/models/profession.dart';
import 'package:dgis_map/library.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:smart_advisor/app/core/errors/exceptions.dart';
import 'package:tuple/tuple.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../../core/remote_services/api_constants.dart';
import '../../../../../../core/remote_services/pega_web_service.dart';
import '../../../../../../core/services/local/helpers.dart';
import '../../../../../../core/utils/common_functions.dart';
import '../../../../../../core/utils/constants/apis/api_info.dart';
import '../../../../../../core/utils/constants/remote_config.dart';
import '../../../../../transaction_inquiry/presentation/core/models/gis_location_result.dart';
import '../../models/apply_new_health_request.dart';
import '../../models/cancel_health_certificate_response.dart';
import '../../models/check_update_photo_client.dart';
import '../../models/cr_information.dart';
import '../../models/delete_request_response.dart';
import '../../models/health_request_details.dart';
import '../../models/license_for_health_information_response.dart';
import '../../models/list_response.dart';
import '../../models/rating_info_response.dart';
import '../../models/send_otp_sertificate.dart';
import '../../models/submit_new_request_response.dart';
import '../../models/update_photo_response.dart';
import '../../models/validate_health_certificate_response.dart';
import '../../models/verify_otp_certificate.dart';
import '../../models/location_info_response.dart';
import '../../../../../../core/services/global/web_service.dart' as web;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class HealthLicenseRepository {
  final webServices = locator<PegaWebService>();
  final webService = locator<web.WebService>();

  String idTypeHandling(String idType) {
    if (idType == '3' || idType == '4') {
      return '9';
    } else if (idType == '2') {
      return '3';
    } else {
      return idType;
    }
  }

  Future<List<Profession>> searchProfessions({
    required String query,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await webService.dio.get(
        ApiUrl.getProfessions,
        queryParameters: {
          'page': page,
          'size': size,
          'name': query,
        },
      );

      final responseData = response.data as Map<String, dynamic>?;

      if (responseData == null) {
        throw Exception('Invalid response data');
      }

      final data = responseData['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('No data in response');
      }

      final responseCode = data['responseCode'] as String?;
      if (responseCode != '1') {
        final errorMessage =
            data['responseMessage'] as String? ?? 'Unknown error';
        throw Exception('Failed to load professions: $errorMessage');
      }

      final result = data['result'] as List<dynamic>? ?? [];
      return result
          .map<Profession>(
              (e) => Profession.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception:  error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        throw ServerException(("errors_server_error_2").tr());
      }
    }
  }

  Future<Tuple3<bool?, String?, GisLocationResult?>> getGisLocation(
      LatLng location) async {
    var res = await sl<web.WebService>().dio.get(ApiUrl.gis,
        queryParameters: {"x": location.longitude, "y": location.latitude});

    try {
      Map<String, dynamic> x = {};
      var data = res.data["data"]["result"];

      x["Contents"] = data;

      GisLocationResult response = GisLocationResult.fromJson(x);
      print("DONEE");
      return Tuple3<bool?, String?, GisLocationResult?>(true, "", response);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Tuple3<bool?, String?, GisLocationResult?>(
          false, ("errors_server_error_1").tr(), null);
    }

    /*bool state = body['state'];
    dynamic data = body['data'];
    GisLocationResult? result;
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_2");

    try {
      GisLocationResult response =
          GisLocationResult.fromJson(json.decode(data));
      result = response;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        //MM
        Helpers.sendLog(
            url: RemoteConfig.gis + ApiConstants.GisGetLocation,
            qeuryParms: query,
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
    }*/
    //  return Tuple3<bool?, String?, GisLocationResult?>(state, error, result);
  }

  Future<Tuple3<bool?, String?, ValidateHealthCertificateResponse?>>
      validateHealthCertificate(String userId, String idType, String birthDate,
          String municipalityId, bool isSaudi,
          {bool isRenew = false}) async {
    String url = isRenew
        ? ApiConstants.ValidateRenewHelathCertificatesRequest
        : ApiConstants.ValidateHelathCertificatesRequest;
    final body =
        await webServices.postApigeeRequest(url, isHealthLicense: true, body: {
      "employeeIdentityNumber": userId,
      "employeeIdentityType": idTypeHandling(idType),
      "employeeBirthDate": birthDate,
      "submitterBirthDate": birthDate,
      "submitterType": "HIMSELF",
      "municipalityId": municipalityId,
      "isNotSaudi": !isSaudi,
      "borderIdentityInfo": null
    });

    bool state = body['state'];
    dynamic data = body['data'];

    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_2");
    ValidateHealthCertificateResponse? result;
    try {
      ValidateHealthCertificateResponse response =
          ValidateHealthCertificateResponse.fromJson(json.decode(data));
      result = response;

      if (!state) {
        error = result.data?.responseMessage ?? error;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        Helpers.sendLog(
          url: url,
          data: data,
          errorMsg: error.toString(),
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
    }
    return Tuple3<bool?, String?, ValidateHealthCertificateResponse?>(
        state, error, result);
  }

  Future<Tuple3<bool?, String?, List<String>?>> getTerms(
      String birthDate, String municipalityId, bool showAreaNoLicencePermit,
      {bool isRenew = false}) async {
    String url = ApiConstants.healthTerms;
    int requestType = isRenew ? 1303 : 1301;
    print("HGG");
    final body = await webServices
        .getApigeeRequest(url, isHealthLicense: true, queryParams: {
      "birthDate": birthDate,
      "gisCode": municipalityId,
      "requestTypeId": requestType.toString(),
      "showAreaNoLicencePermit": showAreaNoLicencePermit.toString()
    });
    print("FFF");
    print(body);
    bool state = body['state'];
    dynamic data = body['data'];

    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_2");
    List<String>? result;
    try {
      if (!state) {
        error = json.decode(data)?["data"]?["responseMessage"] ?? error;
      }
      print("HH");
      print(json.decode(data)["data"]?["result"]);
      if (json.decode(data)["data"]?["result"] != null)
        result = List<String>.from(json.decode(data)["data"]["result"]);
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
          url: url,
          data: data,
          errorMsg: error.toString(),
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
    }
    return Tuple3<bool?, String?, List<String>?>(state, error, result);
  }

  Future<Tuple3<bool?, String?, ApplyNewHealthRequest?>> applyHealthCertificate(
      String userId,
      String idType,
      String birthDate,
      String municipalityId,
      bool isSaudi,
      String mobile,
      double x,
      double y,
      String? crType,
      String? crNumber,
      String? licenseId,
      bool areaNoLicencePermit,
      String? professionCode,
      int? healthCenterId,
      String? licenseType,
      String? districtCode,
      {bool isRenew = false}) async {
    final String url = isRenew
        ? ApiConstants.ApplyRenewHelathCertificatesRequest
        : ApiConstants.ApplyHelathCertificatesRequest;
    final body =
        await webServices.postApigeeRequest(url, isHealthLicense: true, body: {
      "submitterBirthDate": birthDate,
      "submitterType": "HIMSELF",
      "mobileNumber": mobile,
      "municipalityId": municipalityId,
      "crType": crType,
      "crNumber": crNumber,
      "licenseId": licenseId,
      "districtCode": districtCode,
      if (licenseType != null) "licenseType": licenseType,
      "areaNoLicencePermit": areaNoLicencePermit,
      "employeeIdentityNumber": userId,
      "employeeIdentityType": idTypeHandling(idType),
      "employeeBirthDate": birthDate,
      "employeeMobileNumber": mobile,
      if (professionCode != null) "professionCode": professionCode,
      if (healthCenterId != null) "healthCenterId": healthCenterId,
      "x": x.toString(),
      "y": y.toString(),
    });

    bool state = body['state'];
    dynamic data = body['data'];
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_2");
    ApplyNewHealthRequest? result;
    try {
      ApplyNewHealthRequest response =
          ApplyNewHealthRequest.fromJson(json.decode(data));
      result = response;
      if (!state) {
        error = result.data?.responseMessage ?? error;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        Helpers.sendLog(url: url, data: data, errorMsg: error.toString());
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
    return Tuple3<bool?, String?, ApplyNewHealthRequest?>(state, error, result);
  }

  Future<Tuple3<bool?, String?, CancelHealthCertificateResponse?>>
      cancelHealthCertificate(
    String birthDate,
    String mobile,
    int? certificateNumber,
  ) async {
    final body = await webServices.postApigeeRequest(
        ApiConstants.CancelHelathCertificatesRequest,
        isHealthLicense: true,
        body: {
          "certificateNumber": certificateNumber,
          "submitterBirthDate": birthDate,
          "submitterMobileNumber": mobile,
          "submitterType": "HIMSELF"
        });
    bool state = body['state'];
    dynamic data = body['data'];
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_2");
    CancelHealthCertificateResponse? result;
    try {
      CancelHealthCertificateResponse response =
          CancelHealthCertificateResponse.fromJson(json.decode(data));
      result = response;

      if (!state) {
        error = result.data?.responseMessage ?? error;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        Helpers.sendLog(
            url: ApiConstants.CancelHelathCertificatesRequest,
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
    }
    return Tuple3<bool?, String?, CancelHealthCertificateResponse?>(
        state, error, result);
  }

  Future<Tuple3<bool?, String?, SubmitNewRequestResponse?>> submitRequest(
      int requestId,
      {bool isRenew = false}) async {
    final String url = isRenew
        ? ApiConstants.SubmitRenewRequest
        : ApiConstants.SubmitNewRequest;
    final body = await webServices.postApigeeRequest(url,
        isHealthLicense: true, relativePath: requestId.toString());
    bool state = body['state'];
    dynamic data = body['data'];
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_2");
    SubmitNewRequestResponse? result;
    try {
      SubmitNewRequestResponse response =
          SubmitNewRequestResponse.fromJson(json.decode(data));
      result = response;

      if (!state) {
        error = result.data?.responseMessage ?? error;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        Helpers.sendLog(
            url: url,
            data: data,
            qeuryParms: requestId.toString(),
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
    }
    return Tuple3<bool?, String?, SubmitNewRequestResponse?>(
        state, error, result);
  }

  Future<Tuple3<bool?, String?, CrInformationResponse?>> getCrInformation(
      String crNumber) async {
    String query = crNumber;

    final body = await webServices.postApigeeRequest(ApiConstants.CrInfoService,
        isHealthLicense: true, relativePath: query);
    bool state = body['state'];
    dynamic data = body['data'];
    CrInformationResponse? result;
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_1");

    try {
      CrInformationResponse response =
          CrInformationResponse.fromJson(json.decode(data));
      result = response;
      if (!state) {
        error = result.data?.responseMessage ?? error;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        Helpers.sendLog(
            url: ApiConstants.CrInfoService,
            data: data,
            qeuryParms: query,
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
    }
    return Tuple3<bool?, String?, CrInformationResponse?>(state, error, result);
  }

  Future<Tuple3<bool?, String?, LicenseForHealthInformationResponse?>>
      getLicenseInformation(
    String licenseId,
    String licenseType,
  ) async {
    final body = await webServices.getApigeeRequest(
        ApiConstants.LicenseInfoService(licenseType, licenseId),
        isHealthLicense: true);
    bool state = body['state'];
    dynamic data = body['data'];
    LicenseForHealthInformationResponse? result;
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_1");

    try {
      LicenseForHealthInformationResponse response =
          LicenseForHealthInformationResponse.fromJson(json.decode(data));
      result = response;
      if (!state) {
        error = result.data?.responseMessage ?? error;
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
            url: ApiConstants.LicenseInfoService(licenseType, licenseId),
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
    }
    return Tuple3<bool?, String?, LicenseForHealthInformationResponse?>(
        state, error, result);
  }

  Future<Tuple3<bool?, String?, HealthRequestDetails?>> getHealthRequestDetails(
      int requestId) async {
    String query = "$requestId";

    final body = await webServices.getApigeeRequest(
        ApiConstants.healthRequestDetails,
        isHealthLicense: true,
        relativePath: query);
    bool state = body['state'];
    dynamic data = body['data'];
    HealthRequestDetails? result;
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_1");

    try {
      HealthRequestDetails response =
          HealthRequestDetails.fromJson(json.decode(data));
      result = response;
      if (!state) {
        error = result.data?.responseMessage ?? error;
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
    return Tuple3<bool?, String?, HealthRequestDetails?>(state, error, result);
  }

  Future<Tuple3<bool?, String?, DeleteRequestResponse?>> deleteRequest(
      int requestId) async {
    String query = "$requestId";

    final body = await webServices.postApigeeRequest(ApiConstants.deleteRequest,
        isHealthLicense: true, relativePath: query);
    bool state = body['state'];
    dynamic data = body['data'];
    DeleteRequestResponse? result;
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_1");

    try {
      DeleteRequestResponse response =
          DeleteRequestResponse.fromJson(json.decode(data));
      result = response;
      if (!state) {
        error = result.data?.responseMessage ?? error;
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
    return Tuple3<bool?, String?, DeleteRequestResponse?>(state, error, result);
  }

  Future<Tuple4<bool?, String?, Uint8List?, String?>> downLoadAttachments(
      String id) async {
    String query = id;

    final body = await webServices.getApigeeRequestWithoutUTF(
        ApiConstants.downLoadAttachments,
        isHealthLicense: true,
        relativePath: query);
    bool state = body['state'];
    dynamic data = body['data'];
    Uint8List? result;
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_1");
    String? contentType = body['Content-Type'];

    try {
      // DeleteRequestResponse response =
      //     DeleteRequestResponse.fromJson(json.decode(data));
      result = data;

      if (!state) {
        //   error = result.data?.responseMessage ?? error;
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
    return Tuple4<bool?, String?, Uint8List?, String?>(
        state, error, result, contentType);
  }

  Future<Tuple4<bool?, String?, Uint8List?, String?>> downLoadLicense(
      String id) async {
    String query = id;

    final body = await webServices.getApigeeRequestWithoutUTF(
        ApiConstants.downLoadLicense,
        isHealthLicense: true,
        relativePath: query);
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
    return Tuple4<bool?, String?, Uint8List?, String?>(
        state, error, result, contentType);
  }

  Future<Tuple4<bool?, String?, Uint8List?, String?>>
      downloadLicenseClientImage() async {
    String query =
        "${(CommonProperties.userInfo?.idNo ?? "")}/${idTypeHandling(CommonProperties.userInfo?.getIdType() ?? "")}";
    final body = await webServices.getApigeeRequestWithoutUTF(
        ApiConstants.downLoadHealthCertificateImageProfile,
        isHealthLicense: true,
        relativePath: query);
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
    return Tuple4<bool?, String?, Uint8List?, String?>(
        state, error, result, contentType);
  }

  Future<Tuple4<bool?, String?, Uint8List?, String?>> downLoadCanceledLicense(
      String id) async {
    String query = id;

    final body = await webServices.getApigeeRequestWithoutUTF(
        ApiConstants.downLoadCanceledLicense,
        isHealthLicense: true,
        relativePath: query);
    bool state = body['state'];
    dynamic data = body['data'];
    Uint8List? result;
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_1");
    String? contentType = body['Content-Type'];

    try {
      // DeleteRequestResponse response =
      //     DeleteRequestResponse.fromJson(json.decode(data));
      result = data;

      if (!state) {
        //   error = result.data?.responseMessage ?? error;
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
    return Tuple4<bool?, String?, Uint8List?, String?>(
        state, error, result, contentType);
  }

  Future<Tuple3<bool?, String?, RatingInfoResponse?>> getRatingInfo(
      String serviceId) async {
    String query = serviceId;

    final body = await webServices.getApigeeRequest(ApiConstants.RatingInfo,
        isHealthLicense: true, relativePath: query, autoLogout: false);
    bool state = body['state'];
    dynamic data = body['data'];
    RatingInfoResponse? result;
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_1");

    try {
      RatingInfoResponse response =
          RatingInfoResponse.fromJson(json.decode(data));
      result = response;
      if (!state) {
        error = result.data?.responseMessage ?? error;
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
    return Tuple3<bool?, String?, RatingInfoResponse?>(state, error, result);
  }

  Future<Tuple3<bool?, String?, ListResponse?>> getCities(
      String baladiyahID) async {
    String query = baladiyahID;

    final body = await webServices.getApigeeRequest(
        ApiConstants.healthCertificatesCities.replaceAll("{}", query),
        isHealthLicense: true,
        autoLogout: false);
    bool state = body['state'];
    dynamic data = body['data'];
    ListResponse? result;
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_1");

    try {
      ListResponse response =
          ListResponse.fromJson(json.decode(data), city: true);
      result = response;
      if (!state) {
        error = result.data?.responseMessage ?? error;
      }
      if (result.data?.responseCode == "2") {
        error = "لا توجد مدن مفعله للخدمة في الموقع الذي قمت باختياره";
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
    return Tuple3<bool?, String?, ListResponse?>(state, error, result);
  }

  Future<Tuple3<bool?, String?, ListResponse?>> getHealthCenters(
      String baladiyahID) async {
    String query = baladiyahID;

    final body = await webServices.getApigeeRequest(
        ApiConstants.healthCertificatesCenters,
        isHealthLicense: true,
        relativePath: query,
        autoLogout: false);
    bool state = body['state'];
    dynamic data = body['data'];
    ListResponse? result;
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_1");

    try {
      ListResponse response = ListResponse.fromJson(json.decode(data));
      result = response;
      if (!state) {
        error = result.data?.responseMessage ?? error;
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
    return Tuple3<bool?, String?, ListResponse?>(state, error, result);
  }

  Future<Tuple3<bool?, String?, CheckUpdateClientPhoto?>> checkUpdatedPhoto(
      int requestId) async {
    final body = await webServices.getApigeeRequest(
        ApiConstants.updatedPersonalPhoto(requestId),
        isHealthLicense: true,
        autoLogout: false);
    bool state = body['state'];
    dynamic data = body['data'];
    CheckUpdateClientPhoto? result;
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_1");

    try {
      CheckUpdateClientPhoto response =
          CheckUpdateClientPhoto.fromJson(json.decode(data));
      result = response;
      if (!state) {
        error = response.data?.responseMessage ?? error;
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
    return Tuple3<bool?, String?, CheckUpdateClientPhoto?>(
        state, error, result);
  }

  Future<Tuple3<bool?, String?, SendOtpCertificateResult?>> sendOTPCertificate(
      String requestId) async {
    final body = await webServices.postApigeeRequest(
      ApiConstants.sendOTPCertificate(requestId),
      isHealthLicense: true,
    );
    bool state = body['state'];
    dynamic data = body['data'];
    SendOtpCertificateResult? result;
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_1");

    try {
      SendOtpCertificate response =
          SendOtpCertificate.fromJson(json.decode(data));
      result = response.data?.result;
      if (!state) {
        error = response.data?.responseMessage ?? error;
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
    return Tuple3<bool?, String?, SendOtpCertificateResult?>(
        state, error, result);
  }

  Future<Tuple3<bool?, String?, bool?>> verifyOTPCertificate(
      {required String requestId,
      required String otp,
      required String otpKey}) async {
    final body = await webServices.postApigeeRequest(
        ApiConstants.verifyOTPCertificate(requestId),
        isHealthLicense: true,
        body: {"otp": otp, "otpKey": otpKey});
    bool state = body['state'];
    dynamic data = body['data'];
    bool? result;
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_1");

    try {
      VerifyOtpCertificate response =
          VerifyOtpCertificate.fromJson(json.decode(data));
      result = response.data?.result;
      if (!state) {
        error = response.data?.responseMessage ?? error;
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
    return Tuple3<bool?, String?, bool?>(state, error, result);
  }

  Future<Tuple3<bool?, String?, LocationInfoResponse?>>
      getLocationInfo() async {
    try {
      final response = await webService.dio.get(
        ApiConstants.locationInfo,
      );

      final responseData = response.data as Map<String, dynamic>?;

      if (responseData == null) {
        throw Exception('Invalid response data');
      }

      final data = responseData['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('No data in response');
      }

      final responseCode = data['responseCode'] as String?;
      if (responseCode != '1') {
        final errorMessage =
            data['responseMessage'] as String? ?? 'Unknown error';
        throw Exception('Failed to load location info: $errorMessage');
      }

      final result = LocationInfoResponse.fromJson(responseData);
      return Tuple3<bool?, String?, LocationInfoResponse?>(true, "", result);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException) {
        rethrow;
      } else {
        try {
          //CommonFunctions.sendExceptionLog(exception: error, response: response);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        return Tuple3<bool?, String?, LocationInfoResponse?>(
            false, ("errors_server_error_2").tr(), null);
      }
    }
  }

  Future<Tuple3<bool?, String?, UpdatePhotoResponse?>> updatePhoto(
      {required String licenseNo,
      required String birthDate,
      required String otpToken,
      required int versionNo}) async {
    final body = await webServices.postApigeeRequest(
        ApiConstants.updateCertificatePhoto,
        isHealthLicense: true,
        body: {
          "birthDate": birthDate,
          "licenseNo": licenseNo,
          "otpToken": otpToken,
          "versionNo": versionNo
        });
    bool state = body['state'];
    dynamic data = body['data'];
    UpdatePhotoResponse? result;
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_1");

    try {
      UpdatePhotoResponse response =
          UpdatePhotoResponse.fromJson(json.decode(data));
      result = response;
      if (!state) {
        error = response.data?.responseMessage ?? error;
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
    return Tuple3<bool?, String?, UpdatePhotoResponse?>(state, error, result);
  }
}
