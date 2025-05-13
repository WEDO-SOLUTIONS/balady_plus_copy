import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/not_authorized_indivivisual.dart';
import 'package:balady_plus/app/features/services/core/home_services_routes/home_services_route_names.dart';
import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';

import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show EnvType;
import 'package:smart_advisor/smart_advisor.dart';

void checkIfLogin(BuildContext context, Service service) {
  if (service.requireLogin) {
    switch (service.levelLogin) {
      case LevelLogin.sso:
        if (CommonProperties.isLoggedInMunicipality) {
          tackYouAction(context, service);
        } else {
          showDialog(
            context: context,
            builder: (ctx) => NeedLoginDialog(
              onSuccessLogin: (bool? isSuccess) async {
                if (isSuccess ?? false) {
                  tackYouAction(context, service);
                }
              },
            ),
          );
        }
        break;
      case LevelLogin.guest:
        tackYouAction(context, service);
        break;
    }
  } else {
    tackYouAction(context, service);
  }
}

void tackYouAction(BuildContext context, Service service) async {
  if (service.requireSelectedDelegator &&
      CommonProperties.selectedDelegator == null) {
    await BottomSheetDialog.showDraggableSheet(
      context,
      isFullHeight: false,
      dialogKeyName: DialogName.notAuthorizedIndivisualDialog,
      currentRouteName: RouteName.postersStartService,
      child: NotAuthorizedIndivisualDialog(),
    );
    if (CommonProperties.selectedDelegator != null) {
      tackYouAction(context, service);
    }
    return;
  }

  switch (service.actionType) {
    case ActionType.page:
      if (service.actionValue == "smart_advisor") {
        // this when open SmartAdvisor
        SmartAdvisor.navigateToSmartAdvisorApp(
          context: context,
          envType: sl<EnvType>(),
        );
      }
      // else if (service.actionValue == RouteName.NewAppointmentPage) {
      // bool isSuccess = await locator<NewAppointmentViewModel>().loadInitialData();
      // if (isSuccess) {
      //   NavigationService.navigatorKey.currentState!.pushNamed(
      //     RouteName.NewAppointmentPage,
      //   );
      // }
      // }
      // else if (service.actionValue == RouteName.DCCameraPage) {
      // bool isLocationAvailable =
      // await CommonFunctions.checkLocationSettings(context);
      // bool isCameraAllowed =
      // await CommonFunctions.checkCameraSettings(context);
      // if (isLocationAvailable && isCameraAllowed) {
      //   NavigationService.navigatorKey.currentState!.pushNamed(
      //     RouteName.DCCameraPage,
      //   );
      // }
      // }
      else {
        NavigationService.navigatorKey.currentState!.pushNamed(
          service.serviceId == null
              ? service.actionValue
              : HomeServicesRouteName.dynamicCardsServicesScreen,
          arguments:
              service.subServices.isNotEmpty ? service.subServices : service,
        );
      }
      break;
    // case ActionType.openDialog:
    // Widget widgetDialog = const SizedBox();
    // String dialogKeyName = "";
    // if (service.actionValue == "SnapSend") {
    // // old id 201
    // widgetDialog = BottomSheetWithActions(
    //   title:,
    //   body: VDAllTypesScreen(),
    // );
    // dialogKeyName = DialogName.vdTypesDialog;
    // } else if (service.actionValue == "daem") {
    // old id 406
    // dialogKeyName = DialogName.daemDialog;
    // widgetDialog = BottomSheetWithActions(
    //   title: "daem_select_category".tr(),
    //   body: const DaemTypeScreen(),
    // );
    // } else if (service.actionValue == "GeneralInquiryTypeScreen") {
    // old id 210 and 313
    // dialogKeyName = DialogName.InqueryDialog;
    // widgetDialog = BottomSheetWithActions(
    //   title: "select_category".tr(),
    //   body: const GeneralInquiryTypeScreen(),
    // );
    // } else if (service.actionValue == "municipalServiceRequest") {
    // old id 203
    // dialogKeyName = DialogName.msrDialog;
    // widgetDialog = BottomSheetWithActions(
    //   title: "select_category".tr(),
    //   body: const MSRTypeScreen(),
    // );
    // } else if (service.id == 302) {
    // await BottomSheetDialog.showDraggableSheet(
    //   context,
    //   isFullHeight: false,
    //   height: 300,
    //   child: CommercialPermitsScreen(
    //     onSelect: (int item) async {
    //       if (item == 1042) {
    //         await BottomSheetDialog.showDraggableSheet(
    //           context,
    //           isFullHeight: true,
    //           child: PermitsLicenseBottomSheetList(
    //             groupId: item,
    //           ),
    //         );
    //       }
    //     },
    //   ),
    // );
    // return;
    // }
    // await BottomSheetDialog.showDraggableSheet(
    //   NavigationService.navigatorKey.currentContext!,
    //   dialogKeyName: dialogKeyName,
    //   currentRouteName: "ServicesPage",
    //   child: widgetDialog,
    // );
    // break;
    case ActionType.openBaladyWebView:
      // if (service.id == 305) {
      //   CommonFunctions.sendUXCamEvent(
      //       UXCamEvents.startServiceSharedHousingLicense);
      // } else
      //   if (service.id == 306) {
      //     CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceEwaaPlatform);
      //   } else if (service.id == 309) {
      //     CommonFunctions.sendUXCamEvent(
      //         UXCamEvents.startServiceCommercialServices);
      //   } else if (service.id == 315) {
      //     CommonFunctions.sendUXCamEvent(
      //         UXCamEvents.startServiceConstructionServices);
      //   } else if (service.id == 220) {
      //     CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceMobileStores);
      //   }
      String url = service.actionValue;
      if (!CommonFunctions.isAppAR) {
        url = url.replaceAll("/ar/", "/en/");
      }
      CommonFunctions.openBaladyWebView(url);
      break;
  }
  if (service.eventName?.isNotEmpty ?? false) {
    CommonFunctions.sendUXCamEvent(service.eventName!);
  }
}
