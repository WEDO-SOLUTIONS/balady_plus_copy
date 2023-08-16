import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../home_exports.dart';

class CertificationMapCard extends StatelessWidget {
  const CertificationMapCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 215,
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        image: DecorationImage(
          image: AssetImage(ImagePath.certificationMapBg),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 18, right: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomTextWidget(
                      "خريطة شهادة الإمتثال",
                      fontColor: AppColor.blackModern800Light,
                      fontWeight: AppFontWeight.bold,
                      fontSize: 14,
                    ),
                    const SizedBox(height: 6),
                    const Padding(
                      padding: EdgeInsetsDirectional.only(end: 110),
                      child: CustomTextWidget(
                        "استفد من خريطة الإمتثال لمعرفة أولوية متى يجب أن تحصل على شهادة الإمتثال لمتجرك",
                        fontColor: AppColor.blackModern600Light,
                        fontWeight: AppFontWeight.bold,
                        fontSize: 12,
                        textAlign: TextAlign.start,
                        maxLines: null,
                        height: 1.5,
                      ),
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
                      text: "عرض الاشتراطات",
                      onPressed: () async {},
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16)),
                  color: AppColor.white.withOpacity(0.6),
                ),
                child: const Row(
                  children: [
                    CustomTextWidget(
                      "لمعرفه المزيد عن الخريطه اطلع على",
                      fontWeight: AppFontWeight.bold,
                      fontSize: 10,
                      fontColor: AppColor.blackModern900Light,
                    ),
                    SizedBox(width: 4),
                    CustomTextWidget(
                      "الاسئلة الشائعة",
                      fontWeight: AppFontWeight.bold,
                      fontSize: 12,
                      fontColor: AppColor.primary900Light,
                    ),
                  ],
                ),
              )
            ],
          ),
          PositionedDirectional(
            end: 18,
            top: 12,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primary900Light,
              ),
              child: const CustomSvgIconWidget(IconPath.map, iconSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}
