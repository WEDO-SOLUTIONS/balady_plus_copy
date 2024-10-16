import '../../../core/services/local/navigation_services.dart';
import '/app/core/utils/constants/language.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import '/app/core/utils/constants/language.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';
import '/app/features/start_page/startPage.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';

class Header extends StatelessWidget {
  const Header({super.key});

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
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "packages/smart_advisor/smart_advisor_assets/backgrVD.png",
              ),
            ),
          ),
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
                SvgPicture.asset(IconPath.home),
                //SvgPicture.asset("packages/smart_advisor/smart_advisor_assets/images/qq.svg"),
                SvgPicture.asset(
                    "packages/smart_advisor/smart_advisor_assets/images/barcoode.svg"),
              ],
            ),
            Column(
              children: [
                Text(
                  ("guide_vd").tr(),
                  style: GoogleFonts.cairo(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    " تعرف على أنواع التشوه البصري وطريقة معالجته لبناء مجتمع اجمل نفخر به!   ",
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
              height: 50,
            ),
            const Textfield(),
          ],
        ),
      ),
    ]);
  }
}
