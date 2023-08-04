import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../home_exports.dart';

class DraggableHeaderComponent extends StatelessWidget {
  const DraggableHeaderComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColor.blackModern900Light.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
          color: AppColor.scaffoldBackground),
      child: Column(
        children: [
          const DrawLineWidget(
            lineWidth: 32,
            lineHeight: 4,
            lineColor: AppColor.gray10,
            radius: 46.0,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomTextWidget(
                    DateTime.now().hour > 12
                        ? "مساء الخير ، "
                        : "صباح الخير ، ",
                    fontSize: 14,
                    fontWeight: AppFontWeight.bold,
                    fontColor: AppColor.blackModern600Light,
                  ),
                  CustomTextWidget(
                    CommonProperties.userInfo?.getFirstAndLastName() ?? '',
                    fontSize: 18,
                    fontWeight: AppFontWeight.bold,
                    fontColor: AppColor.primary900Light,
                  ),
                ],
              ),
              const CurrentWeather(
                weatherCondition: WeathherConditions.clear,
                temperature: "16",
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextFieldWidget(
            hintText: 'ابحث هنا...'.tr(),
            hintStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColor.blackModern600Light,
              height: 1,
            ),
            textFieldVerticalPadding: 16,
            suffixIcon: const DrawIconBasedTypeWidget(
              icon: IconPath.search,
              iconSize: 20,
              iconColor: AppColor.primary900Light,
            ),
            borderRadius: 26,
            borderColor: AppColor.primary900Light.withOpacity(0.1),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
