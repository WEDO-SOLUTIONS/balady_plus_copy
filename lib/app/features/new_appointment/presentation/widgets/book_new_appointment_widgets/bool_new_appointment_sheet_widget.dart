/*import 'package:balady_plus/app/core/core_exports.dart'
    show
        AppColors,
        Constants,
        CustomTextButtonWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        FONT_WEIGHT,
        Helpers,
        APPOINTMENT_TYPE;
import 'package:balady_plus/app/core/utils/constants/constants.dart';

import 'package:flutter/material.dart';

class BookNewAppointmentSheetWidget extends StatelessWidget {
  bool fromHomePage;

  BookNewAppointmentSheetWidget({this.fromHomePage = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // button, title, and subtitle
        const _BookNewAppointmentSheetHeaderWidget(),
        // appointments types
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              bottom: Constants.mediumPadding,
              left: Constants.semiMediumPadding,
              right: Constants.semiMediumPadding,
            ),
            children: [
              AppointmentTypeCardWidget(
                fromHomePage: fromHomePage,
                appointmentType: APPOINTMENT_TYPE.newAppointment,
              ),
              Constants.verticalSpaceMedium,
              // review appointment
              AppointmentTypeCardWidget(
                fromHomePage: fromHomePage,
                appointmentType: APPOINTMENT_TYPE.reviewAppointment,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BookNewAppointmentSheetHeaderWidget extends StatelessWidget {
  const _BookNewAppointmentSheetHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.semiMediumPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // close button
          CustomTextButtonWidget(
            btnPressed: () => Navigator.of(context).pop(),
            btnText: Helpers.translatingWord(
              "bookNewAppointmentCloseWindowWord",
            ),
            btnTextColor: AppColor.grey1000,
            btnTextSize: 17.0,
            btnTextWeight: AppFontWeight.medium,
          ),
          Constants.verticalSpaceSmall,
          // title
          CustomTextWidget(
            Helpers.translatingWord(
              "bookNewAppointmentChooseAppointmentTypeWord",
            ),
            fontColor: AppColor.black,
            fontSize: 24.0,
            height: 1.3,
          ),
          const CustomVerticalSpace(height: 18.0),
          // subtitle
          // CustomTextWidget(
          //   Helpers.translatingWord("bookNewAppointmentUnreadableContentWord"),
          //   fontColor: AppColor.black400,
          //   fontWeight: AppFontWeight.medium,
          //   textAlign: TextAlign.start,
          //   height: 1.3,
          // ),
        ],
      ),
    );
  }
}
*/
