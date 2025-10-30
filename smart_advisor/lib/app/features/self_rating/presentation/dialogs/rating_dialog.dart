import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/services/local/navigation_services.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/custom_button.dart';

class RatingDialog extends StatefulWidget {
  final Function onSelection;
  final bool isGuest;
  const RatingDialog(
      {super.key, required this.onSelection, required this.isGuest});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  String search = "";
  int? selection;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 600,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: AppColor.surfaceMidContrast,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "تقييم منشأة ذاتياً",
                        style: AppStyle.heading2BoldStyle,
                      ),
                      GestureDetector(
                        onTap: () {
                          NavigationService.navigatorKey.currentState!.pop();
                        },
                        child: SvgPicture.asset(
                            "packages/smart_advisor/smart_advisor_assets/icons/svg/Button.svg"),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Image.asset(
                      "packages/smart_advisor/smart_advisor_assets/icons/png/rating_icon.png"),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    "سيساعدك هذا التقييم على زيادة وعيك باحتياجات منشأتك وتحديد نقاط التحسين من اجل الارتقاء بمستوى الامتثال.",
                    style: AppStyle.textRegularStyle.copyWith(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 64,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xCCF4F6FB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "packages/smart_advisor/smart_advisor_assets/icons/png/rating_icon1.png",
                              height: 35,
                              width: 35,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "المدة التقديرية",
                                  style: AppStyle.textRegularRomanStyle
                                      .copyWith(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "20 دقيقة",
                                  style: AppStyle.textRegularRomanStyle
                                      .copyWith(
                                          fontSize: 14,
                                          color: AppColor.textSecondaryColor),
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "packages/smart_advisor/smart_advisor_assets/icons/png/rating_icon2.png",
                              height: 35,
                              width: 35,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "عدد الخطوات",
                                  style: AppStyle.textRegularRomanStyle
                                      .copyWith(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "3",
                                  style: AppStyle.textRegularRomanStyle
                                      .copyWith(
                                          fontSize: 14,
                                          color: AppColor.textSecondaryColor),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    "في نهاية التقييم، ستحصل على نسبة امتثال منشأتك وقائمة بالبنود التي تحتاج إلى اهتمامك.",
                    style: AppStyle.textRegularStyle.copyWith(fontSize: 14),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                    height: 122,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        /* Expanded(
                            child: CustomButton(
                          onPress: () {
                            Navigator.of(context).pop();
                          },
                          text: "التراجع",
                          btnBorderColor: const Color(0x941E2A36),
                          btnColor: Colors.transparent,
                          textColor: const Color(0x941E2A36),
                        )),
                        const SizedBox(
                          width: 16,
                        ),*/
                        Expanded(
                            flex: 2,
                            child: CustomButton(
                                onPress: () {
                                  Navigator.of(context).pop();

                                  widget.onSelection();
                                },
                                text: "بدء التقييم"))
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
