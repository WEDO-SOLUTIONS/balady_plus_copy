import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import '../../../../../../features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../commercial_license_exports.dart' show InvestmentContractItem;

class InvestMentContractCard extends StatelessWidget {
  final InvestmentContractItem item;
  final Function onSelect;
  final InvestmentContractItem? selected;
  const InvestMentContractCard(
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
                        item.contractName ?? "",
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
                    "cr_investment_code".tr(),
                    fontColor: AppColor.primary900Light,
                    fontSize: 12,
                    fontWeight: AppFontWeight.bold,
                  ),
                  const CustomVerticalSpace(height: 8),
                  CustomTextWidget(
                    item.siteContractId ?? "",
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
                    "cr_investment_type".tr(),
                    fontColor: AppColor.primary900Light,
                    fontSize: 12,
                    fontWeight: AppFontWeight.bold,
                  ),
                  const CustomVerticalSpace(height: 8),
                  CustomTextWidget(
                    item.typeName ?? "",
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
