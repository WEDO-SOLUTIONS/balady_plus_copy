import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';

class IssueLicenseCard extends StatelessWidget {
  final int number;
  const IssueLicenseCard({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
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
                    "إصدار سجلك التجاري",
                    style: AppStyle.somarSemiBold.copyWith(
                        color: AppColor.textPrimaryColor, fontSize: 16),
                  ),
                  SvgPicture.asset(IconPath.issueCrIcon)
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                  "السجل التجاري الذي يحتوي على النشاط المراد اصدار الترخيص له متطلب اساسي لإصدار الرخصة الخاصة بعملك، في حال لم يكن لديك سجل تجاري، يمكنك بدء إجراءات التسجيل من خلال",
                  style: AppStyle.textRegularStyle.copyWith(
                      color: AppColor.textSecondaryColor,
                      fontSize: 14,
                      height: 1.7)),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color(0xff568F64).withOpacity(0.21)),
                  color: const Color(0xFF568F64).withOpacity(0.04),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: GestureDetector(
                  onTap: () {
                    CommonFunctions.openWebView(
                        context: context,
                        title: "",
                        URL:
                            "https://mc.gov.sa/ar/eservices/Pages/ServiceDetails.aspx?sID=2");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        " بوابة وزارة التجارة",
                        style: AppStyle.footNoteRomanStyle.copyWith(
                          color: AppColor.primary,
                        ),
                      ),
                      SvgPicture.asset(
                        IconPath.stepArrowIcon,
                      )
                    ],
                  ),
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
