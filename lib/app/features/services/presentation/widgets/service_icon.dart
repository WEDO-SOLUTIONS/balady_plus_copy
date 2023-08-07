import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/utils_exports.dart'
    show
        AppStyle,
        CommonFunctions,
        CommonProperties,
        ContextConversion,
        IconPath,
        RouteName,
        ServiceAction;
import '../../../_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, BottomSheetWithActions, DrawIconBasedTypeWidget;
import '../../../daem/presentation/dialogs/daem_types_dialog.dart';
import '../../../new_appointment/presentation/core/services/view_models/new_appointment_view_model.dart';
import '../../../new_appointment/presentation/dialogs/new_appointment_dialog.dart';
import '../../../public_services_features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import '../../../transaction_inquiry/presentation/dialogs/general_inquiries_types_dialog.dart';
import '../../../transaction_inquiry/presentation/dialogs/new_request_types_dialog.dart';
import '../../../vd/domain/entities/camera/camera_page_params.dart';
import '../../../vd/domain/entities/categories/category_item.dart';
import '../../../vd/presentation/dialogs/vd_all_types_dialog.dart';
import '../../services_exports.dart';

class ServiceIcon extends StatelessWidget {
  final ServiceEntity service;

  const ServiceIcon({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (service.id == 1 && service.action.type == ServiceAction.cardsPage) {
          await BottomSheetDialog.showDraggableSheet(context,
              child: BottomSheetWithActions(
                title: "اختر نوع البلاغ".tr(),
                body: VDAllTypesDialog(),
              ));
        } else if (service.id == 3 &&
            service.action.type == ServiceAction.dialog) {
          if (CommonProperties.isLoggedIn) {
            await BottomSheetDialog.showDraggableSheet(context,
                child: BottomSheetWithActions(
                  title: "daem_select_category".tr(),
                  body: DaemTypeDialog(),
                ));
          } else {
            showDialog(
                context: context,
                builder: (ctx) =>
                    NeedLoginDialog(onSuccessLogin: (bool? isSuccess) async {
                      if (isSuccess ?? false) {
                        await BottomSheetDialog.showDraggableSheet(context,
                            child: BottomSheetWithActions(
                              title: "daem_select_category".tr(),
                              body: DaemTypeDialog(),
                            ));
                      }
                    }));
          }
        } else if (service.id == 2 &&
            service.action.type == ServiceAction.dialog) {
          if (CommonProperties.isLoggedIn) {
            await BottomSheetDialog.showDraggableSheet(context,
                child: BottomSheetWithActions(
                  title: "اختر التصنيف".tr(),
                  body: GeneralInquiryTypeDialog(),
                ));
          } else {
            showDialog(
                context: context,
                builder: (ctx) =>
                    NeedLoginDialog(onSuccessLogin: (bool? isSuccess) async {
                      if (isSuccess ?? false) {
                        await BottomSheetDialog.showDraggableSheet(context,
                            child: BottomSheetWithActions(
                              title: "اختر التصنيف".tr(),
                              body: GeneralInquiryTypeDialog(),
                            ));
                      }
                    }));
          }
        } else if (service.id == 5 &&
            service.action.type == ServiceAction.dialog) {
          if (CommonProperties.isLoggedIn) {
            await BottomSheetDialog.showDraggableSheet(context,
                child: BottomSheetWithActions(
                  title: "اختر التصنيف".tr(),
                  body: MSRTypeDialog(),
                ));
          } else {
            showDialog(
                context: context,
                builder: (ctx) =>
                    NeedLoginDialog(onSuccessLogin: (bool? isSuccess) async {
                      if (isSuccess ?? false) {
                        await BottomSheetDialog.showDraggableSheet(context,
                            child: BottomSheetWithActions(
                              title: "اختر التصنيف".tr(),
                              body: MSRTypeDialog(),
                            ));
                      }
                    }));
          }
        } else if (service.id == 2 && service.action.value == "/prayerTimes") {
          context.pushNamedRoute(
            RouteName.prayerTimes,
            arguments: context.read<PrayerTimesCubit>(),
          );
        } else if (service.id == 13) {
          if (CommonProperties.isLoggedIn) {
            Navigator.pushNamed(context, RouteName.municipalAdvisor);
          } else {
            showDialog(
                context: context,
                builder: (ctx) =>
                    NeedLoginDialog(onSuccessLogin: (bool? isSuccess) async {
                      if (isSuccess ?? false) {
                        Navigator.pushNamed(
                            context, RouteName.municipalAdvisor);
                      }
                    }));
          }
        } else if (service.id == 4 &&
            service.action.type == ServiceAction.dialog) {
          if (CommonProperties.isLoggedIn) {
            bool isSuccess =
                await locator<NewAppointmentViewModel>().loadInitialData();
            if (isSuccess)
              await BottomSheetDialog.showDraggableSheet(context,
                  isFullHeight: false,
                  child: BottomSheetWithActions(
                    title: "اختر نوع الموعد".tr(),
                    body: NewAppointmentDialog(),
                  ));
          } else {
            showDialog(
                context: context,
                builder: (ctx) =>
                    NeedLoginDialog(onSuccessLogin: (bool? isSuccess) async {
                      if (isSuccess ?? false) {
                        await locator<NewAppointmentViewModel>()
                            .loadInitialData();
                        await BottomSheetDialog.showDraggableSheet(context,
                            isFullHeight: false,
                            child: BottomSheetWithActions(
                              title: "اختر نوع الموعد".tr(),
                              body: NewAppointmentDialog(),
                            ));
                      }
                    }));
          }
        } else if (service.action.type == ServiceAction.cardsPage) {
          if (service.requireLogin != true) {
            Navigator.pushNamed(
              context,
              RouteName.serviceCards,
              arguments: service,
            );
          } else {
            if (CommonProperties.isLoggedIn) {
              Navigator.pushNamed(
                context,
                RouteName.serviceCards,
                arguments: service,
              );
            } else {
              showDialog(
                  context: context,
                  builder: (ctx) =>
                      NeedLoginDialog(onSuccessLogin: (bool? isSuccess) async {
                        if (isSuccess ?? false) {
                          Navigator.pushNamed(
                            context,
                            RouteName.serviceCards,
                            arguments: service,
                          );
                        }
                      }));
            }
          }
        } else if (service.action.type == ServiceAction.pageRoute) {
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
          } else {
            if (service.requireLogin != true) {
              Navigator.pushNamed(
                context,
                service.action.value,
              );
            } else {
              if (CommonProperties.isLoggedIn) {
                Navigator.pushNamed(
                  context,
                  service.action.value,
                );
              } else {
                showDialog(
                    context: context,
                    builder: (ctx) => NeedLoginDialog(
                            onSuccessLogin: (bool? isSuccess) async {
                          if (isSuccess ?? false) {
                            Navigator.pushNamed(
                              context,
                              service.action.value,
                            );
                          }
                        }));
              }
            }
          }
        }
      },
      child: Column(
        children: [
          Card(
            elevation: 0,
            shape: const CircleBorder(),
            color: AppColor.blackModern100Light,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: constraints.maxWidth - 24,
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
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
          const SizedBox(height: 4),
          Text(
            service.title,
            style: AppStyle.serviceIconTextStyle,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
