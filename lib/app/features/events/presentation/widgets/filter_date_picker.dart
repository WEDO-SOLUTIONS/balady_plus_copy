import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, CommonFunctions, DateForm, DateTimeExtension;
import '../../../_shared_feature_/presentation/enhanced_widgets/pickers/hijri_picker/hijri_picker.dart' as hijri_picker;
import '../../../_shared_feature_/shared_feature_exports.dart' show CustomTextWidget, DropDownWithTitle;

class EventFilterDatePicker extends StatelessWidget {
  final String title;
  final DateTime? initialDate;
  final DateForm initialDateForm;
  final DateTime? startDate;
  final DateTime? endDate;
  final void Function(DateTime, DateForm) onChange;

  const EventFilterDatePicker({
    super.key,
    required this.title,
    this.initialDate,
    this.initialDateForm = DateForm.hijri,
    this.startDate,
    this.endDate,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        DropDownWithTitle(
          title: title,
          selectedValue: initialDate?.formatTo(initialDateForm),
          showArrow: false,
          onTap: () async {
            if (initialDateForm == DateForm.gregorian) {
              showPickerDate(initialDate, context);
            } else {
              showPickerHijriDate(initialDate, context);
            }
          },
        ),
      ],
    );
  }

  void showPickerHijriDate(DateTime? currentDate, BuildContext context) {
    final minValue = startDate == null ? null : HijriCalendar.fromDate(startDate!);
    final maxValue = endDate == null ? null : HijriCalendar.fromDate(endDate!);
    final date = currentDate == null ? null : HijriCalendar.fromDate(currentDate);

    hijri_picker.Picker(
      isAr: CommonFunctions.isAppAR,
      confirmTextStyle: AppStyle.textButtonStyle.copyWith(color: AppColor.primary900Light),
      headercolor: AppColor.paleGrey,
      cancel: Container(),
      height: 270,
      confirmText: 'choose'.tr(),
      title: CustomTextWidget(title, textStyle: AppStyle.dropDownTitleTextStyle),
      hideHeader: false,
      adapter: hijri_picker.DateTimePickerAdapter(
        minValue: minValue,
        maxValue: maxValue,
        customColumnType: CommonFunctions.isAppAR ? [2, 1, 0] : [0, 1, 2],
        value: date,
      ),
      selectedTextStyle: const TextStyle(color: AppColor.primary900Light),
      onConfirm: (picker, value) {
        final date = (picker.adapter as hijri_picker.DateTimePickerAdapter).value;

        final initialDate = date?.hijriToGregorian(date.hYear, date.hMonth, date.hDay);

        if (initialDate == null) return;
        onChange(initialDate, initialDateForm);
      },
    ).showModal(context);
  }

  void showPickerDate(DateTime? currentDate, BuildContext context) {
    Picker(
      confirmTextStyle: AppStyle.textButtonStyle.copyWith(color: AppColor.primary900Light),
      headerColor: AppColor.paleGrey,
      cancel: Container(),
      height: 270,
      confirmText: 'choose'.tr(),
      title: CustomTextWidget(title, textStyle: AppStyle.dropDownTitleTextStyle),
      hideHeader: false,
      adapter: DateTimePickerAdapter(
        minValue: startDate,
        maxValue: endDate,
        customColumnType: CommonFunctions.isAppAR ? [2, 1, 0] : [0, 1, 2],
        value: initialDate,
      ),
      selectedTextStyle: const TextStyle(color: AppColor.primary900Light),
      onConfirm: (picker, value) {
        final initialDate = (picker.adapter as DateTimePickerAdapter).value;

        if (initialDate == null) return;
        onChange(initialDate, initialDateForm);
      },
    ).showModal(context);
  }
}
