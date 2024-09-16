import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeRecentCard extends StatelessWidget {
  final Function onPress;
  const HomeRecentCard({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPress(),
      child: Container(
        margin: const EdgeInsetsDirectional.only(bottom: 8, end: 16),
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: BoxDecoration(
          color: AppColor.surfaceSecondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "محطه وقود",
                      style: AppStyle.textRegularRomanStyle
                          .copyWith(color: AppColor.textPrimaryColor),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Flexible(
                      child: Text(
                        "تصفح كافة الاشتراطات والمعلومات المتعلقة بالمنشأة .",
                        style: AppStyle.footNoteRomanStyle
                            .copyWith(color: AppColor.textTertiaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SvgPicture.asset(IconPath.arrowLeftSide)
          ],
        ),
      ),
    );

    /* return InkWell(
      onTap: () {
        onPress();
      },
      child: Container(
        width: 297,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsetsDirectional.only(end: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          image: const DecorationImage(
              alignment: Alignment.topLeft,
              image: AssetImage(
                "packages/smart_advisor/smart_advisor_assets/images/aaaa.png",
              )),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                height: 27,
                width: 80,
                padding: const EdgeInsets.only(right: 7, left: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3EFFC),
                  borderRadius: BorderRadius.circular(72),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset('packages/smart_advisor/smart_advisor_assets/images/GasPump.svg'),
                    Text(
                      "محطات",
                      style: GoogleFonts.cairo(
                          fontSize: 11, color: const Color(0xFF73AFEF)),
                    ),
                  ],
                ),
              ),

              //    Spacer(),
              SvgPicture.asset(
                "packages/smart_advisor/smart_advisor_assets/images/row.svg",
              ),
            ]),
            Text(
              "محطه وقود",
              style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              "تصفح كافة الاشتراطات والمعلومات المتعلقة بالمنشأة .",
              style: GoogleFonts.cairo(
                  fontSize: 16, color: const Color(0xFF8E8E93)),
            ),
          ],
        ),
      ),
    );*/
  }
}
