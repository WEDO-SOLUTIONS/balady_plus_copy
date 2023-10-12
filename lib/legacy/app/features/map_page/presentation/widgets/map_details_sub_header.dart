import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class MapDetailsSubHeader extends StatelessWidget {
  final String firstTitle;
  final String? firstIcon;
  final String firstSubTitle;
  final String secondTitle;
  final String? secondIcon;
  final String secondSubTitle;

  const MapDetailsSubHeader(
      {super.key,
      required this.firstTitle,
      required this.firstSubTitle,
      required this.secondTitle,
      required this.secondSubTitle,
      this.firstIcon,
      this.secondIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextWidget(
                  firstTitle,
                  fontColor: AppColor.blackModern600Light,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 13,
                ),
                CustomVerticalSpace(height: 8),
                Row(
                  children: [
                    if (firstIcon != null) ...[
                      SvgPicture.asset(
                        firstIcon!,
                        height: 14,
                        color: Color(0xffBD591D),
                      ),
                      CustomHorizontalSpace(width: 4)
                    ],
                    CustomTextWidget(
                      firstSubTitle,
                      fontColor: AppColor.blackModern600Light,
                      fontWeight: AppFontWeight.bold,
                      fontSize: 13,
                    ),
                  ],
                ),
              ],
            ),
            if (secondTitle.isNotEmpty) ...[
              DrawLineWidget(
                lineWidth: 1,
                lineHeight: 30,
                lineColor: AppColor.blackModern300Light,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextWidget(
                    secondTitle,
                    fontColor: AppColor.blackModern600Light,
                    fontWeight: AppFontWeight.bold,
                    fontSize: 13,
                  ),
                  CustomVerticalSpace(height: 8),
                  Row(
                    children: [
                      if (secondIcon != null) ...[
                        SvgPicture.asset(
                          secondIcon!,
                          height: 14,
                          color: Color(0xffBD591D),
                        ),
                        CustomHorizontalSpace(width: 4)
                      ],
                      CustomTextWidget(
                        secondSubTitle,
                        fontColor: AppColor.blackModern600Light,
                        fontWeight: AppFontWeight.bold,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ],
              ),
            ]
          ],
        ));
  }
}
