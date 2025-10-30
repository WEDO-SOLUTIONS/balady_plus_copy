import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class AppointmentStatusWidget extends StatelessWidget {
  final int appointmentStatusId;
  final String statusText;

  const AppointmentStatusWidget(
      {Key? key, required this.appointmentStatusId, required this.statusText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.semiSmallPadding,
        vertical: Constants.smallPadding / 1.5,
      ),
      decoration: BoxDecoration(
        color: _getAppointmentStatusBackgroundColor(),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: CustomTextWidget(
        statusText,
        fontColor: _getAppointmentStatusColor(),
        fontWeight: AppFontWeight.medium,
        fontSize: 12.0,
      ),
    );
  }

  Color _getAppointmentStatusBackgroundColor() {
    switch (appointmentStatusId) {
      case 1:
        return AppColor.lightKhaki;
      case 2:
        return AppColor.black100;
      case 3:
        return AppColor.red200;
      case 4:
        return AppColor.orange150;
      default:
        return AppColor.black100;
    }
  }

  Color _getAppointmentStatusColor() {
    switch (appointmentStatusId) {
      case 1:
        return AppColor.lightGreen1;
      case 2:
        return AppColor.black500;
      case 3:
        return AppColor.redBrown;
      case 4:
        return AppColor.orange800;
      default:
        return AppColor.black500;
    }
  }
}
