import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';
import 'package:intl/intl.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';

class GorgianCalendarDateWidget extends StatelessWidget {
  final String fieldName;
  final int? fieldLength;
  final bool isMandatory;
  final String? currentVlaue;
  final Function(String?) onChanged;
  final DateTime? minValue;
  final DateTime? maxValue;
  final bool isDisabled;

  GorgianCalendarDateWidget(
      {Key? key,
      this.fieldLength,
      required this.fieldName,
      required this.isMandatory,
      this.currentVlaue,
      this.minValue,
      this.maxValue,
      required this.onChanged,
      this.isDisabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeaderAndDescOnTapWidget(
          label: fieldName,
          hintText: Helpers.translatingWord("choose_hint"),
          showOptional: !isMandatory,
          textValue: currentVlaue,
          onTap: () async {
            if (!isDisabled) showPickerDate(currentVlaue, context);
          },
        ),
      ],
    );
  }

  showPickerDate(String? currentDate, BuildContext context) {
    Picker(
        confirmTextStyle: const TextStyle(
          fontFamily: Constants.appFontType,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          color: AppColor.baladyDarkGreen2,
        ),
        headerColor: const Color(0xfffafaf8),
        height: 270,
        confirmText: Helpers.translatingWord('done'),
        hideHeader: false,
        adapter: DateTimePickerAdapter(
            minValue: minValue,
            maxValue: maxValue,
            months: DateTimePickerAdapter.monthsListENL
                .map((e) => Helpers.translatingWord(e))
                .toList(),
            customColumnType: Helpers.getCurrentLanguageCode() == "ar"
                ? [2, 1, 0]
                : [0, 1, 2],
            value: selectedDate(currentDate)),
        selectedTextStyle: const TextStyle(color: AppColor.baladyDarkGreen2),
        onCancel: () {
          //print("Cancell");
        },
        cancelText: Helpers.translatingWord('choose_date'),
        cancelTextStyle: const TextStyle(
          color: AppColor.black,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 15.0,
        ),
        onConfirm: (Picker picker, List value) {
          //print((picker.adapter as GorgianPicker.DateTimePickerAdapter).value);
          var date = (picker.adapter as DateTimePickerAdapter).value;
          print(date);
          final DateFormat formatter = DateFormat('yyyy/MM/dd');
          if (date != null) currentDate = formatter.format(date);
          onChanged(currentDate);
        }).showModal(context);
  }

  DateTime selectedDate(String? currentDate) {
    if (currentDate != null) {
      DateTime? selectedDate = DateFormat('yyyy/MM/dd').parse(currentDate!);
      return selectedDate;
    }
    return DateTime.now();
  }
}
