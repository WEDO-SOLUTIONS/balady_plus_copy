import 'dart:typed_data';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import '../../../../../../core/base/base_view_model.dart';
import '../../../../../transaction_inquiry/presentation/core/models/gis_location_result.dart';
import '../../../../../transaction_inquiry/presentation/core/models/selected_location.dart';
import '../../models/apply_new_health_request.dart';
import '../../models/cancel_health_certificate_response.dart';
import '../../models/cr_information.dart';
import '../../models/delete_request_response.dart';
import '../../models/license_for_health_information_response.dart';
import '../../models/licesnse_type.dart';
import '../../models/list_response.dart';
import '../../models/submit_new_request_response.dart';
import '../../models/validate_health_certificate_response.dart';
import '../repository/health_license_repository.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class HealthLicenseViewModel extends BaseViewModel {
  final _rpository = locator<HealthLicenseRepository>();
  bool isRenew = false;

  String userFullName = "";
  String userMobile = "";
  SelectedLocation? selectedLocation;
  GisLocationResult? gisLocationResult;
  CrInformationResponse? crInformation;
  LicenseForHealthInformationResponse? licenseForHealthInformationResponse;
  bool isCrVerified = false;
  String? crNumber;
  bool isLicenseVerified = false;
  String? licenseNumber;

  String shopHasLicense = "0";
  String noLicenseReason = "0";
  LicenseType? selectedLicesnseType = null;

  ValidateHealthCertificateResponse? validateHealthCertificateResponse;

  List<ListItem> cities = [];
  List<String>? terms = [];
  List<ListItem> healthCentres = [];
  ListItem? selectedCity;
  ListItem? selectedHealthCentres;

  //ApplyNewHealthRequest? applyNewHealthRequest;
  bool areaNoLicencePermit = false;
  init({bool isRenew = false}) {
    userFullName = CommonProperties.userInfo?.getFullName() ?? "";
    userMobile = CommonProperties.userInfo?.phone ?? "";
    selectedLocation = null;
    gisLocationResult = null;
    crInformation = null;
    licenseForHealthInformationResponse = null;
    isCrVerified = false;
    crNumber = null;
    isLicenseVerified = false;
    licenseNumber = null;
    areaNoLicencePermit = false;
    shopHasLicense = "0";
    noLicenseReason = "0";
    validateHealthCertificateResponse = null;
    this.isRenew = isRenew;
    selectedCity = null;
    selectedHealthCentres = null;
    healthCentres = [];
    cities = [];
    selectedLicesnseType = null;
  }

  Future<(bool?, String?, GisLocationResult?)> getGisInfo(
      LatLng location) async {
    showLoading();

    (bool?, String?, GisLocationResult?) response =
        await _rpository.getGisLocation(location);
    hideLoading();
    return Future.value(response);
    if (response.$3 != null &&
        response.$3?.isSuccessfull != null &&
        response.$3!.isSuccessfull!) {
      gisLocationResult = response.$3;
      //  return true;
    }
    // return false;
  }

  Future<bool> validateHealthCertificate(GisLocationResult? result) async {
    String userId = CommonProperties.userInfo?.idNo ?? "";
    String idType = CommonProperties.userInfo?.getIdType() ?? "";
    String birthDate = CommonProperties.userInfo?.getHijriBirthDate() ?? "";
    bool isSaudi = userId.startsWith("1");

    showLoading();
    String muncipalityid = result?.MUNICIPALITYUNIQUECODE ?? "";
    // muncipalityid = "013001002";
    (bool?, String?, ValidateHealthCertificateResponse?) response =
        await _rpository.validateHealthCertificate(
            userId, idType, birthDate, muncipalityid, isSaudi,
            isRenew: isRenew);
    hideLoading();
    if (response.$3 != null &&
        response.$3?.data != null &&
        response.$1 != null &&
        response.$1!) {
      gisLocationResult = result;
      validateHealthCertificateResponse = response.$3;
      return true;
    } else {
      showError(response.$2 ?? "");
    }

    return false;
  }

  Future<List<String>?> getTerms() async {
    try {
      print("getTerms");

      String userId = CommonProperties.userInfo?.idNo ?? "";
      String idType = CommonProperties.userInfo?.getIdType() ?? "";
      String birthDate = CommonProperties.userInfo?.getHijriBirthDate() ?? "";

      showLoading();
      String muncipalityid = gisLocationResult?.MUNICIPALITYUNIQUECODE ?? "";
      (bool?, String?, List<String>?) response =
          await _rpository.getTerms(
              userId,
              idType,
              birthDate,
              muncipalityid,
              noLicenseReason == "2" &&
                  validateHealthCertificateResponse
                          ?.data?.result?.showAreaNoLicencePermit ==
                      true,
              isRenew: isRenew);
      hideLoading();
      terms = response.$3;
      if (response.$3 != null && response.$1 != null && response.$1!) {
        terms = response.$3;
        return response.$3;
      } else {
        showError(response.$2 ?? "");
      }

      return response.$3;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
    }
  }

  Future<ApplyNewHealthRequest?> applyHealthCertificate() async {
    String userId = CommonProperties.userInfo?.idNo ?? "";
    String idType = CommonProperties.userInfo?.getIdType() ?? "";

    String birthDate = CommonProperties.userInfo?.getHijriBirthDate() ?? "";
    bool isSaudi = userId.startsWith("1");
    String mobile = CommonProperties.userInfo?.phone ?? "";
    double x = selectedLocation!.selectedLocation!.longitude;
    double y = selectedLocation!.selectedLocation!.latitude;

    String? crType = "CR";

    String muncipalityid = gisLocationResult?.MUNICIPALITYUNIQUECODE ?? "";
    //muncipalityid = "003201";

    if (validateHealthCertificateResponse?.data?.result?.showLicense ??
        false) {}
    showLoading();

    (bool?, String?, ApplyNewHealthRequest?) response =
        await _rpository.applyHealthCertificate(
            userId,
            idType,
            birthDate,
            muncipalityid,
            isSaudi,
            mobile,
            x,
            y,
            crType,
            crNumber,
            licenseNumber,
            areaNoLicencePermit,
            selectedHealthCentres?.idNumber,
            selectedLicesnseType?.value,
            gisLocationResult?.Balady_DistrictID,
            isRenew: isRenew);
    hideLoading();
    ApplyNewHealthRequest? applyNewHealthRequest;
    if (response.$3 != null &&
        response.$3?.data != null &&
        response.$1 != null &&
        response.$1!) {
      applyNewHealthRequest = response.$3;
      return applyNewHealthRequest;
    } else {
      showError(response.$2 ?? "");
    }

    return applyNewHealthRequest;
  }

  Future<CancelHealthCertificateResponse?> cancelHealthCertificate(
      int certificateNumber) async {
    String userId = CommonProperties.userInfo?.idNo ?? "";
    String idType = CommonProperties.userInfo?.idType ?? "";
    String birthDate = CommonProperties.userInfo?.getHijriBirthDate() ?? "";
    String mobile = CommonProperties.userInfo?.phone ?? "";

    showLoading();

    (bool?, String?, CancelHealthCertificateResponse?) response =
        await _rpository.cancelHealthCertificate(
            userId, idType, birthDate, mobile, certificateNumber);
    hideLoading();
    if (response.$3 != null &&
        response.$3?.data != null &&
        response.$1 != null &&
        response.$1!) {
      return response.$3;
    } else {
      showError(response.$2 ?? "");
    }

    return null;
  }

  Future<SubmitNewRequestResponse?> submitRequest(int requestId,
      {bool? renewLicense}) async {
    showLoading();
    bool renew = renewLicense ?? isRenew;
    (bool?, String?, SubmitNewRequestResponse?) response =
        await _rpository.submitRequest(requestId, isRenew: renew);
    hideLoading();
    if (response.$3 != null &&
        response.$3?.data != null &&
        response.$1 != null &&
        response.$1!) {
      return response.$3;
    } else {
      showError(response.$2 ?? "");
    }

    return null;
  }

  Future<DeleteRequestResponse?> deleteHealthRequest(int requestNumber) async {
    showLoading();

    (bool?, String?, DeleteRequestResponse?) response =
        await _rpository.deleteRequest(requestNumber);
    hideLoading();
    if (response.$3 != null &&
        response.$3?.data != null &&
        response.$1 != null &&
        response.$1!) {
      return response.$3;
    } else {
      showError(response.$2 ?? "");
    }

    return null;
  }

  Future<(Uint8List?, String?)> downloadAttachments(String id) async {
    showLoading();

    (bool?, String?, Uint8List?, String?) response =
        await _rpository.downLoadAttachments(id);
    hideLoading();
    if (response.$3 != null && response.$1 != null && response.$1!) {
      return (
        response.$3,
        response.$4,
      );
    } else {
      showError(response.$2 ?? "");
    }

    return (
      response.$3,
      response.$4,
    );
  }

  Future<(Uint8List?, String?)> downloadLicense(String id) async {
    showLoading();

    (bool?, String?, Uint8List?, String?) response =
        await _rpository.downLoadLicense(id);
    hideLoading();

    if (response.$3 != null && response.$1 != null && response.$1!) {
      return (response.$3, response.$4);
    } else {
      showError(response.$2 ?? "");
    }
    return (response.$3, response.$4);
  }

  Future<(Uint8List?, String?)> downloadCanceledLicense(String id) async {
    showLoading();

    (bool?, String?, Uint8List?, String?) response =
        await _rpository.downLoadCanceledLicense(id);
    hideLoading();
    if (response.$3 != null && response.$1 != null && response.$1!) {
      return (response.$3, response.$4);
    } else {
      showError(response.$2 ?? "");
    }

    return (response.$3, response.$4);
  }

  Future<bool> getCrInfo(String crNumber) async {
    showLoading();

    (bool?, String?, CrInformationResponse?) response =
        await _rpository.getCrInformation(crNumber);
    hideLoading();
    if (response.$1 != null &&
        response.$1! &&
        response.$3?.data?.result?.crInfo != null) {
      crInformation = response.$3;
      return true;
    } else {
      showError(response.$2 ?? "");
    }
    return false;
  }

  Future<bool> getHealthLicenseInfo(
      String licenseId, String licenseType) async {
    showLoading();
    // int requestType = isRenew ? 1303 : 1301;
    (bool?, String?, LicenseForHealthInformationResponse?) response =
        await _rpository.getLicenseInformation(licenseId, licenseType);
    hideLoading();
    if (response.$1 != null &&
        response.$1! &&
        response.$3?.data?.result != null) {
      licenseForHealthInformationResponse = response.$3;
      return true;
    } else {
      showError(response.$2 ?? "");
    }
    return false;
  }

  Future<bool> getCities(String id) async {
    showLoading();
    (bool?, String?, ListResponse?) response =
        await _rpository.getCities(id);
    hideLoading();
    if (response.$1 != null &&
        response.$1! &&
        response.$3?.data?.result != null &&
        response.$3!.data!.result!.isNotEmpty) {
      cities = response.$3?.data?.result ?? [];

      return true;
    } else {
      showError(response.$2 ?? "");
    }
    return false;
  }

  Future<bool> getCenters(String cityId) async {
    showLoading();
    (bool?, String?, ListResponse?) response =
        await _rpository.getHealthCenters(cityId);
    hideLoading();
    if (response.$1 != null &&
        response.$1! &&
        response.$3?.data?.result != null) {
      healthCentres = response.$3?.data?.result ?? [];
      return true;
    } else {
      showError(response.$2 ?? "");
    }
    return false;
  }
}
