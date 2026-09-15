import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/date_form_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, CommonFunctions, DateForm, DateTimeExtension;
import '../../../../_shared_feature_/presentation/enhanced_widgets/pickers/hijri_picker/hijri_picker.dart'
    as hijri_picker;
import '../../../shared_feature_exports.dart' show CustomTextWidget, DropDownWithTitle;

class FilterDatePicker extends StatefulWidget {
  final String title;
  final DateTime? initialDate;
  final DateForm initialDateForm;
  final DateTime? startDate;
  final DateTime? endDate;
  final void Function(DateTime, DateForm) onChange;

  const FilterDatePicker({
    super.key,
    required this.title,
    this.initialDate,
    this.initialDateForm = DateForm.hijri,
    this.startDate,
    this.endDate,
    required this.onChange,
  });

  @override
  State<FilterDatePicker> createState() => _FilterDatePickerState();
}

class _FilterDatePickerState extends State<FilterDatePicker> {
  late DateForm _dateForm;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _dateForm = widget.initialDateForm;
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        CustomTextWidget("date_form".tr(), textStyle: AppStyle.dropDownTitleTextStyle),
        DateFromSelector(
          initialDateForm: _dateForm,
          onChange: (dateForm) {
            setState(() => _dateForm = dateForm);
            if (_selectedDate != null) {
              widget.onChange(_selectedDate!, _dateForm);
            }
          },
        ),
        DropDownWithTitle(
          title: widget.title,
          selectedValue: _selectedDate?.formatTo(_dateForm),
          showArrow: false,
          onTap: () async {
            if (_dateForm == DateForm.gregorian) {
              showPickerDate(_selectedDate, context);
            } else {
              showPickerHijriDate(_selectedDate, context);
            }
          },
        ),
      ],
    );
  }

  void showPickerHijriDate(DateTime? currentDate, BuildContext context) {
    HijriCalendar? minValue;
    try {
      minValue = widget.startDate == null
          ? HijriCalendar.fromDate((DateTime(1937, 3, 14)))
          : HijriCalendar.fromDate(widget.startDate!);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    final maxValue = widget.endDate == null ? null : HijriCalendar.fromDate(widget.endDate!);
    final date = currentDate == null ? null : HijriCalendar.fromDate(currentDate);

    hijri_picker.Picker(
      isAr: CommonFunctions.isAppAR,
      confirmTextStyle: AppStyle.textButtonStyle.copyWith(color: AppColor.primary900Light),
      headercolor: AppColor.paleGrey,
      cancel: Container(),
      height: 270,
      confirmText: 'choose'.tr(),
      title: CustomTextWidget(widget.title, textStyle: AppStyle.dropDownTitleTextStyle),
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

        setState(() {
          _selectedDate = date?.hijriToGregorian(date.hYear, date.hMonth, date.hDay);
        });
        if (_selectedDate == null) return;
        widget.onChange(_selectedDate!, _dateForm);
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
      title: CustomTextWidget(widget.title, textStyle: AppStyle.dropDownTitleTextStyle),
      hideHeader: false,
      adapter: DateTimePickerAdapter(
        minValue: widget.startDate,
        maxValue: widget.endDate,
        customColumnType: CommonFunctions.isAppAR ? [2, 1, 0] : [0, 1, 2],
        value: _selectedDate,
      ),
      selectedTextStyle: const TextStyle(color: AppColor.primary900Light),
      onConfirm: (picker, value) {
        setState(() {
          _selectedDate = (picker.adapter as DateTimePickerAdapter).value;
        });
        if (_selectedDate == null) return;
        widget.onChange(_selectedDate!, _dateForm);
      },
    ).showModal(context);
  }
}
