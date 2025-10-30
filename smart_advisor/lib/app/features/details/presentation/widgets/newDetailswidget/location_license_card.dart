import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationLicenseCard extends StatelessWidget {
  final int number;
  const LocationLicenseCard({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -20,
            top: -35,
            child: Container(
              height: 41,
              width: 41,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(25)),
              ),
              child: FittedBox(
                child: Container(
                  height: 31,
                  width: 31,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.textPrimaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Text(
                    "0" + number.toString(),
                    textAlign: TextAlign.center,
                    style: AppStyle.footNoteBoldStyle
                        .copyWith(color: AppColor.surfacePrimaryColor),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(top: 24, left: 16, right: 24, bottom: 24),
            width: double.infinity,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "الحصول على موقع عملك",
                    style: AppStyle.somarSemiBold.copyWith(
                        color: AppColor.textPrimaryColor, fontSize: 16),
                  ),
                  SvgPicture.asset(IconPath.locationIcon)
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                  "تأكد من ضمانك للموقع الذي ستمارس فيه عملك من خلال استئجاره أو تملكه، حيث لن يمكنك إصدار رخصتك دون وجود موقع مؤكد وإثبات لملكيته.",
                  style: AppStyle.textRegularStyle.copyWith(
                      color: AppColor.textSecondaryColor,
                      fontSize: 14,
                      height: 1.7)),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 110,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color(0xff568F64).withOpacity(0.21)),
                  color: const Color(0xff568F64).withOpacity(0.04),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    Text(
                        "كما يمكنك الاطلاع على مواقع متاحة لك كفرص استثمارية من وزارة البلديات والاسكان",
                        style: AppStyle.textRegularStyle.copyWith(
                            color: AppColor.textSecondaryColor,
                            fontSize: 14,
                            height: 1.6)),
                    const SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (Platform.isAndroid) {
                          launchUrl(Uri.parse(
                              "https://play.google.com/store/apps/details?id=platform.codes.investmentopportunities&hl=ar"));
                        } else {
                          launchUrl(Uri.parse(
                              "https://apps.apple.com/sa/app/%D9%81-%D8%B1%D8%B5/id1372788277"));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                IconPath.furasIcon,
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                "الذهاب لتطبيق فرص",
                                style: AppStyle.footNoteRomanStyle.copyWith(
                                  color: AppColor.primary,
                                ),
                              ),
                            ],
                          ),
                          SvgPicture.asset(IconPath.stepArrowIcon)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
