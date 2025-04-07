import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';

import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:tuple/tuple.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../../../../../../core/services/local/helpers.dart';
import '../../../../../../core/services/local/navigation_services.dart';
import '../../../../../../core/utils/constants/remote_config.dart';
import '../../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../../../../vd/presentation/dialogs/duplicate_request_dialog.dart';
import '../../../../data/general_inquiry_data.dart';
import '../../../dialogs/municipal_cert_message_riyadh_dialog.dart';
import '../../../dialogs/municipality_dialog_msr.dart';
import '../../models/attachment_model.dart';
import '../../models/classification.dart';
import '../../models/create_incident_result.dart';
import '../../models/gis_location_result.dart';
import '../../models/selected_location.dart';
import '../../models/upload_file_result.dart';
import '../../services/customer_voice_repository.dart';
import 'new_msr_details_view_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class NewMSRViewModel extends BaseViewModel {
  final _repositry = locator<CustomerVoiceRepository>();
  bool isFormValid = false;

  CustomerVoiceReportTypeModel type = CustomerVoiceReportTypeModel(
      code: "", id: 0, title: "", key: "", icon: "");
  GisLocationResult? gisLocation;

  // SPL Classification parms
  SpecializedClassification? splClassifications;
  List<DropDownItem> splTypeList = [];
  DropDownItem? splType;
  SpecializedClassificationItem? selectedSplItem;

// SPL Classification Details
  SubMainClassification? selectedSplDetails;
  SplBusinessType? selectedSplBusinessItem;
  List<DropDownItem> splBusinessTypeList = [];
  DropDownItem? splBusinessType;

  String? splDescription;

  // incident Description
  String? desc;

  // attachments
  List<AttachmentData> attachments = [];

  bool hideSplBuisnessField = false;

  SelectedLocation selectedLocation = new SelectedLocation();

  //response
  CreateIncidentResult? createRequestresponse;

  bool uploadingDocumentsfailed = false;
  String? continueIncidentCreation;

  Future<bool> getMapGISInfo({required LatLng mapLocaton, bool? select}) async {
    showLoading();
    final GisLocationResult? response =
        await _repositry.getApigeeGisLocation(mapLocaton);
    hideLoading();
    if (response != null &&
        response.isSuccessfull != null &&
        response.isSuccessfull!) {
      if (checkMuncupality(response)) {
        if (response.adminMunicipalityId != gisLocation?.adminMunicipalityId) {
          getSPlList(
              category: type.code,
              snap: false,
              gis: response,
              select: select,
              location: mapLocaton);
        } else {
          this.gisLocation = response;
          selectedLocation.selectedLocation = mapLocaton;
          navigateToDetails(
              select: select, clearClassificationSelection: false);
        }
      }

      notifyListeners();
      return true;
    } else {
      //  showError("error3");
      showError(("server_error_1").tr());

      return false;
    }
  }

  Future<bool> getSPlList(
      {String? category,
      bool snap = true,
      GisLocationResult? gis,
      LatLng? location,
      bool? select = false}) async {
    showLoading();
    final Tuple3<bool?, String?, SpecializedClassification?> response =
        await _repositry.getMSRSPlList(gis?.adminMunicipalityId ?? "",
            category: category);
    hideLoading();
    if (response.item3?.splClassificationList?.isNotEmpty ?? false) {
      gisLocation = gis;
      selectedLocation.selectedLocation = location;

      setSplClassifications(response.item3);

      navigateToDetails(
          snap: snap, select: select, clearClassificationSelection: true);
      notifyListeners();

      return true;
    } else {
      // show Error
      showError(response.item2 ?? "");
      return false;
    }
  }

  Future createRequest(FileDataItem? file) async {
    ///MMM
    if (createRequestresponse != null) return true;
    Tuple3<bool?, String?, CreateIncidentResult?> response;
    String error = ("server_error_1").tr();
    try {
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.MunicipalServiceRequest_Submit_Event);

      showLoading();
      String? userId = CommonProperties.userInfo?.idNo;
      String? userMobile = CommonProperties.userInfo?.phone;
      String firstName = "";
      String middleName = "";
      String lastName = "";
      String birthDate = "";
      String mobileNumber = "";
      String email = "";

      if (CommonProperties.isLoggedInMunicipality) {
        firstName = CommonProperties.userInfo?.getFirstName() ?? "";
        middleName = CommonProperties.userInfo?.getMiddleName() ?? "";
        lastName = CommonProperties.userInfo?.getLastName() ?? "";
        birthDate =
            CommonProperties.userInfo?.getFormattedBirthDate(withDash: true) ??
                "";
        mobileNumber = !CommonProperties.userInfo!.phone!.startsWith("0")
            ? "0" + CommonProperties.userInfo!.phone!
            : CommonProperties.userInfo!.phone!;
        email = CommonProperties.userInfo!.mail != null
            ? CommonProperties.userInfo!.mail!
                .replaceAll("\u200e", '')
                .replaceAll("\u200f", '')
                .trim()
            : "";
      }

      var body = {
        "CustomerInformation": {
          if (CommonProperties.isLoggedInMunicipality &&
              userId != null &&
              userId.startsWith("1"))
            "NationalID": CommonProperties.userInfo!.idNo!,
          if (CommonProperties.isLoggedInMunicipality &&
              userId != null &&
              !userId.startsWith("1"))
            "IqamaID": "" + CommonProperties.userInfo!.idNo!,
          "FirstName": firstName,
          "MiddleName": middleName,
          "LastName": lastName,
          "DateOfBirth": birthDate,
          "MobileNumber": mobileNumber,
          "EmailAddress": email,
          "PreferredLanguage": "Arabic"
        },
        "LocationInfo": {
          "MunicipalityID": gisLocation!.adminMunicipalityId,
          "SubMunicipalityID": gisLocation!.municipalityId,
          "Sub_SubMunicipalityID": gisLocation!.subMunicipalityId,
          "Longitude": selectedLocation.selectedLocation?.longitude ?? "",
          "Latitude": selectedLocation.selectedLocation?.latitude ?? "",
          "Address": gisLocation?.getFullAddress() ?? "",
          "StreetName":
              gisLocation?.streetName != null ? gisLocation!.streetName : "",
          "DistrictName":
              gisLocation?.districtName != null ? gisLocation!.districtName : ""
        },
        "IncidentInformation": {
          "MainClassificationID":
              selectedSplDetails?.MainClassificationID ?? "",
          "SubClassificationID": selectedSplDetails?.SubClassificationID ?? "",
          "SplClassificationID": selectedSplItem?.id ?? "",
          "Priority": selectedSplItem?.priority ?? "",
          "ResponseTime": selectedSplItem?.respTime ?? "",
          "IssueDescription": desc,
          "Description": splDescription,
          "IsCallBackSelected": "false",
          "SCBusinessTypeID": selectedSplBusinessItem?.ID ?? "",
          "ParkID": "",
          "Isinzone": false,
          if (continueIncidentCreation != null)
            "ContinueIncidentCreation": continueIncidentCreation,
        }
      };
      response = await _repositry.createMSRRequest(body);

      error = response.item2 ?? error;

      if (response.item1 == true &&
          response.item3 != null &&
          response.item3?.pyId != null) {
        continueIncidentCreation = null;
        createRequestresponse = response.item3;
        return Future.value(true);
      } else {
        if (response.item3?.errors != null &&
            response.item3!.errors!.isNotEmpty) {
          String? errorId = response.item3!.errors![0].id;
          String duplicateRequestId = response.item3!.errors![0].pyID ?? "";
          error = response.item3!.errors![0].message ?? error;
          if (errorId == "CS_API_023") {
            continueIncidentCreation = null;
            showCustomDialog(DuplicateRequestDialog(
              onSelect: (bool value) {
                if (value) {
                  continueIncidentCreation = "Yes";
                  submitRequest(file);
                } else {
                  continueIncidentCreation = null;
                }
              },
              title: ("duplicate_request_title").tr(),
              body: ("duplicate_request_body").tr(),
              confirmButtonText: ("duplicate_request_dialog_yes").tr(),
              cancelButtonText: ("duplicate_request_dialog_no").tr(),
            ));
          } else if (errorId == "CS_API_001") {
            error = ("duplicate_request_error")
                .tr()
                .replaceAll("{}", duplicateRequestId);
            showError(error);
          } else {
            showError(error);
          }
        } else {
          showError(response.item2 ?? "");
        }
        return Future.value(false);
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      // hideLoading();
      showError(error.toString());
      return Future.value(false);
    }
  }

  Future uploadFile(
      {String? caseID,
      String? fileName,
      String? fileBase64,
      String? fileMemo,
      String? lastMemo,
      String? pyDescription,
      String? categoery}) async {
    Tuple3<bool?, String?, UploadFileResult?> response;
    try {
      response = await _repositry.uploadFile(caseID, fileName, fileBase64,
          fileMemo, lastMemo, pyDescription, categoery);

      if (response.item1 == true) {
        return Future.value(true);
      } else {
        response = await _repositry.uploadFile(caseID, fileName, fileBase64,
            fileMemo, lastMemo, pyDescription, categoery);
        if (response.item1 == true) {
          return Future.value(true);
        } else {
          return Future.value(false);
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
      // hideLoading();
      // showError(trans("server_error_1"));
      return Future.value(false);
    }
  }


  Future<void> submitRequest(FileDataItem? file) async {
    final response = await createRequest(file);

    if (response) {
      final caseID = createRequestresponse!.pzInsKey;

      if (file != null) {
        bool isUploaded = await uploadFile(
          caseID: caseID,
          fileName: file.fileName,
          fileBase64: file.fileBase64,
          categoery: "Initial",
          fileMemo: "",
          pyDescription: "",
        );
        print(isUploaded);
      }

      final responses = await Future.wait(attachments.map(
        (value) async {
          if (value.filePath != null &&
              value.base64 != null && //
              value.isUploaded == false) {
            // final fileBytes = await File(value.filePath!).readAsBytes();
            // String base64File = base64Encode(fileBytes);

            bool isUploaded = await uploadFile(
              caseID: caseID,
              fileName: value.fileName,
              fileBase64: value.base64,
              fileMemo: value.memo,
              categoery: "CustomerImage",
              pyDescription: value.id,
            );

            int index =
                attachments.indexWhere((element) => element.id == value.id);
            attachments[index].isUploaded = isUploaded;

            return isUploaded;
          }
        },
      ));

      if (responses.contains(false)) {
        uploadingDocumentsfailed = true;
        hideLoading();
        showError(("problem_in_uploading_files").tr());
        // locator<AttachDocumentViewModel>().notifyListeners();
      } else {
        uploadingDocumentsfailed = false;
        hideLoading();
        int count = 0;
        navigation.currentState!.pushNamedAndRemoveUntil(RouteName.successRoute,
            ModalRoute.withName(RouteName.bottomNavigation),
            arguments: SuccessScreenArgs(
                type: PAGE_TYPE.msr, idNumber: createRequestresponse?.pyId));

        CommonFunctions.sendUXCamEvent(
            UXCamEvents.MunicipalServiceRequest_Success_Event);
      }
    } else {
      hideLoading();
    }
  }

  void setSplClassifications(SpecializedClassification? data) {
    splClassifications = data;
    splTypeList = splClassifications!.splClassificationList!
        .map<DropDownItem>((e) => DropDownItem(id: e.id, name: e.name ?? ""))
        .toList();
  }

  void resetAll() {
    createRequestresponse = null;
    continueIncidentCreation = null;

    isFormValid = false;
    gisLocation = null;
    attachments = [];
    splType = null;
    splClassifications = null;
    splTypeList = [];
    desc = null;
    selectedSplItem = null;
    selectedSplDetails = null;
    splDescription = null;
    selectedLocation = new SelectedLocation();
    type = CustomerVoiceReportTypeModel(
        code: "", id: 0, key: "", title: "", icon: "");
  }

  static showCustomDialog(Widget dialog, {bool isDismiss = true}) {
    showDialog(
        context: NavigationService.navigatorKey.currentState!.context,
        barrierDismissible: isDismiss,
        builder: (ctx) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: dialog));
  }

  void navigateToDetails(
      {bool snap = true,
      bool? select = false,
      bool clearClassificationSelection = false}) {
    if (clearClassificationSelection) clearClassification();

    if (select ?? false) {
      navigation.currentState?.pop();
      locator<NewMSRDetailsViewModel>().notifyListeners();
    } else {
      navigation.currentState!.pushNamed(RouteName.newMSRPage);
    }
  }

  bool checkMuncupality(GisLocationResult? gisResult) {
    bool isAllowed = false;
    bool isExcepted = false;

    if (gisResult?.adminMunicipalityId == null) {
      showError(("gis_error_1").tr());
      return false;
    }

    if (gisResult?.ErrorCode == 100) {
      showError(("outside_saudiArabia").tr());
      return false;
    }

    bool isInRiyadh = gisResult?.adminMunicipalityId == "004";

    if (isInRiyadh) {
      showDialog(
          context: NavigationService.navigatorKey.currentState!.context,
          barrierDismissible: true,
          builder: (ctx) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: MunicipalMessageRiyadhDialog())).then((value) {
        if (value == true) {
          navigation.currentState?.pop();
          navigation.currentState?.pop();
        }
      });
    } else {
      if (gisResult?.adminMunicipalityId != null) {
        isAllowed = RemoteConfig.MSRAllowedMuncipalites.contains(
            gisResult!.adminMunicipalityId!);
      }

      if (!isAllowed) {
        showCustomDialog(MunicipalityMSRDialog());
      } else {
        isExcepted = Helpers.checkForExpectedVD(gisResult);
      }
    }
    return isAllowed && !isExcepted;
  }

  /** Clears the Special classification selection if the admin municiplaity changes */
  void clearClassification() {
    attachments = [];
    splType = null;
    selectedSplItem = null;
    selectedSplDetails = null;
    selectedSplBusinessItem = null;
    splBusinessTypeList = [];
    splBusinessType = null;
    splDescription = null;
  }
}
