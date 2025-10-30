import 'package:flutter/material.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_config.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';
import 'package:smart_advisor/app/core/utils/constants/language.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/route_names.dart';

class ChatgptWidget extends StatelessWidget {
  const ChatgptWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationService.navigatorKey.currentState!
            .pushNamed(RouteName.qrDetails);
      },
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Container(
          padding:
              const EdgeInsets.only(left: 16.0, right: 16, top: 20, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "scanQR".tr(),
                    style: AppStyle.calloutBoldStyle
                        .copyWith(color: AppColor.textPrimaryColor),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.60,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: "scanQrDetails".tr(),
                              style: AppStyle.footNoteMediumStyle.copyWith(
                                  color: AppColor.textSecondaryColor,
                                  height: 1.7))

                          /* TextSpan(
                            text: 'ابدأ المحادثة مع',
                            style: AppStyle.footNoteMediumStyle.copyWith(
                                color: AppColor.textSecondaryColor,
                                height: 1.7),
                          ),
                          TextSpan(
                            text: ' المساعد الذكي ',
                            style: AppStyle.footNoteBoldStyle
                                .copyWith(color: AppColor.primary),
                          ),
                          TextSpan(
                            text: 'للإجابة على استفسارك',
                            style: AppStyle.footNoteMediumStyle.copyWith(
                                color: AppColor.textSecondaryColor,
                                height: 1.7),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Image.asset(
                  'packages/smart_advisor/smart_advisor_assets/images/barcode.png')
            ],
          ),
        ),
      ),
    );
  }
}
