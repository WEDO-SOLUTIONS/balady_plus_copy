import '../../../core/services/local/navigation_services.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/home_page/presentation/pages/homePage.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import '/app/features/start_page/widgets/happy_news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InternetDialog extends StatelessWidget {
  const InternetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 250,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 20),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'اختر',
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
                height: 8,
              ),
              Text(
                'هل سيكون العمل الجديد عبر الانترنت بشكل كامل',
                style: AppStyle.textRegularRomanStyle,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  CustomButton(
                      btnHeight: 40,
                      btnWidth: 174,
                      btnColor: AppColor.surfaceAccentSecondaryColor,
                      textColor: AppColor.statusAccentColor,
                      onPress: () {
                        showModalBottomSheet(
                          backgroundColor: const Color(0xff000000),
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) =>
                              const HappyNewsDialog(),
                        );
                      },
                      text: 'نعم'),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomButton(
                      btnHeight: 40,
                      btnWidth: 174,
                      btnColor: AppColor.statusAccentColor,
                      onPress: () {
                        NavigationService.navigatorKey.currentState!.push(
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      text: 'لا'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
