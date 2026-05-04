import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';

class EventsDayMonthEvent extends StatelessWidget {
  const EventsDayMonthEvent(
      {super.key,
      required this.color,
      required this.monthStyle,
      required this.dayStyle,
      required this.startMonth,
      required this.startDay});
  final Color color;
  final TextStyle monthStyle;
  final TextStyle dayStyle;
  final String startDay;
  final String startMonth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Container(
        width: 60,
        height: 70,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextWidget(
                startMonth,
                textStyle: monthStyle,
              ),
              CustomVerticalSpace(height: 4),
              CustomTextWidget(
                startDay,
                textStyle: dayStyle,
              ),
            ]),
      ),
    );
  }
}
