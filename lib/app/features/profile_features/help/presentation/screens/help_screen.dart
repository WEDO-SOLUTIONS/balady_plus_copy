import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(title: "help_page_header".tr()),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: Constants.boxShadow,
          color: AppColor.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () =>
                  Navigator.of(context).pushNamed(RouteName.contactInfoPage),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    CustomSvgIconWidget(
                      IconPath.call,
                      iconSize: 18,
                    ),
                    SizedBox(width: 20),
                    CustomTextWidget(
                      "lbl_more_contactInfo".tr(),
                      fontSize: 14,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern600Light,
                    ),
                    Spacer(),
                    CustomSvgIconWidget(
                      IconPath.arrowLeft,
                      iconSize: 14,
                      iconColor: AppColor.blackModern800Light,
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Divider(
                color: AppColor.blackModern200Light,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                RouteName.inappWebview,
                arguments: (
                  title: "lbl_more_balady_website".tr(),
                  url: "https://balady.gov.sa/ar"
                ),
              ),
              child:  Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    CustomSvgIconWidget(
                      IconPath.global,
                      iconSize: 18,
                    ),
                    SizedBox(width: 20),
                    CustomTextWidget(
                      "lbl_more_balady_website".tr(),
                      fontSize: 14,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern600Light,
                    ),
                    Spacer(),
                    CustomSvgIconWidget(
                      IconPath.arrowLeft,
                      iconSize: 14,
                      iconColor: AppColor.blackModern800Light,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
