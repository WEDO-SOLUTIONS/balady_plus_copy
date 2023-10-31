/*import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CleanContractCard extends StatelessWidget {

  const CleanContractCard(
      {super.key, required this.item, required this.onSelect, this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: AppColor.white),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(IconPath.vdSummuryDesc),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: CustomTextWidget(
                        item.shopName ?? "",
                        fontColor: AppColor.blackModern500Light,
                        fontSize: 16,
                        maxLines: 2,
                        fontWeight: AppFontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              const CustomHorizontalSpace(
                width: 26,
              ),
              if (item != selected)
                Expanded(
                  flex: 1,
                  child: ElevatedButtonWidget.primaryCustom(
                      height: 36,
                      onPressed: () {
                        onSelect(item);
                      },
                      text: "cr_select".tr()),
                ),
              if (item == selected)
                Expanded(
                  flex: 1,
                  child: ElevatedButtonWidget.primaryCustomBorder(
                      height: 36,
                      onPressed: () {
                        onSelect(null);
                      },
                      text: "cr_selected_done".tr()),
                ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    "cr_clean_contract_number".tr(),
                    fontColor: AppColor.primary900Light,
                    fontSize: 12,
                    fontWeight: AppFontWeight.bold,
                  ),
                  const CustomVerticalSpace(height: 8),
                  CustomTextWidget(
                    item.unifiedCleanContractNo.toString() ?? "",
                    fontColor: AppColor.blackModern600Light,
                    fontSize: 14,
                    fontWeight: AppFontWeight.bold,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    "cr_clean_contract_end_date".tr(),
                    fontColor: AppColor.primary900Light,
                    fontSize: 12,
                    fontWeight: AppFontWeight.bold,
                  ),
                  const CustomVerticalSpace(height: 8),
                  CustomTextWidget(
                    item.contractEndDate ?? "",
                    fontColor: AppColor.blackModern600Light,
                    fontSize: 14,
                    fontWeight: AppFontWeight.bold,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
*/