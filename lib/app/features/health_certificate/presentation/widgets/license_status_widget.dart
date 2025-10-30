import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/enums/health_certificate.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class LicenseStatusWidget extends StatelessWidget {
  final LICENSE_MANAGEMENT_STATUS licenseStatus;
  final String licenseStatusName;

  const LicenseStatusWidget(
      {Key? key, required this.licenseStatus, required this.licenseStatusName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.semiSmallPadding,
        vertical: Constants.semiSmallPadding / 2.0,
      ),
      decoration: BoxDecoration(
        color: _getLicenseStatusBackgroundColor(),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: CustomTextWidget(
        _getLicenseStatus(),
        fontColor: _getLicenseStatusColor(),
        fontWeight: AppFontWeight.medium,
        fontSize: 12.0,
      ),
    );
  }

  Color _getLicenseStatusBackgroundColor() {
    switch (licenseStatus) {
      case LICENSE_MANAGEMENT_STATUS.PASSED_AND_COMPLETED_TRAINING:
      case LICENSE_MANAGEMENT_STATUS.ACTIVE:
      case LICENSE_MANAGEMENT_STATUS.SADAD_BILL_ISSUED:
      case LICENSE_MANAGEMENT_STATUS.EXPIRED:
      case LICENSE_MANAGEMENT_STATUS.PENDING_REQUEST_EXISTS:
        return AppColor.lightKhaki;

      case LICENSE_MANAGEMENT_STATUS.CANCELED:
      case LICENSE_MANAGEMENT_STATUS.CANCELLED:
      case LICENSE_MANAGEMENT_STATUS.REJECTED:
      case LICENSE_MANAGEMENT_STATUS.DONE:
      case LICENSE_MANAGEMENT_STATUS.FAILED:
      case LICENSE_MANAGEMENT_STATUS.HOLDED:
        return AppColor.red200;
      case LICENSE_MANAGEMENT_STATUS.WAITING_PAY_PROCCESS:
      case LICENSE_MANAGEMENT_STATUS.WAITING_MEDICAL_TRAINING:
      case LICENSE_MANAGEMENT_STATUS.WAITING_MEDICAL_EXAM:
      case LICENSE_MANAGEMENT_STATUS.WAITING_EMPLOYEE_VISIT:
      case LICENSE_MANAGEMENT_STATUS.BUY_BAG:
      case LICENSE_MANAGEMENT_STATUS.GO_TO_COURSE:
      case LICENSE_MANAGEMENT_STATUS.RECIPT_FOR_RETEST:
        return AppColor.orange150;

      case LICENSE_MANAGEMENT_STATUS.DRAFT:
        return AppColor.black100;
      default:
        return AppColor.lightKhaki;
    }
  }

  Color _getLicenseStatusColor() {
    switch (licenseStatus) {
      //case LICENSE_MANAGEMENT_STATUS.valid:
      // case LICENSE_MANAGEMENT_STATUS.donePayment:
      // case LICENSE_MANAGEMENT_STATUS.completed:
      case LICENSE_MANAGEMENT_STATUS.PASSED_AND_COMPLETED_TRAINING:
      case LICENSE_MANAGEMENT_STATUS.ACTIVE:
      case LICENSE_MANAGEMENT_STATUS.SADAD_BILL_ISSUED:
      case LICENSE_MANAGEMENT_STATUS.EXPIRED:
      case LICENSE_MANAGEMENT_STATUS.PENDING_REQUEST_EXISTS:
        return AppColor.lightGreen1;
      //case LICENSE_MANAGEMENT_STATUS.expired:
      //case LICENSE_MANAGEMENT_STATUS.revoked:
      case LICENSE_MANAGEMENT_STATUS.CANCELED:
      case LICENSE_MANAGEMENT_STATUS.CANCELLED:
      case LICENSE_MANAGEMENT_STATUS.REJECTED:
      case LICENSE_MANAGEMENT_STATUS.DONE:
      case LICENSE_MANAGEMENT_STATUS.FAILED:
      case LICENSE_MANAGEMENT_STATUS.HOLDED:
        return AppColor.redBrown;
      //  case LICENSE_MANAGEMENT_STATUS.awaitPayment:
      // case LICENSE_MANAGEMENT_STATUS.underProcedure:

      case LICENSE_MANAGEMENT_STATUS.WAITING_PAY_PROCCESS:
      case LICENSE_MANAGEMENT_STATUS.WAITING_MEDICAL_TRAINING:
      case LICENSE_MANAGEMENT_STATUS.WAITING_MEDICAL_EXAM:
      case LICENSE_MANAGEMENT_STATUS.WAITING_EMPLOYEE_VISIT:
      case LICENSE_MANAGEMENT_STATUS.BUY_BAG:
      case LICENSE_MANAGEMENT_STATUS.GO_TO_COURSE:
      case LICENSE_MANAGEMENT_STATUS.RECIPT_FOR_RETEST:
        return AppColor.orange800;

      case LICENSE_MANAGEMENT_STATUS.DRAFT:
        return AppColor.kGray115;
      default:
        return AppColor.lightGreen1;
    }
  }

  String _getLicenseStatus() {
    return licenseStatusName;

    switch (licenseStatus) {
      case LICENSE_MANAGEMENT_STATUS.valid:
        return Helpers.translatingWord("userLicensesLicenseStatusValidWord");
      case LICENSE_MANAGEMENT_STATUS.completed:
        return Helpers.translatingWord("completed");
      case LICENSE_MANAGEMENT_STATUS.donePayment:
        return Helpers.translatingWord("donePayment");
      case LICENSE_MANAGEMENT_STATUS.expired:
        return Helpers.translatingWord("expired");
      case LICENSE_MANAGEMENT_STATUS.revoked:
        return Helpers.translatingWord("userLicensesLicenseStatusRevokedWord");
      case LICENSE_MANAGEMENT_STATUS.underProcedure:
        return Helpers.translatingWord("under_procedure");
      case LICENSE_MANAGEMENT_STATUS.awaitPayment:
        return Helpers.translatingWord("awaitPayment");
      default:
        return Helpers.translatingWord("userLicensesLicenseStatusValidWord");
    }
  }
}
