import 'dart:convert';

import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../../../../../../core/remote_services/pega_web_service.dart';
import '../../../../../../core/services/local/helpers.dart';
import '../../../../../../core/services/local/navigation_services.dart';
import '../../../../../../core/utils/app_analytics_events.dart';
import '../../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../_shared_feature_/data/entities/drop_down_item.dart';
import '../../models/inquiry_transaction_response.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';


class TransactionInquiryViewModel extends BaseViewModel {
  bool isFormValid = false;
  DropDownItem? type = DropDownItem(id: "1", name: "inq_incoming".tr());
  String refrenceNumber = "";
  String? year;
  DropDownItem? municipality;

  List<DropDownItem> types = [DropDownItem(id: "1", name: "inq_incoming".tr())];
  List<DropDownItem> municipalities = [
    DropDownItem(id: "1", name: "transation_inquiry_1".tr()),
    DropDownItem(id: "2", name: "hafr_municipality_1".tr()),
    DropDownItem(id: "3", name: "tabuk_municipality".tr()),
    DropDownItem(id: "4", name: "hail_municipality".tr()),
    DropDownItem(id: "5", name: "Alshmmalya_municipality_1".tr()),
    DropDownItem(id: "6", name: "jizan_municipality".tr()),
    DropDownItem(id: "7", name: "jouf_municipality".tr()),
    DropDownItem(id: "8", name: "taif_municipality_1".tr()),
    DropDownItem(id: "9", name: "qassim_municipality".tr()),
    DropDownItem(id: "10", name: "asir_municipality".tr()),
    DropDownItem(id: "11", name: "riyadh_municipality".tr()),
    DropDownItem(id: "12", name: "makkah_municipality".tr()),
    DropDownItem(id: "13", name: "madinah_municipality".tr()),
    DropDownItem(id: "14", name: "eastern_municipality".tr()),
    DropDownItem(id: "15", name: "alhasa_municipality_1".tr()),
    DropDownItem(id: "16", name: "jeddah_municipality".tr()),
    DropDownItem(id: "17", name: "baha_municipality".tr()),
    DropDownItem(id: "18", name: "njran_municipality".tr()),
  ];
  final webServices = locator<PegaWebService>();
  InquiryTransactionResponse? response;

  void validateForm() {
    bool isValid = false;

    if (municipality != null &&
        year != null &&
        (year?.isNotEmpty ?? false) &&
        refrenceNumber != null &&
        refrenceNumber.isNotEmpty &&
        type != null) {
      isValid = true;
    }

    if (isValid != isFormValid) {
      isFormValid = isValid;
      notifyListeners();
    }
  }

  Future<bool> geRequestDetails() async {
    hideKeyboard();
    showLoading();
    var body;
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.RequestFollowUp_Send_Request_Event);
    try {
      body = await webServices
          .postApigeeRequest("/v1/cts/document-details", body: {
        "type": type?.id,
        "year": CommonFunctions.replaceArabicNumberWithEnglish(year ?? ""),
        "referenceNumber": refrenceNumber,
        "branchId": municipality?.id
      });

      hideLoading();

      var status = body["state"];
      InquiryTransactionResponse response =
          InquiryTransactionResponse.fromJson(json.decode(body["data"]));
      if (response != null &&
          response.data != null &&
          status &&
          response.data?.responseCode == 1) {
        this.response = response;
        CommonFunctions.sendEventToAnalytics(
            AppEvents.TransactionInquirySuccess);

        CommonFunctions.sendUXCamEvent(
            UXCamEvents.finishServiceRequestFollowUp);

        NavigationService.navigatorKey.currentState!.pushNamed(
            RouteName.inquiryDetailsScreen,
            arguments: this.response);
        CommonFunctions.sendUXCamEvent(
            UXCamEvents.RequestFollowUp_Open_Success_Page_Event);

        notifyListeners();
        return Future.value(true);
      } else {
        if (response != null &&
            response.data != null &&
            response.data?.responseMessage != null) {
          String? error = response.data?.responseMessage;
          if (response.data?.responseCode == 2 ||
              response.data?.responseCode == "006") {
            error = ("no_records_founds").tr();
          }

          showError(error ?? "");
        } else if (body["error"] != null)
          showError(body["error"]);
        else
          showError(("server_error_1").tr());
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
      hideLoader();
      String msg = ("server_error_1").tr();
      if (body != null && body["error"] != null)
        showError(body["error"]);
      else
        showError(msg);

      try {
        Helpers.sendLog(
            url: "/v1/cts/document-details",
            data: body["data"],
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

      return Future.value(false);
    }
    return Future.value(false);
  }
}
