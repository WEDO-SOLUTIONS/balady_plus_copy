import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../home_exports.dart';

class BaladySmartAdvisorCard extends StatelessWidget {
  const BaladySmartAdvisorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (CommonProperties.isLoggedIn) {
          Navigator.pushNamed(context, RouteName.municipalAdvisor);
        } else {
          showDialog(
              context: context,
              builder: (ctx) =>
                  NeedLoginDialog(onSuccessLogin: (bool? isSuccess) async {
                    if (isSuccess ?? false) {
                      Navigator.pushNamed(context, RouteName.municipalAdvisor);
                    }
                  }));
        }
      },
      child: HomeSection(
        title: 'المستشار الذكي',
        child: Container(
          height: 172,
          width: MediaQuery.sizeOf(context).width,
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
                    const CustomTextWidget(
                      "مستشارك الذكي",
                      fontColor: AppColor.blackModern800Light,
                      fontWeight: AppFontWeight.bold,
                      fontSize: 14,
                    ),
                    const SizedBox(height: 6),
                    const CustomTextWidget(
                      "دليلك الآلي للحصول على إجابات سريعة حول الاشتراطات البلدية",
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
                      text: "اسأل المستشار",
                    ),
                  ],
                ),
              ),
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
