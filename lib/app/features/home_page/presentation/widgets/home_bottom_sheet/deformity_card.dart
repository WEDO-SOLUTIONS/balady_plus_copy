import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../vd/presentation/dialogs/vd_types_dialog.dart';

class DeformityHomeCard extends StatelessWidget {
  const DeformityHomeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(left: 16, right: 16, top: 0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        image: DecorationImage(
          image: AssetImage(ImagePath.deformityBg),
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
                  "مظاهر التشوه",
                  fontColor: AppColor.blackModern800Light,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 14,
                ),
                const SizedBox(height: 6),
                const CustomTextWidget(
                  "تعرف على انواع التشوه البصري وكيفية مكافحتها",
                  fontColor: AppColor.blackModern800Light,
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
                  btnWidth: 157,
                  text: "تعرف على انواع التشوه",
                  onPressed: () =>
                      context.pushNamedRoute(RouteName.visualDistortionPage),
                ),
              ],
            ),
          ),
          const Expanded(flex: 2, child: SizedBox()),
        ],
      ),
    );
  }
}
