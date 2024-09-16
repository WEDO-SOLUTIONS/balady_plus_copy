import 'package:smart_advisor/app/features/home_page/presentation/pages/search_page.dart';

import '../../../../core/services/local/navigation_services.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/shared_features/widgets/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';
import '/app/features/start_page/startPage.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import '/app/core/utils/constants/language.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

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
          height: 281,
          decoration: BoxDecoration(
              color: AppColor.statusAccentColor,
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
        padding: const EdgeInsetsDirectional.only(top: 50, end: 16, start: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButtonIcon(
                  icon: IconPath.homeIcon,
                  onPress: () {
                    Navigator.pop(context);
                  },
                ),
                CustomButtonIcon(
                  icon: IconPath.barcodeIcon,
                  onPress: () {
                    NavigationService.navigatorKey.currentState!
                        .pushNamed(RouteName.qrDetails);
                  },
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  ("interactive_guide").tr(),
                  style:
                      AppStyle.accentBoldStyle.copyWith(color: AppColor.white),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "تعرف على كافة الاشتراطات والمعلومات المتعلقة بالمنشأة ",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: GoogleFonts.cairo(
                        //wordSpacing: 5.0,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => const SearchPage()));
                },
                child: const Textfield(
                  isEnabled: false,
                )),
          ],
        ),
      ),
    ]);
  }
}
