import 'package:balady_plus/app/commercial_model/features/posters/presentation/widgets/license_widgets/bottom_sheet_list.dart';
import 'package:balady_plus/app/commercial_model/features/posters/presentation/widgets/types_dialog/commercial_permits_dialog.dart';
import 'package:balady_plus/app/core/utils/constants/apis/env_types.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/etmam_app/core/utils/enums/app_font_weight.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/utils_exports.dart'
    show CommonFunctions, CommonProperties, IconPath, RouteName, ServiceAction;
import '../../../_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../../_shared_feature_/presentation/dialogs/not_authorized_indivivisual.dart';
import '../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, BottomSheetWithActions, DrawIconBasedTypeWidget;
import '../../../daem/presentation/dialogs/daem_types_dialog.dart';
import '../../../new_appointment/presentation/core/services/view_models/new_appointment_view_model.dart';
import '../../../public_services_features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import '../../../transaction_inquiry/presentation/dialogs/general_inquiries_types_dialog.dart';
import '../../../transaction_inquiry/presentation/dialogs/new_request_types_dialog.dart';
import '../../../vd/domain/entities/camera/camera_page_params.dart';
import '../../../vd/domain/entities/categories/category_item.dart';
import '../../../vd/presentation/dialogs/vd_all_types_dialog.dart';
import '../../services_exports.dart';

import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:smart_advisor/smart_advisor.dart';

class ServiceIcon extends StatelessWidget {
  final ServiceEntity service;
  final double? width;
  final double? height;
  final Color? backgroundColor;

  const ServiceIcon(
      {super.key,
      required this.service,
      this.width,
      this.height,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    var context = NavigationService.navigatorKey.currentContext!;
    Color iconColor = CommonFunctions.isFoundationDay()
        ? const Color(0xff6B4E45)
        : const Color(0xff1E928F);
    return InkWell(
        onTap: () async {
          if (service.action.type == ServiceAction.pageRoute) {
            if (service.requireLogin != true) {
              if (service.id == 102) {
                NavigationService.navigatorKey.currentState!.pushNamed(
                  service.action.value,
                  arguments: NavigationService.bottomNavKey.currentContext!
                      .read<PrayerTimesCubit>(),
                );
              } else {
                NavigationService.navigatorKey.currentState?.pushNamed(
                  service.action.value,
                  arguments: null,
                );
              }
            } else {
              if (CommonProperties.isLoggedIn) {
                openPage();
              } else {
                showDialog(
                    context: context,
                    builder: (ctx) => NeedLoginDialog(
                            onSuccessLogin: (bool? isSuccess) async {
                          if (isSuccess ?? false) {
                            openPage();
                          }
                        }));
              }
            }
          }

          if (service.id == 201) {
            CommonFunctions.sendUXCamEvent(
                UXCamEvents.SnapAndSend_Open_From_Services_Event);
            await BottomSheetDialog.showDraggableSheet(
                NavigationService.navigatorKey.currentContext!,
                dialogKeyName: DialogName.vdTypesDialog,
                currentRouteName: "ServicesPage",
                child: BottomSheetWithActions(
                  title: "customerVoiceReportTypeWord".tr(),
                  body: VDAllTypesDialog(),
                ));
          } else if (service.id == 406) {
            if (CommonProperties.isLoggedIn) {
              await BottomSheetDialog.showDraggableSheet(
                  NavigationService.navigatorKey.currentContext!,
                  dialogKeyName: DialogName.daemDialog,
                  currentRouteName: "ServicesPage",
                  child: BottomSheetWithActions(
                    title: "daem_select_category".tr(),
                    body: const DaemTypeDialog(),
                  ));
            } else {
              showDialog(
                  context: context,
                  builder: (ctx) =>
                      NeedLoginDialog(onSuccessLogin: (bool? isSuccess) async {
                        if (isSuccess ?? false) {
                          await BottomSheetDialog.showDraggableSheet(context,
                              dialogKeyName: DialogName.daemDialog,
                              currentRouteName: "ServicesPage",
                              child: BottomSheetWithActions(
                                title: "daem_select_category".tr(),
                                body: const DaemTypeDialog(),
                              ));
                        }
                      }));
            }
          } else if (service.id == 210 || service.id == 313) {
            if (CommonProperties.isLoggedIn) {
              await BottomSheetDialog.showDraggableSheet(context,
                  dialogKeyName: DialogName.InqueryDialog,
                  currentRouteName: "ServicesPage",
                  child: BottomSheetWithActions(
                    title: "select_category".tr(),
                    body: const GeneralInquiryTypeDialog(),
                  ));
            } else {
              showDialog(
                  context: context,
                  builder: (ctx) =>
                      NeedLoginDialog(onSuccessLogin: (bool? isSuccess) async {
                        if (isSuccess ?? false) {
                          await BottomSheetDialog.showDraggableSheet(context,
                              dialogKeyName: DialogName.InqueryDialog,
                              currentRouteName: "ServicesPage",
                              child: BottomSheetWithActions(
                                title: "select_category".tr(),
                                body: const GeneralInquiryTypeDialog(),
                              ));
                        }
                      }));
            }
          } else if (service.id == 203) {
            if (CommonProperties.isLoggedIn) {
              await BottomSheetDialog.showDraggableSheet(context,
                  dialogKeyName: DialogName.msrDialog,
                  currentRouteName: "ServicesPage",
                  child: BottomSheetWithActions(
                    title: "select_category".tr(),
                    body: const MSRTypeDialog(),
                  ));
            } else {
              showDialog(
                  context: context,
                  builder: (ctx) =>
                      NeedLoginDialog(onSuccessLogin: (bool? isSuccess) async {
                        if (isSuccess ?? false) {
                          await BottomSheetDialog.showDraggableSheet(context,
                              dialogKeyName: DialogName.msrDialog,
                              currentRouteName: "ServicesPage",
                              child: BottomSheetWithActions(
                                title: "select_category".tr(),
                                body: const MSRTypeDialog(),
                              ));
                        }
                      }));
            }
          } else if (service.id == 204 || service.id == 312) {
            if (CommonProperties.isLoggedIn) {
              bool isSuccess =
                  await locator<NewAppointmentViewModel>().loadInitialData();
              if (isSuccess) {
                NavigationService.navigatorKey.currentState!
                    .pushNamed(RouteName.NewAppointmentPage, arguments: null);
                /* await BottomSheetDialog.showDraggableSheet(context,
                  dialogKeyName: DialogName.selectAppointmentTypeDialog,
                  currentRouteName: "ServicesPage",
                  isFullHeight: false,
                  child: BottomSheetWithActions(
                    title: "اختر نوع الموعد".tr(),
                    body: NewAppointmentDialog(),
                  ));*/
              }
            } else {
              showDialog(
                  context: context,
                  builder: (ctx) =>
                      NeedLoginDialog(onSuccessLogin: (bool? isSuccess) async {
                        if (isSuccess ?? false) {
                          await locator<NewAppointmentViewModel>()
                              .loadInitialData();
                          NavigationService.navigatorKey.currentState!
                              .pushNamed(RouteName.NewAppointmentPage,
                                  arguments: null);
                          /* await BottomSheetDialog.showDraggableSheet(context,
                            dialogKeyName:
                                DialogName.selectAppointmentTypeDialog,
                            currentRouteName: "ServicesPage",
                            isFullHeight: false,
                            child: BottomSheetWithActions(
                              title: "اختر نوع الموعد".tr(),
                              body: NewAppointmentDialog(),
                            ));*/
                        }
                      }));
            }
          }
          if (service.action.value == RouteName.DCCameraPage) {
            bool isLocationAvailable =
                await CommonFunctions.checkLocationSettings(context);
            bool isCameraAllowed =
                await CommonFunctions.checkCameraSettings(context);
            if (isLocationAvailable && isCameraAllowed) {
              if (CommonProperties.isLoggedIn) {
                NavigationService.navigatorKey.currentState!.pushNamed(
                    RouteName.DCCameraPage,
                    arguments: CameraParamsPage(
                        selectedCategory: CategoryItem(categoryId: "CG-14"),
                        isFromHome: false));
              } else {
                showDialog(
                    context: context,
                    builder: (ctx) => NeedLoginDialog(
                            onSuccessLogin: (bool? isSuccess) async {
                          if (isSuccess ?? false) {
                            NavigationService.navigatorKey.currentState!
                                .pushNamed(RouteName.DCCameraPage,
                                    arguments: CameraParamsPage(
                                        selectedCategory:
                                            CategoryItem(categoryId: "CG-14"),
                                        isFromHome: false));
                          }
                        }));
              }
            }
          } else if (service.iconName == "municipal_commercial" ||
              service.iconName == "municpal_construction" ||
              service.iconName == "municipal_shop" ||
              service.iconName == "municpal_housing" ||
              service.iconName == "municipal_ewaa" ||
              service.iconName == "municpal_toppaco") {
            if (CommonProperties.isLoggedIn) {
              if (service.id == 305) {
                CommonFunctions.sendUXCamEvent(
                    UXCamEvents.startServiceSharedHousingLicense);
              } else if (service.id == 306) {
                CommonFunctions.sendUXCamEvent(
                    UXCamEvents.startServiceEwaaPlatform);
              } else if (service.id == 309) {
                CommonFunctions.sendUXCamEvent(
                    UXCamEvents.startServiceCommercialServices);
              } else if (service.id == 315) {
                CommonFunctions.sendUXCamEvent(
                    UXCamEvents.startServiceConstructionServices);
              } else if (service.id == 220) {
                CommonFunctions.sendUXCamEvent(
                    UXCamEvents.startServiceMobileStores);
              }
              String url = service.action.value;
              if (!CommonFunctions.isAppAR) {
                url = url.replaceAll("/ar/", "/en/");
              }
              CommonFunctions.openBaladyWebView(url);
            } else {
              showDialog(
                  context: context,
                  builder: (ctx) =>
                      NeedLoginDialog(onSuccessLogin: (bool? isSuccess) async {
                        if (isSuccess ?? false) {
                          CommonFunctions.openBaladyWebView(
                              service.action.value);
                        }
                      }));
            }
          } else if (service.iconName == "municpal_all") {
            CommonFunctions.externalLaunch(service.action.value);
          } else if (service.id == 221) {
            CommonFunctions.sendUXCamEvent(
                UXCamEvents.startServiceEkramServices);
            try {
              NavigationService.navigatorKey.currentState!
                  .pushNamed(RouteName.SpecificServicePage, arguments: (
                BlocProvider.of<ServicesCubit>(
                        NavigationService.bottomNavKey.currentContext!)
                    .state
                    .honoringTheDeadServices,
                service.title.tr()
              ));
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
          } else if (service.id == 408) {
            SmartAdvisor.navigateToSmartAdvisorApp(
                context: context, envType: sl<EnvType>());
          }
        },
        child: Container(
          width: width ?? 68,
          margin: const EdgeInsetsDirectional.only(
            end: 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 16),
                decoration: BoxDecoration(
                    color: backgroundColor ?? AppColor.white,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: DrawIconBasedTypeWidget(
                  icon: IconPath.serviceIcon(service.iconName),
                  iconSize: 28,
                  iconColor: iconColor,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Flexible(
                child: CustomTextWidget(
                  service.title.tr(),
                  fontSize: 10,
                  maxLines: 6,
                  textAlign: TextAlign.center,
                  fontColor: AppColor.blackModern700Light,
                  fontWeight: AppFontWeight.bold,
                ),
              ),
              if (service.beta == true)
                CustomTextWidget(
                  "beta".tr(),
                  fontSize: 8,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  fontColor: AppColor.redBrown,
                  fontWeight: AppFontWeight.bold,
                )
            ],
          ),
        )

        /* Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 0,
            shape: const CircleBorder(),
            color: AppColor.blackModern100Light.withOpacity(0.6),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  padding: const EdgeInsets.all(18),
                  child: Center(
                    child: DrawIconBasedTypeWidget(
                      icon: IconPath.serviceIcon(service.iconName),
                      iconSize: 28,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: CustomTextWidget(
              service.title,
              fontSize: 10,
              maxLines: 3,
              textAlign: TextAlign.center,
              fontColor: AppColor.blackModern700Light,
              fontWeight: AppFontWeight.bold,
            ),
          ),
        ],
      ),*/
        );
  }

  void openPage() async {
    var context = NavigationService.navigatorKey.currentContext!;
    if (service.id == 302) {
      if (CommonProperties.selectedDelegator != null) {
        await BottomSheetDialog.showDraggableSheet(context,
            isFullHeight: false, height: 300, child: CommercialPermitsDialog(
          onSelect: (int item) async {
            if (item == 1042) {
              await BottomSheetDialog.showDraggableSheet(context,
                  isFullHeight: true,
                  child: PermitsLicenseBottomSheetList(
                    groupId: item,
                  ));
            }
          },
        ));
      } else {
        await BottomSheetDialog.showDraggableSheet(
          context,
          isFullHeight: false,
          dialogKeyName: DialogName.notAuthorizedIndivisualDialog,
          currentRouteName: RouteName.postersStartService,
          child: NotAuthorizedIndivisualDialog(),
        );
      }

      return;
    } else if (service.id == 211 || service.id == 314) {
      if (CommonProperties.isLoggedIn) {
        NavigationService.navigatorKey.currentState!
            .pushNamed(RouteName.etmamMainPage, arguments: (true, ""));
      } else {
        showDialog(
            context: context,
            builder: (ctx) =>
                NeedLoginDialog(onSuccessLogin: (bool? isSuccess) async {
                  if (isSuccess ?? false) {
                    NavigationService.navigatorKey.currentState!.pushNamed(
                        RouteName.etmamMainPage,
                        arguments: (true, ""));
                  }
                }));
      }
    } else if (service.id == 205) {
      if (CommonProperties.isLoggedIn) {
        NavigationService.navigatorKey.currentState!
            .pushNamed(RouteName.etmamMainPage, arguments: (false, ""));
      } else {
        showDialog(
            context: context,
            builder: (ctx) =>
                NeedLoginDialog(onSuccessLogin: (bool? isSuccess) async {
                  if (isSuccess ?? false) {
                    NavigationService.navigatorKey.currentState!.pushNamed(
                        RouteName.etmamMainPage,
                        arguments: (false, ""));
                  }
                }));
      }
    } else
      NavigationService.navigatorKey.currentState?.pushNamed(
        service.action.value,
        arguments: null,
      );
  }
}
