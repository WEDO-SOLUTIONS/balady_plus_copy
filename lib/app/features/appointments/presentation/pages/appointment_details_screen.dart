import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/base/base_view.dart';
import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/constants/remote_config.dart';
import '../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../new_appointment/presentation/core/models/appointment_details_model.dart';
import '../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../core/models/appointment_details_screen_args.dart';
import '../core/services/view_models/appontment_details_view_model.dart';
import '../dialogs/confirm_cancel_appointment_dialog.dart';
import '../widgets/appointment_details_widgets/appointment_details_card_widget.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  // final int appointmentId;

  const AppointmentDetailsScreen({
    Key? key,

    // required this.appointmentId,
  }) : super(key: key);

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  final model = locator<AppointmentDetailsViewModel>();
  AppointmentItemInfo? appointmentItemInfoLocal;

  AppointmentItemInfo? appointmentItemInfo;
  bool? isCancelable;
  bool? isPrintable;
  bool? fromHomePage = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    model.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppointmentDetailsScreenArgs args = ModalRoute.of(context)!
        .settings
        .arguments as AppointmentDetailsScreenArgs;

    appointmentItemInfo = args.appointmentItemInfo;
    isCancelable = args.isCancelable;
    isPrintable = args.isPrintable;
    fromHomePage = args.fromHomePage;

    return BaseView<AppointmentDetailsViewModel>(onModelReady: (model) {
      model.fromHomePage = fromHomePage ?? false;
    }, builder: (context, model, child) {
      if (appointmentItemInfo != null) {
        appointmentItemInfoLocal = appointmentItemInfo;
      } else {
        appointmentItemInfoLocal = model.getAppointmentsInfo();
      }
      return Scaffold(
          backgroundColor: AppColor.white2,
          appBar: DetailsHeader(
            title: ("appointment").tr(),
            onPrint: (isPrintable ?? false)
                ? () {
                    model.printAppointmentFunction(appointmentItemInfo!.id!);
                  }
                : null,
            procedures: () async {
              await BottomSheetDialog.showDraggableSheet(context,
                  isFullHeight: false,
                  height: 250,
                  dialogKeyName: DialogName.appointmentsActionsDialog,
                  currentRouteName: RouteName.appointmentDetailsRoute,
                  child: BottomSheetWithActions(
                    title: "actions".tr(),
                    body: Column(children: [
                      if (appointmentItemInfoLocal?.confirmable ?? false)
                        GestureDetector(
                          onTap: () {
                            model.confirmAppointment();
                          },
                          child: FieldData(
                            title: "تأكيد الموعد",
                          ),
                        ),
                      CustomVerticalSpace(height: 16),
                      if (isCancelable ??
                          appointmentItemInfoLocal!.cancelable ??
                          false)
                        GestureDetector(
                            onTap: () async {
                              await BottomSheetDialog.showDraggableSheet(
                                context,
                                dialogKeyName:
                                    DialogName.appointmentsActionsCancelDialog,
                                currentRouteName:
                                    RouteName.appointmentDetailsRoute,
                                child: const ConfirmCancelAppointmentDialog(),
                                isFullHeight: false,
                              );
                            },
                            child: FieldData(title: "الغاء الموعد"))
                    ]),
                  ));

/*


 if (appointmentItemInfoLocal?.confirmable ?? false) ...[
                  _ConfirmAppointmentWidget(onConfirm: () {
                    model.confirmAppointment();
                  }),
                  Constants.verticalSpaceMedium,
                ],
                if (widget.isCancelable ??
                    appointmentItemInfoLocal!.cancelable ??
                    false)
*/

              /*await CustomPopUpsWidgets.showBottomSheet(
                    context,
                    child: const ConfirmCancelAppointmentDialog(),
                    isFullHeight: false,
                  );*/
            },
          ),
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            IconPath.calendarIcon,
                            width: 24,
                            height: 24,
                          ),
                          CustomHorizontalSpace(width: 8),
                          CustomTextWidget(
                            CommonFunctions.getFormattedDate(
                              appointmentItemInfo?.visitDate,
                            ),
                            fontColor: AppColor.blackModern500Light,
                            fontSize: 12,
                            fontWeight: AppFontWeight.bold,
                          )
                        ],
                      ),
                      HomeTag(
                        title: appointmentItemInfo?.statusName ?? "",
                        backgroundColor: AppColor.secondary100Light,
                      ),
                    ],
                  ),
                  const CustomVerticalSpace(height: 16),
                  CustomExpansionPanelWidget(
                      title: ("تاريح وقت الموعد").tr(),
                      leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                      children: [
                        FieldData(
                          title: ("appointmentsAppointmentDateWord").tr(),
                          subTitle: CommonFunctions.getFormattedDate(
                              appointmentItemInfo?.visitDate),
                        ),
                        const CustomVerticalSpace(height: 8),
                        FieldData(
                          title: ("appointmentsAppointmentTimeWord").tr(),
                          subTitle: appointmentItemInfo?.visitTime,
                        ),
                      ]),
                  CustomVerticalSpace(height: 16),
                  CustomExpansionPanelWidget(
                      title: ("تفاصيل الموعد").tr(),
                      leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                      children: [
                        FieldData(
                          title: ("appointmentDetailsEntityNameWord").tr(),
                          subTitle: appointmentItemInfo?.subMunicipalityName,
                        ),
                        const CustomVerticalSpace(height: 8),
                        FieldData(
                          title: ("appointmentDetailsServiceWord").tr(),
                          subTitle: appointmentItemInfo?.subClassName,
                        ),
                        const CustomVerticalSpace(height: 8),
                        FieldData(
                          title: ("visit_purpose").tr(),
                          subTitle: appointmentItemInfo?.appointmentDetails,
                        ),
                      ]),
                  CustomVerticalSpace(height: 16),
                  if (appointmentItemInfo?.uuid != null)
                    CustomExpansionPanelWidget(
                        title: ("الرمز السريع").tr(),
                        leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                        children: [
                          Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: Constants.semiMediumPadding,
                              ),
                              color: AppColor.white2,
                              child: QrImageView(
                                data: RemoteConfig.publicAppointmentShareURL +
                                    appointmentItemInfo!.uuid!,
                                version: QrVersions.auto,
                                size: 180.0,
                                padding: const EdgeInsets.all(
                                    Constants.smallPadding),
                              ))
                        ]),
                ],
              ))));

/*
            ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.smallPadding,
                vertical: Constants.mediumPadding,
              ),
              children: [
                if (appointmentItemInfoLocal != null)
                  AppointmentDetailsCardWidget(
                    appointmentData: appointmentItemInfoLocal!,
                    printable: /*model.isPrintableAppointment()*/
                        widget.isPrintable ??
                            appointmentItemInfoLocal!.printable ??
                            false,
                  ),
                if (/*model.showCancelButton()*/ widget.isCancelable ??
                    appointmentItemInfoLocal!.cancelable ??
                    false)
                  const CustomVerticalSpace(height: 40.0),
                if (appointmentItemInfoLocal?.confirmable ?? false) ...[
                  _ConfirmAppointmentWidget(onConfirm: () {
                    model.confirmAppointment();
                  }),
                  Constants.verticalSpaceMedium,
                ],
                if (widget.isCancelable ??
                    appointmentItemInfoLocal!.cancelable ??
                    false)
                  const _CancelAppointmentWidget(),
                Constants.verticalSpaceMedium,
              ],
            ),
          );*/
    });
  }
}

class _AppBarActionsShareIconWidget extends StatelessWidget {
  int appointmentID;

  _AppBarActionsShareIconWidget({Key? key, required this.appointmentID})
      : super(key: key);
  final model = locator<AppointmentDetailsViewModel>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.smallPadding,
      ),
      child: CustomIconButtonWidget(
        icon: Constants.shareIcon,
        onPressed: () => model.shareAppointmentFunction(appointmentID),
      ),
    );
  }
}

class _CancelAppointmentWidget extends StatelessWidget {
  const _CancelAppointmentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EnhancedCustomElevatedButtonWidget(
      btnPressed: () async => await CustomPopUpsWidgets.showBottomSheet(
        context,
        child: const ConfirmCancelAppointmentDialog(),
        isFullHeight: false,
      ),
      btnBorderColor: AppColor.redBrown,
      btnColor: AppColor.white2,
      btnBorderWidth: 2.0,
      btnText: ("appointmentDetailsCancelAppointmentWord").tr(),
      btnTextColor: AppColor.redBrown,
      btnTextWeight: AppFontWeight.medium,
    );
  }
}

class _ConfirmAppointmentWidget extends StatelessWidget {
  final Function onConfirm;
  const _ConfirmAppointmentWidget({Key? key, required this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EnhancedCustomElevatedButtonWidget(
      btnPressed: () async => onConfirm(),
      btnBorderColor: AppColor.primary900Light,
      btnColor: AppColor.white2,
      btnBorderWidth: 2.0,
      btnText: ("appointmentDetailsConfirmAppointmentWord").tr(),
      btnTextColor: AppColor.primary900Light,
      btnTextWeight: AppFontWeight.medium,
    );
  }
}
