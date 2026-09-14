import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';

class EventsStartDateEvent extends StatelessWidget {
  const EventsStartDateEvent({super.key, required this.day1, required this.day2, required this.month});
  final String month;
  final String day1;
  final String day2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: ShapeDecoration(
          color: Colors.white.withValues(alpha: 0.800000011920929),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Center(
          child: Column(
            children: [
              CustomTextWidget(month, textStyle: AppStyle.eventsStateMonthStyle),
              SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextWidget('$day1 - ', textStyle: AppStyle.eventsStateDayStyle),
                  // CustomTextWidget(
                  //   '-',
                  //   textStyle: AppStyle.eventsStateDayStyle,
                  // ),
                  CustomTextWidget(day2, textStyle: AppStyle.eventsStateDayStyle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
