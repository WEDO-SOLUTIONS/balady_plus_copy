import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../location/presentation/pages/acquire_location_page.dart';

class LocationHomeCard extends StatelessWidget {
  const LocationHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(left: 16, right: 16, top: 24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        image: DecorationImage(image: AssetImage("assets/images/home_location_background.webp"), fit: BoxFit.fill),
      ),
      child: Row(
        children: [
          SvgPicture.asset("assets/icons/svg/activiate_location_pin.svg"),
          CustomHorizontalSpace(width: 32),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                const CustomTextWidget(
                  "للاستفادة من الميزات الكاملة للتطبيق يرجى تفعيل الموقع من الإعدادات",
                  fontColor: Color(0x6b111111),
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
                  text: "تفعيل الموقع",
                  onPressed: () async {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) {
                          return AcquireLocationPage();
                        },
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
