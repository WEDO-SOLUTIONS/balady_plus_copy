import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../../../../../transaction_inquiry/presentation/core/models/gis_location_result.dart';
import '../../../../../transaction_inquiry/presentation/core/models/selected_location.dart';
import '../../../widgets/map_screen.dart';
import '../../models/cr_information.dart';
import '../../models/license_for_health_information_response.dart';
import '../../models/validate_health_certificate_response.dart';
import 'new_health_license_view_model.dart';

class NewDetailsHealthLicenseViewModel extends BaseViewModel {
  final dataModel = locator<HealthLicenseViewModel>();
  String get userFullName => dataModel.userFullName;
  String get mobile => dataModel.userMobile;
  SelectedLocation get selectedLocation =>
      dataModel.selectedLocation ?? SelectedLocation();
  set selectedLocation(SelectedLocation data) =>
      dataModel.selectedLocation = data;

  GisLocationResult? get gisLocationResult => dataModel.gisLocationResult;
  ValidateHealthCertificateResponse? get validateHealthCertificateResponse =>
      dataModel.validateHealthCertificateResponse;
  CrInformationResponse? get crInformation => dataModel.crInformation;
  set crInformation(CrInformationResponse? data) =>
      dataModel.crInformation = data;

  LicenseForHealthInformationResponse?
      get licenseForHealthInformationResponse =>
          dataModel.licenseForHealthInformationResponse;
  set licenseForHealthInformationResponse(
          LicenseForHealthInformationResponse? data) =>
      dataModel.licenseForHealthInformationResponse = data;

  bool get isCrVerified => dataModel.isCrVerified;
  set isCrVerified(bool data) => dataModel.isCrVerified = data;
  set crNumber(String data) => dataModel.crNumber = data;

  bool get isLicenseVerified => dataModel.isLicenseVerified;
  set isLicenseVerified(bool data) => dataModel.isLicenseVerified = data;
  set licenseNumber(String data) => dataModel.licenseNumber = data;

  set areaNoLicencePermit(bool data) => dataModel.areaNoLicencePermit = data;
  String get shopHasLicense => dataModel.shopHasLicense;
  set shopHasLicense(String data) {
    dataModel.shopHasLicense = data;
    noLicenseReason = "0";
    areaNoLicencePermit = false;
  }

  String get noLicenseReason => dataModel.noLicenseReason;
  set noLicenseReason(String data) {
    dataModel.noLicenseReason = data;
    if (data == "1") areaNoLicencePermit = false;
    if (data == "2" && showAreaNoLicencePermit()) areaNoLicencePermit = true;
  }

  bool isFormValid = false;

  StreamController<String?> address = StreamController<String?>.broadcast();

  void init({bool isRenew = false}) {
    dataModel.init(isRenew: isRenew);
    address = StreamController<String?>.broadcast();
  }

  validateForm() {
    bool isValid = false;
    if (validateHealthCertificateResponse != null) {
      if (showCommercialNo()) {
        if (crInformation?.data?.result?.crInfo != null) {
          isValid = true;
        }
      } else if (showLicense()) {
        if (shopHasLicense == "1") {
          if (licenseForHealthInformationResponse?.data?.result != null) {
            isValid = true;
          }
        } else if (shopHasLicense == "2") {
          if (noLicenseReason == "1") {
            isValid = false;
          } else if (noLicenseReason == "2") {
            isValid = true;
          } else {
            isValid = false;
          }
        }
      } else {
        isValid = true;
      }

      if (isCenterRequired() && isValid == true) {
        if (dataModel.selectedCity != null &&
            dataModel.selectedHealthCentres != null)
          isValid = true;
        else {
          isValid = false;
        }
      }
    }

    isFormValid = isValid;
    notifyListeners();
  }

  Future navigateToMapScreen(BuildContext context, {bool isRenew = false}) {
    return navigation.currentState!.push(MaterialPageRoute(
      builder: (context) => MapScreen(
        showSearch: true,
        closeIcon: true,
        showSearchPaddingScreen: true,
        currentLocation: selectedLocation,
        onLocationChanged: (SelectedLocation selectedLocation) async {
          Tuple3<bool?, String?, GisLocationResult?> response =
              await dataModel.getGisInfo(selectedLocation.selectedLocation!);
          //print("HEREEE tt");
          //print(response.item3);
          bool isGISSuccess = false;
          if (response.item3 != null &&
              response.item3?.isSuccessfull != null &&
              response.item3!.isSuccessfull!) {
            isGISSuccess = true;
          }
          if (isGISSuccess) {
            //print("HEREEE 11");
            bool isValidMunicipality =
                await dataModel.validateHealthCertificate(response.item3);
            //print("HEREEE 22 ${isValidMunicipality}");

            bool isCitiesRetrived = isCenterRequired()
                ? await getCities(
                    gisLocationResult?.MUNICIPALITYUNIQUECODE ?? "")
                : true;
            //print("isCitiesRetrived 11 $isCitiesRetrived");
            // bool isCitiesRetrived1 =
            //   isCenterRequired() ? await getCenters("154") : true;

            if (isGISSuccess && isValidMunicipality && isCitiesRetrived) {
              this.selectedLocation = selectedLocation;
              shopHasLicense = "0";
              noLicenseReason = "0";
              crInformation = null;
              isCrVerified = false;
              crNumber = "";
              licenseForHealthInformationResponse = null;
              isLicenseVerified = false;
              licenseNumber = "";
              dataModel.healthCentres = [];
              dataModel.selectedCity = null;
              dataModel.selectedHealthCentres = null;

              //address.add(getAddress());
              notifyListeners();
              navigation.currentState?.pop();
            }
          } else {
            if (response.item2 != null) showError(response.item2!);
          }
          return true;
        },
      ),
    ));
  }

  Future<bool> getCrInfo(String crNumber) async {
    bool isSucess = await dataModel.getCrInfo(crNumber);
    isCrVerified = isSucess;
    if (isCrVerified) this.crNumber = crNumber;
    return isSucess;
  }

  Future<bool> getCities(String id) async {
    bool isSucess = await dataModel.getCities(id);

    return isSucess;
  }

  Future<bool> getCenters(String id) async {
    bool isSucess = await dataModel.getCenters(id);
    return isSucess;
  }

  Future<bool> getHealthLicenseInfo(String licenseId) async {
    bool isSucess = await dataModel.getHealthLicenseInfo(licenseId);
    isLicenseVerified = isSucess;
    if (isLicenseVerified) licenseNumber = licenseId;

    return isSucess;
  }

  String? getAddress() {
    return gisLocationResult?.getFullAddress();
  }

  bool showCommercialNo() {
    //return false;
    return validateHealthCertificateResponse?.data?.result?.showCommercialNo ??
        false;
  }

  bool showLicense() {
    //return true;
    return validateHealthCertificateResponse?.data?.result?.showLicense ??
        false;
  }

  bool isCenterRequired() {
    //return true;
    return validateHealthCertificateResponse?.data?.result?.showHealthCenters ??
        false;
  }

  bool showAreaNoLicencePermit() {
    return validateHealthCertificateResponse
            ?.data?.result?.showAreaNoLicencePermit ??
        false;
  }

  void changeCRAndLicenseValidation() {
    if (isCrVerified == true || isLicenseVerified == true) {
      isCrVerified = false;
      crInformation = null;
      isLicenseVerified = false;
      licenseNumber = "";
      crNumber = "";
      licenseForHealthInformationResponse = null;
      validateForm();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    address.close();
  }
}
