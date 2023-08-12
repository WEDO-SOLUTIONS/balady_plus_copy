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
import '../core/services/view_models/appontment_details_view_model.dart';
import '../dialogs/confirm_cancel_appointment_dialog.dart';
import '../widgets/appointment_details_widgets/appointment_details_card_widget.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  // final int appointmentId;

  AppointmentItemInfo? appointmentItemInfo;
  bool? isCancelable;
  bool? isPrintable;
  bool? fromHomePage;

  AppointmentDetailsScreen(
      {Key? key,
      this.appointmentItemInfo,
      this.isCancelable,
      this.isPrintable,
      this.fromHomePage = false
      // required this.appointmentId,
      })
      : super(key: key);

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  final model = locator<AppointmentDetailsViewModel>();
  AppointmentItemInfo? appointmentItemInfoLocal;

  @override
  void initState() {
    model.fromHomePage = widget.fromHomePage ?? false;
    super.initState();
  }

  @override
  void dispose() {
    model.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AppointmentDetailsViewModel>(
        onModelReady: (model) {},
        builder: (context, model, child) {
          if (widget.appointmentItemInfo != null) {
            appointmentItemInfoLocal = widget.appointmentItemInfo;
          } else {
            appointmentItemInfoLocal = model.getAppointmentsInfo();
          }
          return Scaffold(
              backgroundColor: AppColor.white2,
              appBar: DetailsHeader(
                title: ("appointment").tr(),
                onPrint: (widget.isPrintable ?? false)
                    ? () {
                        model.printAppointmentFunction(
                            widget.appointmentItemInfo!.id!);
                      }
                    : null,
                procedures: () async {
                  await BottomSheetDialog.showDraggableSheet(context,
                      isFullHeight: false,
                      height: 250,
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
                          if (widget.isCancelable ??
                              appointmentItemInfoLocal!.cancelable ??
                              false)
                            GestureDetector(
                                onTap: () async {
                                  await BottomSheetDialog.showDraggableSheet(
                                    context,
                                    child:
                                        const ConfirmCancelAppointmentDialog(),
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
                                  widget.appointmentItemInfo?.visitDate,
                                ),
                                fontColor: AppColor.blackModern500Light,
                                fontSize: 12,
                                fontWeight: AppFontWeight.bold,
                              )
                            ],
                          ),
                          HomeTag(
                            title: widget.appointmentItemInfo?.statusName ?? "",
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
                                  widget.appointmentItemInfo?.visitDate),
                            ),
                            const CustomVerticalSpace(height: 8),
                            FieldData(
                              title: ("appointmentsAppointmentTimeWord").tr(),
                              subTitle: widget.appointmentItemInfo?.visitTime,
                            ),
                          ]),
                      CustomVerticalSpace(height: 16),
                      CustomExpansionPanelWidget(
                          title: ("تفاصيل الموعد").tr(),
                          leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                          children: [
                            FieldData(
                              title: ("appointmentDetailsEntityNameWord").tr(),
                              subTitle: widget
                                  .appointmentItemInfo?.subMunicipalityName,
                            ),
                            const CustomVerticalSpace(height: 8),
                            FieldData(
                              title: ("appointmentDetailsServiceWord").tr(),
                              subTitle:
                                  widget.appointmentItemInfo?.subClassName,
                            ),
                            const CustomVerticalSpace(height: 8),
                            FieldData(
                              title: ("visit_purpose").tr(),
                              subTitle: widget
                                  .appointmentItemInfo?.appointmentDetails,
                            ),
                          ]),
                      CustomVerticalSpace(height: 16),
                      if (widget.appointmentItemInfo?.uuid != null)
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
                                    data:
                                        RemoteConfig.publicAppointmentShareURL +
                                            widget.appointmentItemInfo!.uuid!,
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
