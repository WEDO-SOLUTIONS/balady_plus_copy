import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../home_exports.dart';

class BaladySmartAdvisorCard extends StatelessWidget {
  const BaladySmartAdvisorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (CommonProperties.isLoggedInMunicipality) {
          NavigationService.navigatorKey.currentState!.pushNamed(RouteName.municipalAdvisor);
        } else {
          showDialog(
              context: context,
              builder: (ctx) => NeedLoginDialog(onSuccessLogin: (bool? isSuccess) async {
                    if (isSuccess ?? false) {
                      NavigationService.navigatorKey.currentState!.pushNamed(RouteName.municipalAdvisor);
                    }
                  }));
        }
      },
      child: HomeSection(
        title: 'municipal_advisor'.tr(),
        child: Container(
          height: 172,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            image: DecorationImage(
              image: AssetImage(ImagePath.smartAdvisorBg),
              fit: BoxFit.fill,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                        'advisor_title'.tr(),
                        fontColor: AppColor.blackModern800Light,
                        fontWeight: AppFontWeight.bold,
                        fontSize: 14,
                      ),
                      const SizedBox(height: 6),
                      CustomTextWidget(
                        'advisor_desc'.tr(),
                        fontColor: AppColor.blackModern600Light,
                        fontWeight: AppFontWeight.bold,
                        fontSize: 12,
                        maxLines: null,
                        height: 1.5,
                      ),
                      const SizedBox(height: 12),
                      CustomElevatedButtonWidget(
                        btnColor: AppColor.primary900Light,
                        textStyle: AppStyle.elevatedButtonStyle.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                        btnHeight: 40,
                        btnWidth: 163,
                        text: 'askAdvisor'.tr(),
                        onPressed: () async {
                          if (CommonProperties.isLoggedInMunicipality) {
                            NavigationService.navigatorKey.currentState!.pushNamed(RouteName.municipalAdvisor);
                          } else {
                            showDialog(
                                context: context,
                                builder: (ctx) => NeedLoginDialog(onSuccessLogin: (bool? isSuccess) async {
                                      if (isSuccess ?? false) {
                                        NavigationService.navigatorKey.currentState!
                                            .pushNamed(RouteName.municipalAdvisor);
                                      }
                                    }));
                          }
                        },
                      ),
                    ],
                  )),
              Expanded(
                flex: 2,
                child: Image.asset(ImagePath.supportImg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
