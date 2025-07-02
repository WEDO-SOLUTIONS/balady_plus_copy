import 'dart:typed_data';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:dgis_map/library.dart';

import 'package:tuple/tuple.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../../../../../transaction_inquiry/presentation/core/models/gis_location_result.dart';
import '../../../../../transaction_inquiry/presentation/core/models/selected_location.dart';
import '../../models/apply_new_health_request.dart';
import '../../models/location_info_response.dart';
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
import '../../models/profession.dart';
import 'new_details_health_license_view_model.dart';

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
  Profession? _selectedProfession;
  Profession? get selectedProfession => _selectedProfession;
  set selectedProfession(Profession? value) {
    _selectedProfession = value;
    notifyListeners();
  }

  String shopHasLicense = "0";
  String noLicenseReason = "0";
  LicenseType? selectedLicesnseType;

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
    _selectedProfession = null;
  }

  Future<Tuple3<bool?, String?, GisLocationResult?>> getGisInfo(
      LatLng location) async {
    showLoading();

    Tuple3<bool?, String?, GisLocationResult?> response =
        await _rpository.getGisLocation(location);
    hideLoading();
    return Future.value(response);
    if (response.item3 != null &&
        response.item3?.isSuccessfull != null &&
        response.item3!.isSuccessfull!) {
      gisLocationResult = response.item3;
      //  return true;
    }
    // return false;
  }

  Future<bool> validateHealthCertificate(GisLocationResult? result) async {
    String userId = CommonProperties.userInfo?.idNo ?? "";
    String idType = CommonProperties.userInfo?.idType ?? "";
    String birthDate = CommonProperties.userInfo?.getHijriBirthDate() ?? "";
    bool isSaudi = userId.startsWith("1");

    showLoading();
    String muncipalityid = result?.municipalityId ?? "";
    // muncipalityid = "013001002";
    Tuple3<bool?, String?, ValidateHealthCertificateResponse?> response =
        await _rpository.validateHealthCertificate(
            userId, idType, birthDate, muncipalityid, isSaudi,
            isRenew: isRenew);
    hideLoading();
    if (response.item3 != null &&
        response.item3?.data != null &&
        response.item1 != null &&
        response.item1!) {
      gisLocationResult = result;
      validateHealthCertificateResponse = response.item3;
      return true;
    } else {
      showError(response.item2 ?? "");
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
      String muncipalityid = gisLocationResult?.municipalityId ?? "";
      Tuple3<bool?, String?, List<String>?> response =
          await _rpository.getTerms(
              birthDate,
              muncipalityid,
              noLicenseReason == "2" &&
                  validateHealthCertificateResponse
                          ?.data?.result?.showAreaNoLicencePermit ==
                      true,
              isRenew: isRenew);
      hideLoading();
      terms = response.item3;
      if (response.item3 != null && response.item1 != null && response.item1!) {
        terms = response.item3;
        return response.item3;
      } else {
        showError(response.item2 ?? "");
      }

      return response.item3;
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
    return null;
  }

  Future<ApplyNewHealthRequest?> applyHealthCertificate() async {
    String userId = CommonProperties.userInfo?.idNo ?? "";
    String idType = CommonProperties.userInfo?.getIdType() ?? "";

    String birthDate = CommonProperties.userInfo?.getHijriBirthDate() ?? "";
    bool isSaudi = userId.startsWith("1");
    String mobile = CommonProperties.userInfo?.phone ?? "";

    // Get coordinates from cached LocationInfo or fallback to selectedLocation
    final detailsModel = locator<NewDetailsHealthLicenseViewModel>();
    final coordinates = await detailsModel.getCoordinates();
    double x = coordinates.item1;
    double y = coordinates.item2;

    String? crType = "CR";

    String muncipalityid = gisLocationResult?.municipalityId ?? "";
    //muncipalityid = "003201";

    if (validateHealthCertificateResponse?.data?.result?.showLicense ??
        false) {}
    showLoading();

    Tuple3<bool?, String?, ApplyNewHealthRequest?> response =
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
            selectedProfession?.id,
            selectedHealthCentres?.idNumber,
            selectedLicesnseType?.value,
            gisLocationResult?.Balady_DistrictID,
            isRenew: isRenew);
    hideLoading();
    ApplyNewHealthRequest? applyNewHealthRequest;
    if (response.item3 != null &&
        response.item3?.data != null &&
        response.item1 != null &&
        response.item1!) {
      applyNewHealthRequest = response.item3;
      return applyNewHealthRequest;
    } else {
      showError(response.item2 ?? "");
    }

    return applyNewHealthRequest;
  }

  Future<CancelHealthCertificateResponse?> cancelHealthCertificate(
      int certificateNumber) async {
    String birthDate = CommonProperties.userInfo?.getHijriBirthDate() ?? "";
    String mobile = CommonProperties.userInfo?.phone ?? "";

    showLoading();

    Tuple3<bool?, String?, CancelHealthCertificateResponse?> response =
        await _rpository.cancelHealthCertificate(
            birthDate, mobile, certificateNumber);
    hideLoading();
    if (response.item3 != null &&
        response.item3?.data != null &&
        response.item1 != null &&
        response.item1!) {
      return response.item3;
    } else {
      showError(response.item2 ?? "");
    }

    return null;
  }

  Future<SubmitNewRequestResponse?> submitRequest(int requestId,
      {bool? renewLicense}) async {
    showLoading();
    bool renew = renewLicense ?? isRenew;
    Tuple3<bool?, String?, SubmitNewRequestResponse?> response =
        await _rpository.submitRequest(requestId, isRenew: renew);
    hideLoading();
    if (response.item3 != null &&
        response.item3?.data != null &&
        response.item1 != null &&
        response.item1!) {
      return response.item3;
    } else {
      showError(response.item2 ?? "");
    }

    return null;
  }

  Future<DeleteRequestResponse?> deleteHealthRequest(int requestNumber) async {
    showLoading();

    Tuple3<bool?, String?, DeleteRequestResponse?> response =
        await _rpository.deleteRequest(requestNumber);
    hideLoading();
    if (response.item3 != null &&
        response.item3?.data != null &&
        response.item1 != null &&
        response.item1!) {
      return response.item3;
    } else {
      showError(response.item2 ?? "");
    }

    return null;
  }

  Future<Tuple2<Uint8List?, String?>> downloadAttachments(String id) async {
    showLoading();

    Tuple4<bool?, String?, Uint8List?, String?> response =
        await _rpository.downLoadAttachments(id);
    hideLoading();
    if (response.item3 != null && response.item1 != null && response.item1!) {
      return Tuple2<Uint8List?, String?>(
        response.item3,
        response.item4,
      );
    } else {
      showError(response.item2 ?? "");
    }

    return Tuple2<Uint8List?, String?>(
      response.item3,
      response.item4,
    );
  }

  Future<Tuple2<Uint8List?, String?>> downloadLicense(String id) async {
    showLoading();

    Tuple4<bool?, String?, Uint8List?, String?> response =
        await _rpository.downLoadLicense(id);
    hideLoading();

    if (response.item3 != null && response.item1 != null && response.item1!) {
      return Tuple2<Uint8List?, String?>(response.item3, response.item4);
    } else {
      showError(response.item2 ?? "");
    }
    return Tuple2<Uint8List?, String?>(response.item3, response.item4);
  }

  Future<Tuple2<Uint8List?, String?>> downloadCanceledLicense(String id) async {
    showLoading();

    Tuple4<bool?, String?, Uint8List?, String?> response =
        await _rpository.downLoadCanceledLicense(id);
    hideLoading();
    if (response.item3 != null && response.item1 != null && response.item1!) {
      return Tuple2<Uint8List?, String?>(response.item3, response.item4);
    } else {
      showError(response.item2 ?? "");
    }

    return Tuple2<Uint8List?, String?>(response.item3, response.item4);
  }

  Future<bool> getCrInfo(String crNumber) async {
    showLoading();

    Tuple3<bool?, String?, CrInformationResponse?> response =
        await _rpository.getCrInformation(crNumber);
    hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result?.crInfo != null) {
      crInformation = response.item3;
      return true;
    } else {
      showError(response.item2 ?? "");
    }
    return false;
  }

  Future<bool> getHealthLicenseInfo(
      String licenseId, String licenseType) async {
    showLoading();
    // int requestType = isRenew ? 1303 : 1301;
    Tuple3<bool?, String?, LicenseForHealthInformationResponse?> response =
        await _rpository.getLicenseInformation(licenseId, licenseType);
    hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result != null) {
      licenseForHealthInformationResponse = response.item3;
      return true;
    } else {
      showError(response.item2 ?? "");
    }
    return false;
  }

  Future<bool> getCities(String id) async {
    showLoading();
    Tuple3<bool?, String?, ListResponse?> response =
        await _rpository.getCities(id);
    hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result != null &&
        response.item3!.data!.result!.isNotEmpty) {
      cities = response.item3?.data?.result ?? [];

      return true;
    } else {
      showError(response.item2 ?? "");
    }
    return false;
  }

  Future<bool> getCenters(String cityId) async {
    showLoading();
    Tuple3<bool?, String?, ListResponse?> response =
        await _rpository.getHealthCenters(cityId);
    hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result != null) {
      healthCentres = response.item3?.data?.result ?? [];
      return true;
    } else {
      showError(response.item2 ?? "");
    }
    return false;
  }

  Future<Tuple3<bool?, String?, LocationInfoResponse?>>
      getLocationInfo() async {
    showLoading();
    try {
      final response = await _rpository.getLocationInfo();
      hideLoading();
      return response;
    } catch (e) {
      hideLoading();
      rethrow;
    }
  }
}
