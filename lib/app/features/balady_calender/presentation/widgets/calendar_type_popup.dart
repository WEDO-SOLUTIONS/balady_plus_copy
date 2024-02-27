import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CalendarTypePopup extends StatelessWidget {
  final int isHijri;
  const CalendarTypePopup({super.key, required this.isHijri});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextWidget(
              'calendar_type'.tr(),
              textStyle: AppStyle.sectionTitleStyle,
            ),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: CircleIcon(
                icon: Icons.close,
                iconColor: AppColor.primary600Light,
                backgroundColor: AppColor.geyser.withOpacity(0.5),
                iconSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
              color: AppColor.white, borderRadius: BorderRadius.circular(20.0)),
          child: RadioListTile<int>(
            activeColor: AppColor.primary600Light,
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text(
              'balady_calendar_gregorian'.tr(),
              style: AppStyle.pickerStyle.copyWith(fontWeight: FontWeight.w700),
            ),
            value: 1,
            groupValue: isHijri,
            onChanged: (value) => Navigator.of(context).pop(value),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
              color: AppColor.white, borderRadius: BorderRadius.circular(20.0)),
          child: RadioListTile<int>(
            activeColor: AppColor.primary600Light,
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text(
              'balady_calendar_hijri'.tr(),
              style: AppStyle.pickerStyle.copyWith(fontWeight: FontWeight.w700),
            ), // Display the title for option true
            // Display a subtitle for option 2
            value: 2, // Assign a value of 2 to this option
            groupValue:
                isHijri, // Use _selectedValue to track the selected option
            onChanged: (value) => Navigator.of(context).pop(value),
          ),
        ),
      ]),
    );
  }
}
