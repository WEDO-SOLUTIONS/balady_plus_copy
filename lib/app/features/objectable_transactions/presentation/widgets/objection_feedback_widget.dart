import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/pages/map/widgets/map_widgets/warning_message.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../objections/domain/entities/objection_details.dart';
import 'objection_feedback_details_dialog.dart';
import 'objection_feedback_reply_details_dialog.dart';

class ObjectionFeedBackWidget extends StatelessWidget {
  final int index;
  final bool isExpanded;
  final Function onExpand;
  final EnquiryItem item;
  final Function onRefresh;
  const ObjectionFeedBackWidget(
      {super.key,
      required this.index,
      required this.isExpanded,
      required this.onExpand,
      required this.item,
      required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onExpand();
      },
      child: Container(
        height: isExpanded ? 300 : 80,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            color: const Color(0x80E6EFEF),
            borderRadius: BorderRadius.circular(8)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                "${"objection_enquiry_item".tr()} ${index + 1}",
                fontColor: AppColor.primary700Light,
                fontSize: 12,
                fontWeight: AppFontWeight.bold,
              ),
              IconButton(
                  onPressed: () {
                    onExpand();
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: AppColor.primary700Light,
                  ))
            ],
          ),
          if (isExpanded) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ObjectionFeedBackLabel(
                  title: "objection_enquiry_item_number".tr(),
                  subTitle: item.enquiryRequestNumber ?? "",
                ),
                ObjectionFeedBackLabel(
                  title: "objection_enquiry_item_date".tr(),
                  subTitle: item.enquiryDate?.toFormattedDate() ?? "",
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ObjectionFeedBackLabel(
                  title: "objection_enquiry_item_status".tr(),
                  subTitle: item.enquiryStatusName ?? "",
                ),
                ObjectionFeedBackLabel(
                  title: "objection_enquiry_item_last_reply".tr(),
                  subTitle: item.enquiryDueDate?.toFormattedDate() ?? "",
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButtonWidget.primaryCustom(
                onPressed: () async {
                  if (item.enquiryStatusId == "001") {
                    var res =
                        await BottomSheetDialog.showDraggableSheet(context,
                            child: ObjectionFeedBackReplyDetailsDialog(
                              item: item,
                            ));

                    if (res == true) {
                      onRefresh();
                    }
                  } else if (item.enquiryStatusId == "003") {
                    showMessage();
                  } else {
                    BottomSheetDialog.showDraggableSheet(context,
                        child: ObjectionFeedBackDetailsDialog(
                          item: item,
                        ));
                  }
                },
                text: "invoice_show_details".tr())
          ]
        ]),
      ),
    );
  }

  void showMessage() {
    BottomSheetDialog.showDraggableSheet(
        NavigationService.navigatorKey.currentContext!,
        child: BottomSheetWithActions(
          title: "details".tr(),
          body: WarningMessage(message: "objection_enquiry_warning".tr()),
        ));
  }
}

class ObjectionFeedBackLabel extends StatelessWidget {
  final String title;
  final String subTitle;

  const ObjectionFeedBackLabel(
      {super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),

      /// decoration: BoxDecoration(
      //    color: Color(0x80E6EFEF), borderRadius: BorderRadius.circular(8)),
      child: Column(children: [
        CustomTextWidget(
          title,
          fontColor: AppColor.primary700Light,
          fontSize: 12,
          fontWeight: AppFontWeight.bold,
        ),
        const SizedBox(
          height: 8,
        ),
        CustomTextWidget(
          subTitle,
          fontColor: AppColor.blackModern500Light,
          fontSize: 14,
          fontWeight: AppFontWeight.bold,
        ),
      ]),
    );
  }
}
