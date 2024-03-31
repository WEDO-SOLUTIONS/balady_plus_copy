/*import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/dialogs/dialog_header.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../core/models/health_request_details.dart';
import '../license_details_header_section.dart';
import 'bill_details_card_widget.dart';

class LicenseBillBodySectionWidget extends StatelessWidget {
  BillInfo billInfo;
  String typeName;
  String licenseNumber;
  LicenseBillBodySectionWidget(
      {Key? key,
      required this.billInfo,
      required this.typeName,
      required this.licenseNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 26, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // bill info
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: DialogHeader(
              title: Helpers.translatingWord('bill_info'),
            ),
          ),
          const CustomVerticalSpace(height: 20),
          LicenseDetailsHeaderSection(
            licenseManagementStatus: billInfo.getBillStatus(),
            licensetStatusName: billInfo.billStatus ?? "",
            title: typeName,
            licenseId: licenseNumber,
          ),
          const CustomVerticalSpace(height: 24),
          const DrawLineWidget(),
          const CustomVerticalSpace(height: 10),

          _BillInfoWidget(
            createDate: billInfo.billCreationDate ?? "",
            billNumber: billInfo.billNumber ?? "",
          ),
          // // bill details
          if (billInfo.billFees != null && billInfo.billFees!.isNotEmpty)
            BillDetailsWidget(
                fees: billInfo.billFees!, totalAmount: billInfo.billAmount),
          Constants.verticalSpaceLarge,
        ],
      ),
    );
  }
}

class _BillInfoWidget extends StatelessWidget {
  String createDate;
  String billNumber;

  _BillInfoWidget({required this.createDate, required this.billNumber});

  @override
  Widget build(BuildContext context) {
    return CustomExpansionPanelWidget(
      title: Helpers.translatingWord("health_bill_info"),
      underline: false,
      children: [
        FieldData(
          title: Helpers.translatingWord("health_bill_date"),
          subTitle: createDate,
        ),
        FieldData(
          title: Helpers.translatingWord("health_bill_number"),
          subTitle: billNumber,
        ),
      ],
    );
  }
}
*/
