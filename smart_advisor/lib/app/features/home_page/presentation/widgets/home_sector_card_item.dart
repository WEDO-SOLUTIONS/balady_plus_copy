import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';
import 'package:flutter/material.dart';
import '/app/features/_shared_feature_/presentation/models/grideViewModel.dart';
import 'package:flutter_svg/svg.dart';

class HomeSectorCardItem extends StatelessWidget {
  final GrideViewModel item;
  final Function onPress;
  final animation;

  const HomeSectorCardItem(
      {super.key,
      required this.item,
      required this.onPress,
      required this.animation});

  @override
  Widget build(BuildContext context) {
    print("animation ${animation}");
    return InkWell(
      onTap: () => onPress(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColor.surfaceTertairyColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                        color: Color(0xFFF3F9F5),
                        borderRadius: BorderRadius.circular(8)),
                    child: SvgPicture.asset(
                      item.icon ?? "",
                      height: 16,
                      width: 16,
                      fit: BoxFit.scaleDown,
                    )),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.sector ?? "",
                      style: AppStyle.textRegularRomanStyle
                          .copyWith(color: AppColor.textPrimaryColor),
                    ),
                    /*  const SizedBox(
                      height: 4,
                    ),
                    Text(
                      item.category ?? "",
                      style: AppStyle.footNoteRomanStyle
                          .copyWith(color: AppColor.textTertiaryColor),
                    ),*/
                  ],
                ),
              ],
            ),
            SvgPicture.asset(IconPath.arrowLSide),
          ],
        ),
      ),
    );

    return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset(0, 0),
        ).animate(animation),
        child: InkWell(
          onTap: () => onPress(),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.surfaceTertairyColor,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                            color: Color(0xFFF3F9F5),
                            borderRadius: BorderRadius.circular(8)),
                        child: SvgPicture.asset(
                          item.icon ?? "",
                          height: 16,
                          width: 16,
                          fit: BoxFit.scaleDown,
                        )),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.sector ?? "",
                          style: AppStyle.textRegularRomanStyle
                              .copyWith(color: AppColor.textPrimaryColor),
                        ),
                        /*  const SizedBox(
                      height: 4,
                    ),
                    Text(
                      item.category ?? "",
                      style: AppStyle.footNoteRomanStyle
                          .copyWith(color: AppColor.textTertiaryColor),
                    ),*/
                      ],
                    ),
                  ],
                ),
                SvgPicture.asset(IconPath.arrowLSide),
              ],
            ),
          ),
        ));

    /* return InkWell(
      onTap: () {
        onPress();
      },
      child: Container(
        // padding: EdgeInsets.only(left: 16,right: 16),
        height: 106,
        width: 109,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Column(
          //the small box column
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 47, height: 47, child: Image.asset(item.icon ?? "")),
            const SizedBox(
              height: 10,
            ),
            Text(
              item.title!,
              style: GoogleFonts.cairo(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: const Color(0xFF37474F)),
            ),
          ],
        ),
      ),
    );*/
  }
}
