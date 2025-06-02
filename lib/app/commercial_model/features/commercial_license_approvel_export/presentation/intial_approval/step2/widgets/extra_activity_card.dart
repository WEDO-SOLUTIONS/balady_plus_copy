import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/initialApproval/addetional_activity_request.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/utils_exports.dart';

import '../../../../../../../features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';


class ExtraActivityCard extends StatelessWidget {
  final AddetionalActivityRequest item;
  final Function onDelete;
  const ExtraActivityCard(
      {super.key, required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: AppColor.primary50Light.withOpacity(0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                "subActivity".tr(),
                fontColor: AppColor.primary700Light,
                fontSize: 12,
                fontWeight: AppFontWeight.bold,
              ),
              CustomIconButtonWidget(
                iconColor: AppColor.redBrown,
                icon: Icons.delete,
                onPressed: () {
                  onDelete();
                },
              )
            ],
          ),
          const SizedBox(height: 8),
          CustomTextWidget(
            item.item?.name ?? "",
            fontColor: AppColor.blackModern600Light,
            fontSize: 16,
            fontWeight: AppFontWeight.semiBold,
          ),
          // const SizedBox(height: 16),
          // CustomTextWidget(
          //   "subActivity".tr(),
          //   fontColor: AppColor.primary700Light,
          //   fontSize: 12,
          //   fontWeight: AppFontWeight.bold,
          // ),
          // const SizedBox(height: 8),
          // CustomTextWidget(
          //   item.detailsItem?.name ?? "",
          //   fontColor: AppColor.blackModern600Light,
          //   fontSize: 16,
          //   fontWeight: AppFontWeight.semiBold,
          // ),
          // const SizedBox(height: 16),
          // CustomTextWidget(
          //   "fire_approval_type".tr(),
          //   fontColor: AppColor.primary700Light,
          //   fontSize: 12,
          //   fontWeight: AppFontWeight.bold,
          // ),
          // const SizedBox(height: 8),
          // CustomTextWidget(
          //   item.faweryMessage ?? "",
          //   fontColor: AppColor.blackModern600Light,
          //   fontSize: 16,
          //   fontWeight: AppFontWeight.semiBold,
          // ),
           const SizedBox(height: 16),
          CustomTextWidget(
            "activity_area".tr(),
            fontColor: AppColor.primary700Light,
            fontSize: 12,
            fontWeight: AppFontWeight.bold,
          ),
          const SizedBox(height: 8),
          CustomTextWidget(
            item.area.toString() ?? "",
            fontColor: AppColor.blackModern600Light,
            fontSize: 16,
            fontWeight: AppFontWeight.semiBold,
          ),
        ],
      ),
    );
  }
}
