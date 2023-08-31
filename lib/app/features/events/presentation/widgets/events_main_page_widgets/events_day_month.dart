import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EventsDayMonthEvent extends StatelessWidget {
  const EventsDayMonthEvent({
    super.key,
    required this.color,
    required this.monthStyle,
    required this.dayStyle,
  });
  final Color color;
  final TextStyle monthStyle;
  final TextStyle dayStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Container(
        width: 60,
        height: 66,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            CustomTextWidget(
              'DEC'.tr(),
              textStyle: monthStyle,
            ),
            CustomTextWidget(
              '21'.tr(),
              textStyle: dayStyle,
            ),
          ]),
        ),
      ),
    );
  }
}
