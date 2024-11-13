import '../../../select_activity/domain/entities/activity_details_page_params.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import 'package:flutter/material.dart';

class HomeRecentCard extends StatelessWidget {
  final Function onPress;
  final ActivityDetailsPageParams item;
  final animation;
  const HomeRecentCard(
      {super.key,
      required this.onPress,
      required this.item,
      required this.animation});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPress(),
      child: Container(
        margin: const EdgeInsetsDirectional.only(bottom: 0, end: 16),
        padding: const EdgeInsets.only(left: 12, right: 21, top: 12, bottom: 0),
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        item.activityId?.name ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.footNoteBoldStyle
                            .copyWith(color: Color(0xff1E2A36)),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
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
            Icon(
              Icons.arrow_forward,
              color: AppColor.textPrimaryColor,
            )
            //  SvgPicture.asset(IconPath.arrowLeftSide)
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
