import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/dialogs/cost_notes_dialog.dart';
import 'package:flutter/material.dart';

import '../../../../../../app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../../core/utils/constants/app_color.dart';

class CostItemWidget extends StatelessWidget {
  final String? cost;
  final String? notes;
  final String? financialAttachmentId;
  final String? technicalAttachmentId;
  const CostItemWidget(
      {super.key,
      this.cost,
      this.notes,
      this.financialAttachmentId,
      this.technicalAttachmentId});

  @override
  Widget build(BuildContext context) {
    return cost != null && cost!.isNotEmpty
        ? Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomTextWidget(
                      trans("total_cost"),
                      fontColor: AppColor.black,
                      fontSize: 16,
                    ),
                    CustomHorizontalSpace(width: 16),
                    CustomTextWidget(
                      "$cost  ${trans("sar")}",
                      fontColor: AppColor.darkTurquoise,
                      fontSize: 16,
                    ),
                  ],
                ),
                CustomVerticalSpace(height: 24),
                // if (notes != null && notes!.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    BottomSheetDialog.showDraggableSheet(context,
                        child: OfferCostNotesDialog(
                            notes: notes ?? "",
                            financialAttachmentId: financialAttachmentId,
                            technicalAttachmentId: technicalAttachmentId),
                        isFullHeight: true);
                  },
                  child: CustomTextWidget(
                    trans("click_more_details"),
                    fontColor: AppColor.darkTurquoise,
                    fontSize: 16,
                    textDecoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
