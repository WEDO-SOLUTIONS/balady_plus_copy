import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../_shared_feature_/presentation/enhanced_widgets/pickers/hijri_picker/hijri_picker.dart'
    as hijri_picker;

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class HijriCalendarDateWidget extends StatelessWidget {
  final String fieldName;
  final int? fieldLength;
  final bool isMandatory;
  final String? currentVlaue;
  final Function(String?) onChanged;
  final HijriCalendar? minValue;
  final HijriCalendar? maxValue;
  final bool isDisabled;

  HijriCalendarDateWidget(
      {Key? key,
      this.fieldLength,
      required this.fieldName,
      required this.isMandatory,
      this.currentVlaue,
      required this.onChanged,
      this.minValue,
      this.isDisabled = false,
      this.maxValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeaderAndDescOnTapWidget(
          label: fieldName,
          hintText: Helpers.translatingWord("choose_hint"),
          textValue: currentVlaue,
          showOptional: !isMandatory,
          onTap: () async {
            if (!isDisabled) showPickerDate(currentVlaue, context);
          },
        ),
      ],
    );
  }

  showPickerDate(String? currentDate, BuildContext context) {
    hijri_picker.Picker(
        isAr: Helpers.isRTL(),
        confirmTextStyle: const TextStyle(
          fontFamily: Constants.appFontType,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          color: AppColor.baladyDarkGreen2,
        ),
        headercolor: const Color(0xfffafaf8),
        cancel: Container(),
        height: 270,
        confirmText: Helpers.translatingWord('done'),
        title: Text(
          Helpers.translatingWord('choose_date'),
          style: const TextStyle(
            color: AppColor.black,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 15.0,
          ),
          textAlign: TextAlign.right,
        ),
        hideHeader: false,
        adapter: hijri_picker.DateTimePickerAdapter(
            minValue: minValue,
            maxValue: maxValue,
            customColumnType: Helpers.isRTL() ? [2, 1, 0] : [0, 1, 2],
            value: selectedDate(currentDate)),
        selectedTextStyle: const TextStyle(color: AppColor.baladyDarkGreen2),
        onConfirm: (hijri_picker.Picker picker, List value) {
          //print((picker.adapter as HijriPicker.DateTimePickerAdapter).value);
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
