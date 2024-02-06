import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';

class CalendarFilterPopup extends StatefulWidget {
  const CalendarFilterPopup({super.key});

  @override
  State<CalendarFilterPopup> createState() => _CalendarFilterState();
}

class _CalendarFilterState extends State<CalendarFilterPopup> {
  bool municiplaityAppointmentsCheckValue = false;
  bool licenseExpiryCheckValue = false;
  bool healthLicenseCheckValue = false;
  bool billExpiryCheckValue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextWidget(
              'تصفية التقويم',
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
        const Text('عرض'),
        const SizedBox(
          height: 10,
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          fillColor: const MaterialStatePropertyAll(AppColor.primary600Light),
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text('مواعيد البلدية'),
          value: municiplaityAppointmentsCheckValue,
          onChanged: (value) {
            print(value);
            if (value != null) {
              setState(() {
                municiplaityAppointmentsCheckValue = value;
              });
            }
          },
        ),
        const SizedBox(
          height: 15,
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          fillColor: const MaterialStatePropertyAll(AppColor.primary600Light),
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text('انتهاء الرخص'), // Display the title for option 2
          // Display a subtitle for option 2
          value:
              licenseExpiryCheckValue, // Assign a value of 2 to this option// Use _selectedValue to track the selected option
          onChanged: (value) {
            print(value);
            if (value != null) {
              setState(() {
                licenseExpiryCheckValue =
                    value; // Update _selectedValue when option 2 is selected
              });
            }
          },
        ),
        const SizedBox(
          height: 15,
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          fillColor: const MaterialStatePropertyAll(AppColor.primary600Light),
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text(
              'انتهاء الشهادات الصحية'), // Display the title for option 2
          // Display a subtitle for option 2
          value:
              healthLicenseCheckValue, // Assign a value of 2 to this option// Use _selectedValue to track the selected option
          onChanged: (value) {
            print(value);
            if (value != null) {
              setState(() {
                healthLicenseCheckValue =
                    value; // Update _selectedValue when option 2 is selected
              });
            }
          },
        ),
        const SizedBox(
          height: 15,
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          fillColor: const MaterialStatePropertyAll(AppColor.primary600Light),
          controlAffinity: ListTileControlAffinity.leading,
          title:
              const Text('انتهاء الفواتير'), // Display the title for option 2
          // Display a subtitle for option 2
          value:
              billExpiryCheckValue, // Assign a value of 2 to this option// Use _selectedValue to track the selected option
          onChanged: (value) {
            print(value);
            if (value != null) {
              setState(() {
                billExpiryCheckValue =
                    value; // Update _selectedValue when option 2 is selected
              });
            }
          },
        ),
        const SizedBox(
          height: 25,
        ),
        ElevatedButtonWidget.primaryCustom(onPressed: () {}, text: 'تأكيد'),
      ]),
    );
  }
}
