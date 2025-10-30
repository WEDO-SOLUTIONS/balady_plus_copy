import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/services/view_models/new_appointment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/base/base_view.dart';
import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/constants/remote_config.dart';
import '../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../new_appointment/presentation/core/models/appointment_details_model.dart';
import '../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../core/services/view_models/appontment_details_view_model.dart';
import '../dialogs/confirm_cancel_appointment_dialog.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  final model = locator<AppointmentDetailsViewModel>();
  AppointmentItemInfo? appointmentItemInfo;

  late int appointmentId;
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
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    appointmentId = data['appointmentId'];
    return BaseView<AppointmentDetailsViewModel>(
      onModelReady: (model) {
        model.getAppointmentDetails(appointmentId);
        model.fromHomePage = fromHomePage ?? false;
      },
      builder: (context, model, child) {
        appointmentItemInfo = model.appointmentDetailsResponse?.data?.result;
        return Scaffold(
          backgroundColor: AppColor.white2,
          appBar: DetailsHeader(
            title: ("appointment").tr(),
            onPrint: (appointmentItemInfo?.printable ?? false)
                ? () {
                    model.printAppointmentFunction(appointmentId);
                  }
                : null,
            procedures: () async {
              await BottomSheetDialog.showDraggableSheet(
                context,
                isFullHeight: false,
                height: 250,
                dialogKeyName: DialogName.appointmentsActionsDialog,
                currentRouteName: RouteName.appointmentDetailsRoute,
                child: BottomSheetWithActions(
                  title: "actions".tr(),
                  body: Column(
                    children: [
                      if (appointmentItemInfo?.editable == true) ...[
                        GestureDetector(
                          onTap: () async {
                            bool isSuccess =
                                await locator<NewAppointmentViewModel>()
                                    .loadInitialData();
                            locator<NewAppointmentViewModel>().init();
                            await locator<NewAppointmentViewModel>()
                                .setUpDraft(item: appointmentItemInfo);
                            if (isSuccess) {
                              Navigator.of(context).pushNamed(
                                RouteName.NewAppointmentPage,
                                arguments: appointmentItemInfo,
                              );
                            }
                          },
                          child: FieldData(
                            title: "appointment_edit".tr(),
                          ),
                        ),
                        const CustomVerticalSpace(height: 16),
                      ],
                      if (appointmentItemInfo?.confirmable ?? false)
                        GestureDetector(
                          onTap: () {
                            model.confirmAppointment();
                          },
                          child: FieldData(
                            title:
                                "appointmentDetailsConfirmAppointmentWord".tr(),
                          ),
                        ),
                      const CustomVerticalSpace(height: 16),
                      if (appointmentItemInfo!.cancelable ?? false)
                        GestureDetector(
                          onTap: () async {
                            final model =
                                locator<AppointmentDetailsViewModel>();
                            await model.getLookUpList();
                            if (model.cancelReasonsList != null) {
                              await BottomSheetDialog.showDraggableSheet(
                                context,
                                dialogKeyName:
                                    DialogName.appointmentsActionsCancelDialog,
                                currentRouteName:
                                    RouteName.appointmentDetailsRoute,
                                child: const ConfirmCancelAppointmentDialog(),
                                isFullHeight: false,
                              );
                            }
                          },
                          child: FieldData(
                            title:
                                "appointmentDetailsCancelAppointmentWord".tr(),
                          ),
                        )
                    ],
                  ),
                ),
              );
            },
          ),
          body: Consumer<AppointmentDetailsViewModel>(
            builder: (BuildContext context, AppointmentDetailsViewModel value,
                Widget? child) {
              return value.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : child!;
            },
            child: Padding(
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
                            const CustomHorizontalSpace(width: 8),
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
                      title: ("time_date_appointment").tr(),
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
                      ],
                    ),
                    const CustomVerticalSpace(height: 16),
                    CustomExpansionPanelWidget(
                      title: ("appointmentsGoToAppointmentDetailsWord").tr(),
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
                      ],
                    ),
                    const CustomVerticalSpace(height: 16),
                    if (appointmentItemInfo?.uuid != null)
                      CustomExpansionPanelWidget(
                        title: ("quick_code").tr(),
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
                              padding:
                                  const EdgeInsets.all(Constants.smallPadding),
                            ),
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
