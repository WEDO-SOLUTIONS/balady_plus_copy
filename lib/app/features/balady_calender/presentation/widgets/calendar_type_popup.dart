import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';

class CalendarTypePopup extends StatelessWidget {

  final bool isHijri;
  const CalendarTypePopup({super.key,required this.isHijri});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextWidget(
              'نوع التقويم',
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
                color: AppColor.white,
                borderRadius: BorderRadius.circular(20.0)),
            child: RadioListTile<bool>(
              activeColor: AppColor.primary600Light,
              controlAffinity: ListTileControlAffinity.trailing,
              title: const Text('ميلادي'),
              value: false,
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
          child: RadioListTile(
            activeColor: AppColor.primary600Light,
            controlAffinity: ListTileControlAffinity.trailing,
            title: const Text('هجري'), // Display the title for option true
            // Display a subtitle for option true
            value: true, // Assign a value of true to this option
            groupValue: isHijri, // Use _selectedValue to track the selected option
            onChanged: (value) => Navigator.of(context).pop(value),
          ),
        ),
      ]),
    );
  }
}
