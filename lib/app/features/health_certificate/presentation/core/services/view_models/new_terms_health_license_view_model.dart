import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../../../../../../core/services/local/navigation_services.dart';
import '../../../../../../core/utils/common_functions.dart';
import '../../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../models/apply_new_health_request.dart';
import '../../models/submit_new_request_response.dart';
import 'new_health_license_view_model.dart';

class NewTermsHealthLicenseViewModel extends BaseViewModel {
  final dataModel = locator<HealthLicenseViewModel>();
  List<String> terms = locator<HealthLicenseViewModel>()
          .validateHealthCertificateResponse
          ?.data
          ?.result
          ?.terms ??
      [];

  List<String> getTerms() {
    return dataModel.terms ?? [];
    List<String> combinedterms = [];
    String areaNoLicencePermit = dataModel.validateHealthCertificateResponse
            ?.data?.result?.notPermitLiceTerm ??
        "";
    if (dataModel.areaNoLicencePermit == true &&
        areaNoLicencePermit.isNotEmpty) {
      combinedterms.add(areaNoLicencePermit);
    }
    List<String> terms = locator<HealthLicenseViewModel>()
            .validateHealthCertificateResponse
            ?.data
            ?.result
            ?.terms ??
        [];
    combinedterms.addAll(terms);

    return combinedterms;
  }

  Future<ApplyNewHealthRequest?> submit() async {
    if (dataModel.isRenew) {
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.HealthCertificate_renew_Submit_Event);
    } else {
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.HealthCertificate_Issue_Submit_Event);
    }

    ApplyNewHealthRequest? response = await dataModel.applyHealthCertificate();

    if (response?.data?.result?.gotoRating == false &&
        response?.data?.result?.requestId != null) {
      SubmitNewRequestResponse? submitRequestResponse =
          await dataModel.submitRequest(response!.data!.result!.requestId!);
      if (submitRequestResponse != null) {
        navigateToSuccessScreen(
            requestIdNumber: submitRequestResponse.data!.result!.requestId!,
            msg: submitRequestResponse.data!.result!.message ?? "");

        CommonFunctions.sendUXCamEvent(
            UXCamEvents.finishServiceHealthCertificate);

        if (dataModel.isRenew) {
          CommonFunctions.sendUXCamEvent(
              UXCamEvents.HealthCertificate_renew_Success_Event);
        } else {
          CommonFunctions.sendUXCamEvent(
              UXCamEvents.HealthCertificate_Issue_Success_Event);
        }
      }
    } else {
      if (response?.data?.result?.requestId != null) {
        navigateToSuccessScreen(
            requestIdNumber: response!.data!.result!.requestId!,
            msg: response.data!.result!.message ?? "");

        CommonFunctions.sendUXCamEvent(
            UXCamEvents.finishServiceHealthCertificate);

        if (dataModel.isRenew) {
          CommonFunctions.sendUXCamEvent(
              UXCamEvents.HealthCertificate_renew_Success_Event);
        } else {
          CommonFunctions.sendUXCamEvent(
              UXCamEvents.HealthCertificate_Issue_Success_Event);
        }
      }
    }
  }

  void navigateToSuccessScreen(
      {required int requestIdNumber, required String msg}) {
    //MM  locator<MainHealthLicenseViewModel>().getMyHealthRequests(showLoad: true);
    NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
        RouteName.successRoute, ModalRoute.withName(RouteName.bottomNavigation),
        arguments: SuccessScreenArgs(
            type: PAGE_TYPE.licenseScreen,
            idNumber: requestIdNumber.toString(),
            msg: msg));
  }
}
