import 'package:smart_advisor/app/features/home_page/presentation/pages/search_page.dart';

import '../../../../core/services/local/navigation_services.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/shared_features/widgets/custom_icon.dart';
import 'package:flutter/material.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';
import '/app/features/start_page/startPage.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';

class SectorHeader extends StatelessWidget {
  const SectorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      InkWell(
        onTap: () {
          NavigationService.navigatorKey.currentState!.push(
            MaterialPageRoute(builder: (context) => Startpage()),
          );
        },
        child: Container(
          height: 280,
          decoration: const BoxDecoration(
              // color: AppColor.statusAccentColor,
              image: const DecorationImage(
                  image: AssetImage(
                    "packages/smart_advisor/smart_advisor_assets/images/header_background.png",
                  ),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
        ),
      ),
      Padding(
        padding: EdgeInsetsDirectional.only(
            top: MediaQuery.of(context).padding.top, end: 16, start: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButtonIcon(
                  icon: IconPath.homeIcon2,
                  onPress: () {
                    Navigator.pop(context);
                  },
                ),
                CustomButtonIcon(
                  icon: IconPath.QRCode,
                  onPress: () {
                    NavigationService.navigatorKey.currentState!
                        .pushNamed(RouteName.qrDetails);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  ("فتح محل تجاري"),
                  style: AppStyle.heading1BoldStyle
                      .copyWith(color: AppColor.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 130),
                  child: Container(
                    //  margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "اعرف كافة الاشتراطات والمعلومات المتعلقة بالمنشأة ",
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      style: AppStyle.textRegularRomanStyle
                          .copyWith(color: AppColor.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => const SearchPage()));
                },
                child: const Textfield(
                  isEnabled: false,
                  title: "ابحث عن منشاه ...",
                )),
          ],
        ),
      ),
    ]);
  }
}
