import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';

class PrayerHomeCard extends StatelessWidget {
  const PrayerHomeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 234,
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.only(left: 16,right: 16,top: 12),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        image: DecorationImage(
          image: AssetImage(ImagePath.prayerBg),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      "صلاه المغرب",
                      fontColor: AppColor.primary900Light,
                      fontWeight: AppFontWeight.bold,
                      fontSize: 11,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        CustomTextWidget(
                          "PM",
                          fontColor: AppColor.white,
                          fontWeight: AppFontWeight.semiBold,
                          fontSize: 14,
                        ),
                        SizedBox(width: 4),
                        CustomTextWidget(
                          "08:23",
                          fontColor: AppColor.white,
                          fontWeight: AppFontWeight.bold,
                          fontSize: 28,
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.white.withOpacity(0.1),
                  ),
                  child: const CustomSvgIconWidget(
                    IconPath.notificationIc2,
                    iconSize: 24,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              color: AppColor.primary900Light.withOpacity(0.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                        "متبقي على وقت اذان المغرب",
                        fontColor: AppColor.white,
                        fontWeight: AppFontWeight.bold,
                        fontSize: 12,
                      ),
                      SizedBox(height: 8),
                      CustomTextWidget(
                        "57 : 04",
                        fontColor: AppColor.white,
                        fontWeight: AppFontWeight.semiBold,
                        fontSize: 26,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 20),
                    child: CustomElevatedButtonWidget(
                      btnColor: AppColor.secondary400Light,
                      textStyle: AppStyle.elevatedButtonStyle.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                      btnHeight: 40,
                      btnPadding: const EdgeInsets.all(11),
                      text: "عرض اوقات الصلوات",
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
