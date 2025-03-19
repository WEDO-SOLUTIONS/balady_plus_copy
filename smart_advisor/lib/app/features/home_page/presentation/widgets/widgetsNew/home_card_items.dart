import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';

class HomeCardItems extends StatelessWidget {
  final String title;
  final String image;
  final bool isDisabled;
  final bool isLast;
  const HomeCardItems(
      {super.key,
      required this.title,
      required this.image,
      required this.isDisabled,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 221,
          width: 159,
          // margin: isLast ? null : const EdgeInsetsDirectional.only(end: 16),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            image: DecorationImage(
              image: AssetImage(image), // Path to your image
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsetsDirectional.only(top: 26, end: 22, start: 16),
            child: Text(
              title,
              style: AppStyle.heading2BoldStyle.copyWith(color: AppColor.white),
            ),
          ),
        ),
        if (isDisabled)
          Container(
              height: 221,
              width: 159,
              // margin: isLast ? null : const EdgeInsetsDirectional.only(end: 16),
              decoration: BoxDecoration(
                color: Color(0xFF1C252E).withOpacity(0.3), // Solid color
                borderRadius: BorderRadius.circular(16.0),
              )),
        if (isDisabled)
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
                width: 58,
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0x57FFFFFF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "قريباً",
                  style: AppStyle.textRegularRomanStyle
                      .copyWith(color: Color(0xff1E2A36), fontSize: 13),
                )),
          )
      ],
    );
  }
}
