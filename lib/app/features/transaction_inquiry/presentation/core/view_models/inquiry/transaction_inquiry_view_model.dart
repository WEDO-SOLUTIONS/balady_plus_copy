import 'dart:convert';

import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../../../../../../core/remote_services/web_service.dart';
import '../../../../../../core/services/local/navigation_services.dart';
import '../../../../../_shared_feature_/data/entities/drop_down_item.dart';
import '../../models/inquiry_transaction_response.dart';

class TransactionInquiryViewModel extends BaseViewModel {
  bool isFormValid = false;
  DropDownItem? type = DropDownItem(id: "1", name: "معاملات واردة");
  String refrenceNumber = "";
  String? year;
  DropDownItem? municipality;
  // Item municipality = Item(id: "2", name: "أمانة حفر الباطن");

  List<DropDownItem> types = [DropDownItem(id: "1", name: "معاملات واردة")];
  List<DropDownItem> municipalities = [
    DropDownItem(id: "1", name: "وزارة الشؤون البلدية والقروية والإسكان"),
    DropDownItem(id: "2", name: "أمانة حفر الباطن"),
    DropDownItem(id: "3", name: "أمانة منطقة تبوك"),
    DropDownItem(id: "4", name: "أمانة منطقة حائل"),
    DropDownItem(id: "5", name: "أمانة الحدود الشمالية"),
    DropDownItem(id: "6", name: "أمانة منطقة جازان"),
    DropDownItem(id: "7", name: "أمانة منطقة الجوف"),
    DropDownItem(id: "8", name: "أمانة الطائف"),
    DropDownItem(id: "9", name: "أمانة منطقة القصيم"),
    DropDownItem(id: "10", name: "أمانة منطقة عسير"),
    DropDownItem(id: "11", name: "أمانة منطقة الرياض"),
    DropDownItem(id: "12", name: "أمانة العاصمة المقدسة"),
    DropDownItem(id: "13", name: "أمانة منطقة المدينة المنورة"),
    DropDownItem(id: "14", name: "أمانة منطقة الشرقية"),
    DropDownItem(id: "15", name: "أمانة منطقة الإحساء"),
    DropDownItem(id: "16", name: "أمانة محافظة جدة"),
    DropDownItem(id: "17", name: "أمانة منطقة الباحة"),
    DropDownItem(id: "18", name: "أمانة منطقة نجران"),
  ];
  final webServices = locator<WebService>();
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
    try {
      body = await webServices
          .postApigeeRequest("/v1/cts/document-details", body: {
        "type": type?.id,
        "year": year,
        "referenceNumber": refrenceNumber,
        "branchId": municipality?.id
      });
      hideLoading();
      //print("Ressssponse");
      // print(body["data"]);
      var status = body["state"];
      InquiryTransactionResponse response =
          InquiryTransactionResponse.fromJson(json.decode(body["data"]));
      if (response != null &&
          response.data != null &&
          status &&
          response.data?.responseCode == 1) {
        this.response = response;
        //MM
        /* NavigationService.navigatorKey.currentState!
            .pushNamed(RouteName.inquiryDetailsRoute, arguments: this.response);
*/
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
    } catch (ex) {
      print("ex");
      print(ex);
      hideLoader();
      String msg = ("server_error_1").tr();
      if (body != null && body["error"] != null)
        showError(body["error"]);
      else
        showError(msg);

      try {
        /* Helpers.sendLog(
            url: "/v1/cts/document-details",
            data: body["data"],
            errorMsg: ex.toString());*/
      } catch (ex) {}

      return Future.value(false);
    }
    return Future.value(false);
  }
}
