import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';

class SectionContainer extends StatelessWidget {
  final String name;
  final String date;
  final String day;
  final String month;
  final Color color1;
  final Color color2;
  final String timer;
  final String? imageBackground;
  const SectionContainer(
      {super.key,
      required this.name,
      required this.date,
      required this.day,
      required this.color1,
      required this.color2,
      required this.month,
      required this.timer,
      this.imageBackground});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      height: 95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        image: imageBackground != null
            ? DecorationImage(
                image: AssetImage(imageBackground!),
              )
            : null,
        boxShadow: const [
          BoxShadow(
            color: Color(0x4CE9EAF1),
            blurRadius: 40,
            offset: Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  CustomTextWidget(
                    name,
                    fontSize: 14,
                    fontColor: Color(0xFF3F3F46),
                    fontWeight: AppFontWeight.bold,
                  ),
                ], //ImagePathCalendar.flag
              ),
              CustomVerticalSpace(height: 8),
              CustomTextWidget(
                date,
                fontSize: 12,
                fontColor: Color(0x6B111111),
                fontWeight: AppFontWeight.bold,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: const Alignment(0.76, 0.64),
                end: const Alignment(-0.76, -0.64),
                colors: [color1, color2],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomTextWidget(
                      day,
                      fontSize: 16,
                      fontColor: AppColor.white,
                      fontWeight: AppFontWeight.bold,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    CustomTextWidget(
                      month,
                      fontSize: 12,
                      fontColor: AppColor.white,
                      fontWeight: AppFontWeight.bold,
                    ),
                  ],
                ),
                CustomTextWidget(
                  timer,
                  fontWeight: AppFontWeight.bold,
                  fontColor: AppColor.white,
                  fontSize: 10.3,
                ),
                /*  const Row(
                  children: [
                    StyleText(
                      text: '23 ',
                      size: 10.35,
                    ),
                    StyleText(
                      text: 'يوم ',
                      size: 8.87,
                    ),
                    StyleText(
                      text: ':',
                      size: 11.83,
                    ),
                    StyleText(
                      text: '21',
                      size: 10.35,
                    ),
                    StyleText(
                      text: 'س ',
                      size: 8.87,
                    ),
                    StyleText(
                      text: ':',
                      size: 11.83,
                    ),
                    StyleText(
                      text: '19 ',
                      size: 10.35,
                    ),
                    StyleText(
                      text: 'د',
                      size: 8.87,
                    ),
                  ],
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}
