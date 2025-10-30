import 'package:flutter/material.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(title: "المساعدة"),
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
            InkWell(
              onTap: () =>
                  Navigator.of(context).pushNamed(RouteName.contactInfoPage),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    CustomSvgIconWidget(
                      IconPath.call,
                      iconSize: 18,
                    ),
                    SizedBox(width: 20),
                    CustomTextWidget(
                      "معلومات التواصل",
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
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                RouteName.inappWebview,
                arguments: (
                  requestNum: "موقع بلدي الالكتروني",
                  url: "https://balady.gov.sa/ar",
                  isObjections: false
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    CustomSvgIconWidget(
                      IconPath.global,
                      iconSize: 18,
                    ),
                    SizedBox(width: 20),
                    CustomTextWidget(
                      "موقع بلدي الالكتروني",
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
