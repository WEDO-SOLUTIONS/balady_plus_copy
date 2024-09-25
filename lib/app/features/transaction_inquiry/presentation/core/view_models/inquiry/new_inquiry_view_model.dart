import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:tuple/tuple.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../../../data/general_inquiry_data.dart';
import '../../models/classification.dart';
import '../../models/classification_response_model.dart';
import '../../models/create_incident_result.dart';
import '../../services/inquiry_repository.dart';
import 'inquiry_view_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class NewInquiryViewModel extends BaseViewModel {
  final dataModel = locator<InquiryViewModel>();
  NewInquiryViewModel(this.inqTypeModel) {}
  final _repositry = InquiryRepository();
  bool isFormValid = false;
  CustomerVoiceReportTypeModel? inqTypeModel;

  String description = "";
  String splDescription = "";

  CreateIncidentResult? incidentResult;
  ClassificationResponse? get splClassification => dataModel.splClassification;
  List<DropDownItem> get splClassificationList =>
      dataModel.splClassificationList;
  SubMainClassification? mainAndSubClassificationItem;
  ClassificationItem? splClassificationItem;
  DropDownItem? splClassificationType;

  List<DropDownItem> municipalities = [
    DropDownItem(id: "002", name: ("makkah_municipality").tr()),
    DropDownItem(id: "003", name: ("madinah_municipality").tr()),
    DropDownItem(id: "004", name: ("riyadh_municipality").tr()),
    DropDownItem(id: "005", name: ("jeddah_municipality").tr()),
    DropDownItem(id: "006", name: ("eastern_municipality").tr()),
    DropDownItem(id: "007", name: ("asir_municipality").tr()),
    DropDownItem(id: "008", name: ("qassim_municipality").tr()),
    DropDownItem(id: "009", name: ("jizan_municipality").tr()),
    DropDownItem(id: "010", name: ("jouf_municipality").tr()),
    DropDownItem(id: "011", name: ("tabuk_municipality").tr()),
    DropDownItem(id: "012", name: ("hail_municipality").tr()),
    DropDownItem(id: "013", name: ("Alshmmalya_municipality").tr()),
    DropDownItem(id: "014", name: ("baha_municipality").tr()),
    DropDownItem(id: "015", name: ("njran_municipality").tr()),
    DropDownItem(id: "016", name: ("taif_municipality").tr()),
    DropDownItem(id: "017", name: ("alhasa_municipality").tr()),
    DropDownItem(id: "018", name: ("hafr_municipality").tr()),
  ];
  DropDownItem? municipalityType;
  setSPLClassificationType(DropDownItem? data) {
    ClassificationItem? e = dataModel.splClassification?.data
        .firstWhereOrNull((element) => element.id == data?.id);

    if (e != null) {
      splClassificationType = data;
      splClassificationItem = e;
    }
  }

  validateForm() {
    try {
      bool isvalid = false;
      if (splClassificationItem != null &&
          mainAndSubClassificationItem != null &&
          municipalityType != null &&
          description != null &&
          description.isNotEmpty) {
        isvalid = true;
      } else {
        isvalid = false;
      }

      if (splClassificationItem != null &&
          splClassificationItem?.name == "أخرى" &&
          splDescription.isEmpty) {
        isvalid = false;
      }
      if (!CommonFunctions.doesContainsLettrs(description)) {
        isvalid = false;
      }

      if (isFormValid != isvalid) {
        isFormValid = isvalid;
        notifyListeners();
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
  }

  Future createRequest() async {
    ///MMM
    ///
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.General_Inquiries_Send_Request_Event);

    Tuple3<bool?, String?, CreateIncidentResult?> response;
    String error = ("server_error_1").tr();
    try {
      showLoading();
      String? userId = CommonProperties.userInfo?.idNo;
      String? userMobile = CommonProperties.userInfo?.phone;
      String firstName = "";
      String middleName = "";
      String lastName = "";
      String birthDate = "";
      String mobileNumber = "";
      String email = "";

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

      var body = {
        "CustomerInformation": {
          if (userId != null && userId.startsWith("1"))
            "NationalID": CommonProperties.userInfo!.idNo!,
          if (userId != null && !userId.startsWith("1"))
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
          "MunicipalityID": municipalityType!.id,
        },
        "IncidentInformation": {
          "MainClassificationID":
              mainAndSubClassificationItem?.MainClassificationID ?? "",
          "SubClassificationID":
              mainAndSubClassificationItem?.SubClassificationID ?? "",
          "SplClassificationID": splClassificationItem?.id ?? "",
          "Priority": "",
          "ResponseTime": "",
          "IssueDescription": "$description",
          "Description": splDescription,
          "IsCallBackSelected": "false",
        }
      };
      response = await _repositry.createINQRequest(body);
      hideLoading();
      error = response.item2 ?? error;

      if (response.item1 == true &&
          response.item3 != null &&
          response.item3?.pyId != null) {
        incidentResult = response.item3;
        bool Function(Route<dynamic>) predicate =
            ModalRoute.withName(RouteName.bottomNavigation);
        navigation.currentState!.pushNamedAndRemoveUntil(
            RouteName.successRoute, predicate,
            arguments: SuccessScreenArgs(
                type: PAGE_TYPE.inquiry, idNumber: incidentResult?.pyId));

        CommonFunctions.sendUXCamEvent(
            UXCamEvents.finishServiceGeneralInquiries);

        CommonFunctions.sendUXCamEvent(
            UXCamEvents.General_Inquiries_Open_Success_Page_Event);

        return Future.value(true);
      } else {
        if (response.item3?.errors != null &&
            response.item3!.errors!.isNotEmpty) {
          String? errorId = response.item3!.errors![0].id;
          String duplicateRequestId = response.item3!.errors![0].pyID ?? "";
          error = response.item3!.errors![0].message ?? error;
          if (errorId == "CS_API_001") {
            error = ("duplicate_inq_error")
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
      hideLoading();
      showError(error.toString());
      return Future.value(false);
    }
  }

  void getMainAndSubClassifications(DropDownItem splClass) {
    showLoading();
    _repositry.getMainAndSubClassficiation(splClass.id!).then((value) {
      hideLoading();

      if (value.item3 != null) {
        setSPLClassificationType(splClass);
        mainAndSubClassificationItem = value.item3;
        splDescription = "";

        notifyListeners();
      } else {
        showError(value.item2 ?? "");
        notifyListeners();
      }
      validateForm();
    }).catchError((error) {
      hideLoading();
      String msg = ("server_error_1").tr();

      showError(msg);
    });
  }

  bool showSPLDescription() {
    return splClassificationItem != null &&
            splClassificationItem?.name != null &&
            splClassificationItem?.name == "أخرى"
        ? true
        : false;
  }
}
