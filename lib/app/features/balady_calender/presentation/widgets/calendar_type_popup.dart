import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';

class CalendarTypePopup extends StatefulWidget {
  const CalendarTypePopup({super.key});

  @override
  State<CalendarTypePopup> createState() => _CalendarTypePopupState();
}

class _CalendarTypePopupState extends State<CalendarTypePopup> {
  int _selectedValue = 1;

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
            child: RadioListTile<int>(
              activeColor: AppColor.primary600Light,
              controlAffinity: ListTileControlAffinity.trailing,
              title: const Text('ميلادي'),
              value: 1,
              groupValue: _selectedValue,
              onChanged: (value) {
                print(value);
                if (value != null) {
                  setState(() {
                    _selectedValue = value;
                  });
                }
              },
            )),
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
            title: const Text('هجري'), // Display the title for option 2
            // Display a subtitle for option 2
            value: 2, // Assign a value of 2 to this option
            groupValue:
                _selectedValue, // Use _selectedValue to track the selected option
            onChanged: (value) {
              print(value);
              if (value != null) {
                setState(() {
                  _selectedValue =
                      value; // Update _selectedValue when option 2 is selected
                });
              }
            },
          ),
        ),
      ]),
    );
  }
}
