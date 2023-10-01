import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class EventHomeCard extends StatelessWidget {
  final String background;
  final String dayName;
  final String month;
  final String day;
  final String eventName;
  final String remainingText;
  final String timer;
  final String btnText;
  const EventHomeCard(
      {super.key,
      required this.background,
      required this.dayName,
      required this.month,
      required this.day,
      required this.eventName,
      required this.remainingText,
      required this.timer,
      required this.btnText});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          background,
          width: 343,
          height: 201,
        ),
        Positioned(
          top: 15,
          left: 18,
          child: CircleAvatar(
            backgroundColor: const Color(0xA5F7FFFD),
            radius: 24,
            child: SvgPicture.asset(IconPath.notification),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 15,
          child: SaudiContainer(
            btnText: btnText,
            remainingText: remainingText,
            timer: timer,
          ),
        ),
        Positioned(
          top: 15,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SaudiDay(
                name: dayName,
                size: 14,
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  SaudiDay(
                    name: month,
                    size: 20,
                  ),
                  SaudiDay(
                    name: '  / ',
                    size: 20,
                  ),
                  SaudiDay(
                    name: day,
                    size: 28,
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              SaudiDay(
                name: eventName,
                size: 20,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class SaudiDay extends StatelessWidget {
  final String name;
  final double size;
  const SaudiDay({super.key, required this.name, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomTextWidget(
      name,
      fontColor: const Color(0xFF145E75),
      fontSize: size,
      fontWeight: AppFontWeight.bold,
    );
  }
}

class SaudiContainer extends StatelessWidget {
  final String remainingText;
  final String timer;
  final String btnText;
  const SaudiContainer(
      {super.key,
      required this.remainingText,
      required this.timer,
      required this.btnText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 315,
      height: 66,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextWidget(
                remainingText,
                fontColor: Color(0xFF145E75),
                fontSize: 11.28,
                fontWeight: AppFontWeight.bold,
              ),
              CustomTextWidget(
                timer,
                fontColor: Color(0xFF145E75),
                fontSize: 26.33,
                fontWeight: AppFontWeight.bold,
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary900Light,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: CustomTextWidget(
              btnText,
              textAlign: TextAlign.center,
              fontColor: Colors.white,
              fontSize: 11.80,
              fontWeight: AppFontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
