import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/base/base_view.dart';
import '../../../../../core/base/base_view_model.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../new_appointment/presentation/core/models/appointment_details_model.dart';
import '../../../../new_appointment/presentation/widgets/appointment_status_widget.dart';
import '../../core/services/view_models/appontment_details_view_model.dart';
import 'appointment_details_part_of_card_widget.dart';

class AppointmentDetailsCardWidget extends StatelessWidget {
  final AppointmentItemInfo appointmentData;
  bool printable;

  AppointmentDetailsCardWidget(
      {Key? key, required this.appointmentData, required this.printable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AppointmentDetailsViewModel>(
        onModelReady: (model) {},
        builder: (context, model, child) {
          return Container(
            decoration: Constants.boxDecorationWithShadowAndRoundedCorner,
            margin: EdgeInsets.zero,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Constants.verticalSpaceMedium,
                    // header
                    _CardHeaderWidget(
                      appointmentStatusId: appointmentData.statusId ?? 0,
                      appointmentStatusText: appointmentData.statusName ?? "",
                      appointmentTitle: appointmentData.mainClassName ?? "",
                      appointmentSubTitle: appointmentData.id != null
                          ? appointmentData.id!.toString()
                          : "",
                    ),
                    const CustomVerticalSpace(height: 40.0),
                    // qr code
                    _QRCodeWidget(
                      qrCode: appointmentData.uuid ?? "",
                    ),
                    const CustomVerticalSpace(height: 40.0),
                    // cards details
                    _CardDetailsWidget(
                      entityName: appointmentData.subMunicipalityName ?? "",
                      appointmentTime: appointmentData.visitTime ?? "",
                      service: appointmentData.subClassName ?? "",
                      appointmentDate: appointmentData.visitDate ?? "",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Constants.mediumPadding),
                      child: AppointmentDetailsPartOfCardWidget(
                        title: "visit_purpose".tr(),
                        subTitle: appointmentData.appointmentDetails ?? "",
                      ),
                    ),
                    const CustomVerticalSpace(height: 40.0),
                    // line
                    /*              if (appointmentData.printable ??
                        printable */ /*model.isPrintableAppointment()*/ /*)*/
                    const DrawLineWidget(),
                    // regulations
                    /*          if (appointmentData.printable ??
                        printable */ /*model.isPrintableAppointment()*/ /*)*/
                    _GoToRegulationsWidget(
                      /* printUrl: appointmentData.printUrl ?? "",*/
                      // onClick: () =>
                      //     model.printAppointment(appointmentData.id ?? -1),
                      appointmentID: appointmentData.id ?? -1,
                    ),
                    // Constants.verticalSpaceMedium,
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class _CardHeaderWidget extends StatelessWidget {
  const _CardHeaderWidget(
      {Key? key,
      required this.appointmentStatusId,
      required this.appointmentTitle,
      required this.appointmentSubTitle,
      required this.appointmentStatusText})
      : super(key: key);

  final int appointmentStatusId;
  final String appointmentTitle;
  final String appointmentSubTitle;
  final String appointmentStatusText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.semiMediumPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // status
          AppointmentStatusWidget(
            appointmentStatusId: appointmentStatusId,
            statusText: appointmentStatusText,
          ),
          const CustomVerticalSpace(height: 14.0),
          // title
          CustomTextWidget(
            appointmentTitle.trim(),
            fontSize: 22.0,
            fontColor: AppColor.black,
            textAlign: TextAlign.start,
          ),
          const CustomVerticalSpace(height: 14.0),
          // subtitle
          CustomTextWidget(
            appointmentSubTitle,
            fontColor: AppColor.black500,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

class _QRCodeWidget extends StatelessWidget {
  String qrCode;

  _QRCodeWidget({required this.qrCode});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(
          horizontal: Constants.semiMediumPadding,
        ),
        color: AppColor.white2,
        child: Container());
  }
}

class _CardDetailsWidget extends StatelessWidget {
  final String entityName;
  final String appointmentTime;
  final String service;
  final String appointmentDate;

  const _CardDetailsWidget({
    Key? key,
    required this.entityName,
    required this.appointmentTime,
    required this.service,
    required this.appointmentDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            const EdgeInsets.symmetric(horizontal: Constants.mediumPadding),
        //   height: _getGridHeight(),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: FieldData(
                    title: "appointmentDetailsEntityNameWord".tr(),
                    subTitle: entityName,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FieldData(
                    title: "appointmentDetailsServiceWord".tr(),
                    subTitle: service,
                  ),
                ),
              ],
            ),
            const CustomVerticalSpace(
              height: 35,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: FieldData(
                    title: ("appointmentDetailsAppointmentDateWord").tr(),
                    subTitle: CommonFunctions.getFormattedDate(appointmentDate),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FieldData(
                    title: ("appointmentDetailsAppointmentTimeWord").tr(),
                    subTitle: CommonFunctions.getFormattedTime(appointmentTime),
                  ),
                ),
              ],
            ),
            const CustomVerticalSpace(
              height: 35,
            ),
          ],
        ));
  }
}

class _GoToRegulationsWidget extends StatelessWidget {
  // String printUrl;
  // Function onClick;
  int appointmentID;

  _GoToRegulationsWidget(
      {/*required this.printUrl*/ /*required this.onClick*/ required this.appointmentID});

  final model = locator<AppointmentDetailsViewModel>();

  @override
  Widget build(BuildContext context) {
    return Container();
    /* return CustomGoToDetailsButtonWidget(
      leading: const CustomSvgIconWidget(
        Constants.instructionsIcon,
        iconHeight: 20.0,
        iconWidth: 20.0,
      ),
      onPressed: () => model.printAppointmentFunction(appointmentID),
      label: ("print_appointment",),
    );*/
  }
}
