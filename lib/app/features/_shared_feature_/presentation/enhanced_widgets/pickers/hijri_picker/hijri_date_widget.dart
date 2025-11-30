import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../widgets/buttons/custom_buttons_widgets.dart';
import '../../../widgets/widget_label.dart';
import 'hijri_picker.dart' as hijri_picker;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class HijriCalendarDateWidget extends StatelessWidget {
  final String fieldName;
  final int? fieldLength;
  final bool isMandatory;
  final String? currentVlaue;
  final Function(String?) onChanged;
  final HijriCalendar? minValue;
  final HijriCalendar? maxValue;

  HijriCalendarDateWidget(
      {Key? key,
      this.fieldLength,
      required this.fieldName,
      required this.isMandatory,
      this.currentVlaue,
      required this.onChanged,
      this.minValue,
      this.maxValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label widget
        WidgetLabel(
          isRequired: isMandatory,
          label: fieldName,
        ),
        CustomElevatedIconButtonWidget(
          btnHeight: 55.0,
          btnAlignment: MainAxisAlignment.spaceBetween,
          btnPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          btnElevation: 0.0,
          text: currentVlaue,
          icon: const Icon(Icons.calendar_today_outlined, size: 20.0),
          iconAlignment: AlignmentDirectional.centerEnd,
          onPressed: () => showPickerDate(currentVlaue, context),
        ),
      ],
    );
  }

  showPickerDate(String? currentDate, BuildContext context) {
    hijri_picker.Picker(
        isAr: CommonFunctions.isAppAR,
        confirmTextStyle: const TextStyle(
          //fontFamily: Constants.appFontType,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          color: AppColor.primary900Light,
        ),
        headercolor: const Color(0xfffafaf8),
        cancel: Container(),
        height: 270,
        confirmText: ('done').tr(),
        title: Text(
          ('choose_date').tr(),
          style: const TextStyle(
            color: AppColor.black,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 14.0,
          ),
          textAlign: TextAlign.right,
        ),
        hideHeader: false,
        adapter: hijri_picker.DateTimePickerAdapter(
            minValue: minValue,
            maxValue: maxValue,
            customColumnType: CommonFunctions.isAppAR ? [2, 1, 0] : [0, 1, 2],
            value: selectedDate(currentDate)),
        selectedTextStyle: const TextStyle(color: AppColor.primary900Light),
        onConfirm: (hijri_picker.Picker picker, List value) {
          var date =
              (picker.adapter as hijri_picker.DateTimePickerAdapter).value;

          currentDate = date!.toFormat("yyyy/mm/dd");

          onChanged(currentDate);
        }).showModal(context);
  }

  HijriCalendar selectedDate(String? currentDate) {
    try {
      var hijriCalender = HijriCalendar();
      if (currentDate != null && currentDate.isNotEmpty) {
        List<String> dates = currentDate.split("/");
        if (dates.length == 3) {
          hijriCalender.hYear = int.parse(dates[0]);
          hijriCalender.hMonth = int.parse(dates[1]);
          hijriCalender.hDay = int.parse(dates[2]);
        }

        return hijriCalender;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return HijriCalendar.now();
    }
    return HijriCalendar.now();
  }
}
