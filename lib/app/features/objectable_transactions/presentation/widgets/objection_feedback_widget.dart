import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../objections/domain/entities/objection_details.dart';
import 'objection_feedback_details_dialog.dart';

class ObjectionFeedBackWidget extends StatelessWidget {
  final int index;
  final bool isExpanded;
  final Function onExpand;
  final EnquiryItem item;
  const ObjectionFeedBackWidget(
      {super.key,
      required this.index,
      required this.isExpanded,
      required this.onExpand,
      required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isExpanded ? 300 : 80,
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: Color(0x80E6EFEF), borderRadius: BorderRadius.circular(8)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextWidget(
              "${index}",
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
                title: "رقم الافاده",
                subTitle: item.enquiryRequestNumber ?? "",
              ),
              ObjectionFeedBackLabel(
                title: "تاريخ الافاده",
                subTitle: "12/2/2024",
              ),
            ],
          ),
          SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ObjectionFeedBackLabel(
                title: "حاله الافاده",
                subTitle: item.enquiryStatusName ?? "",
              ),
              ObjectionFeedBackLabel(
                title: "اخر تاريخ للرد",
                subTitle: "12/2/2024",
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButtonWidget.primaryCustom(
              onPressed: () {
                BottomSheetDialog.showDraggableSheet(context,
                    child: ObjectionFeedBackDetailsDialog(
                      item: item,
                    ));
              },
              text: "عرض التفاصيل")
        ]
      ]),
    );
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
