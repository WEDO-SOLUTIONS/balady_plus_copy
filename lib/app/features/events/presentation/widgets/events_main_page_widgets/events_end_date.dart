import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';

class EventsEndDate extends StatelessWidget {
  const EventsEndDate({
    super.key,
    required this.day1,
    required this.day2,
    required this.month1,
    required this.month2,
    required this.year1,
    required this.year2,
  });
  final String day1;
  final String day2;
  final String month1;
  final String month2;
  final String year1;
  final String year2;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                CustomTextWidget(day1, textStyle: AppStyle.eventsStateMonthStyle),
                SizedBox(width: 2),
                CustomTextWidget(month1, textStyle: AppStyle.eventsStateMonthStyle),
                SizedBox(width: 2),
                CustomTextWidget(year1, textStyle: AppStyle.eventsStateMonthStyle),
              ],
            ),
            SizedBox(height: 1),
            Row(
              children: [
                CustomTextWidget(day2, textStyle: AppStyle.eventsStateMonthStyle),
                SizedBox(width: 2),
                CustomTextWidget(month2, textStyle: AppStyle.eventsStateMonthStyle),
                SizedBox(width: 2),
                CustomTextWidget(year2, textStyle: AppStyle.eventsStateMonthStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
