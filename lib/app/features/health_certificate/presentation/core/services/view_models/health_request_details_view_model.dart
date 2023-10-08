import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../../../../../../core/services/local/helpers.dart';
import '../../../../../../core/services/local/navigation_services.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/utils/enums/health_certificate.dart';
import '../../../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../../../../_shared_feature_/presentation/pages/pdf_view.dart';
import '../../models/cancel_health_certificate_response.dart';
import '../../models/delete_request_response.dart';
import '../../models/health_request_details.dart';
import '../../models/submit_new_request_response.dart';
import 'new_health_license_view_model.dart';

class HealthRequestDetailsViewModel extends BaseViewModel {
  final dataModel = locator<HealthLicenseViewModel>();

  HealthRequestDetails? requestDetails;
  bool? isDeletable;
  bool? isPrintable;

  HealthRequestDetailsViewModel(
      {this.requestDetails, this.isDeletable, this.isPrintable});

  Future<DeleteRequestResponse?> deleteHealthRequest() async {
    print(requestDetails?.data?.result?.requestId);
    DeleteRequestResponse? result = await dataModel
        .deleteHealthRequest(requestDetails?.data?.result?.requestId ?? 0);

    if (result != null &&
        result.data?.result != null &&
        result.data?.result == true) {
      //MM locator<MainHealthLicenseViewModel>().getMyHealthLicensesAndRequests();
      NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
          RouteName.successRoute,
          ModalRoute.withName(RouteName.bottomNavigation),
          arguments: SuccessScreenArgs(type: PAGE_TYPE.deleteRequestScreen));
    }
    return result;
  }

  Future<SubmitNewRequestResponse?> submitRequest() async {
    bool isRenew =
        requestDetails?.data?.result?.requestTypeId == 1303 ? true : false;
    SubmitNewRequestResponse? result = await dataModel.submitRequest(
        requestDetails?.data?.result?.requestId ?? 0,
        renewLicense: isRenew);

    if (result != null &&
        result.data?.result != null &&
        result.data?.result?.requestId != null) {
      //MM locator<MainHealthLicenseViewModel>().getMyHealthRequests(showLoad: true);
      NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
          RouteName.successRoute,
          ModalRoute.withName(RouteName.bottomNavigation),
          arguments: SuccessScreenArgs(
              type: PAGE_TYPE.licenseScreen,
              idNumber: result.data?.result?.requestId.toString() ?? "",
              msg: result.data?.result?.message));
    }
    return result;
  }

  Future<CancelHealthCertificateResponse?> cancelHealthCertificate(
      int certificateNumber) async {
    CancelHealthCertificateResponse? result =
        await dataModel.cancelHealthCertificate(certificateNumber);

    if (result != null && result.data?.result?.requestId != null) {
      //MM   locator<MainHealthLicenseViewModel>().getMyHealthLicensesAndRequests();
      NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
          RouteName.successRoute,
          ModalRoute.withName(RouteName.bottomNavigation),
          arguments: SuccessScreenArgs(
              type: PAGE_TYPE.licenseScreen,
              idNumber: result.data?.result?.requestId.toString() ?? "",
              msg: result.data?.result?.message ?? ""));
    }
    return result;
  }

  Future<Uint8List?> downLoadAttachment(String id) async {
    /*if (requestDetails?.data?.result?.requestAttachments != null) {
      List<Uint8List?> res = await Future.wait(requestDetails!
          .data!.result!.requestAttachments!
          .map((e) => dataModel.downloadAttachments(e.attachUrl ?? "")));
      print(res);
      print(res.length);
    }*/
    Tuple2<Uint8List?, String?> res = await dataModel.downloadAttachments(id);
    if (res.item1 != null) showFile(res.item1!, contentType: res.item2);
  }

  LICENSE_MANAGEMENT_STATUS isOrderDeletable() {
    return isDeletable == true
        ? LICENSE_MANAGEMENT_STATUS.DRAFT
        : LICENSE_MANAGEMENT_STATUS.DONE;
  }

  bool isValidToSubmit() {
    return requestDetails?.data?.result?.validToSubmit ?? false;
  }

  void showFile(Uint8List bytes, {String? contentType}) async {
    print("content toye");
    print(contentType);
    try {
      if (contentType?.toLowerCase().contains("pdf") ?? false) {
        Navigator.push(NavigationService.navigatorKey.currentState!.context,
            MaterialPageRoute(builder: (context) => PDFViewer(file: bytes)));
      } else if (contentType?.toLowerCase().contains("image") ?? false) {
        Navigator.push(
            NavigationService.navigatorKey.currentState!.context,
            MaterialPageRoute(
                builder: (context) => FullImageViewBytes(imageBase64: bytes)));
      } else {
        openFile(bytes, contentType: contentType);
      }
    } catch (ex) {}
  }

  void openFile(Uint8List bytes, {String? contentType}) async {
    print("content toye");
    print(contentType);
    String extension =
        contentType != null ? ("." + contentType.split("/").last) : "";
    try {
      if (extension.isNotEmpty) {
        String dir = (await getTemporaryDirectory()).path;
        File filetemp = File("$dir/" +
            "${DateTime.now().millisecondsSinceEpoch.toString()}$extension");
        await filetemp.writeAsBytes(bytes);
        print(filetemp.path);

        OpenFile.open(filetemp.path).then((value) {});
      }
    } catch (ex) {
      print(ex);
    }
  }

  bool showExamanationData() {
    return requestDetails?.data?.result?.medicalExamInfo != null;
  }

  bool showAttachments() {
    return requestDetails?.data?.result?.requestAttachments?.isNotEmpty ??
        false;
  }

  bool showNotes() {
    return requestDetails?.data?.result?.notes?.isNotEmpty ?? false;
  }

  bool showBillsInfo() {
    return requestDetails?.data?.result?.billInfo != null;
  }

  void printLicense() async {
    String? licenseId = requestDetails
        ?.data?.result?.healthCertificateInfo?.certificateId
        .toString();
    if (licenseId != null) {
      if (isPrintable == true) {
        Tuple2<Uint8List?, String?> res =
            await dataModel.downloadLicense(licenseId);

        if (res.item1 != null) openFile(res.item1!, contentType: res.item2);
      } else if (requestDetails?.getLicenseStatus() ==
          LICENSE_MANAGEMENT_STATUS.CANCELED) {
        Tuple2<Uint8List?, String?> res =
            await dataModel.downloadCanceledLicense(licenseId);

        if (res.item1 != null) openFile(res.item1!, contentType: res.item2);
      } else if (requestDetails?.getLicenseStatus() ==
          LICENSE_MANAGEMENT_STATUS.HOLDED) {
        showError(Helpers.translatingWord(
            "print_license_not_available_holded_error"));
      } else {
        showError(Helpers.translatingWord("print_license_not_available"));
      }
    }
  }
}
