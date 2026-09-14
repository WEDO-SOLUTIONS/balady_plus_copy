import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../../shared_feature_exports.dart' show CustomElevatedIconButtonWidget, ErrorUnderWidget, WidgetLabel;

class CustomMaterialDatePickerWidget extends StatelessWidget {
  final bool ignoreHolidays;
  final bool isRequired;
  final bool readOnly;

  final DateTime? startDate;
  final DateTime? endDate;

  final String? label;
  final TextStyle? labelStyle;
  final TextStyle? dateStyle;

  final DateTime? initialDate;

  final Color? fillColor;
  final double borderRadius;
  final Color? borderColor;

  final String? errorMsg;

  final void Function(DateTime) onSelected;
  final VoidCallback? onDisabledTapped;
  const CustomMaterialDatePickerWidget({
    super.key,
    this.ignoreHolidays = true,
    this.isRequired = true,
    this.readOnly = false,
    this.startDate,
    this.endDate,
    this.dateStyle,
    this.label,
    this.labelStyle,
    this.initialDate,
    this.fillColor,
    this.borderRadius = 8.0,
    this.borderColor,
    this.errorMsg,
    required this.onSelected,
    this.onDisabledTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label widget
        WidgetLabel(isRequired: isRequired, label: label, labelStyle: labelStyle),
        // Date Picker
        CustomElevatedIconButtonWidget(
          btnHeight: 55.0,
          btnAlignment: MainAxisAlignment.spaceBetween,
          btnPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          btnColor: _fillColor,
          btnBorderColor: _borderColor,
          btnElevation: 0.0,
          text: dateString,
          textStyle: hintStyle,
          icon: const Icon(Icons.calendar_today_outlined, size: 20.0),
          iconAlignment: AlignmentDirectional.centerEnd,
          onPressed: readOnly
              ? onDisabledTapped
              : () async => await onSelectedDate(context, selectedDate: validateDate ?? DateTime.now()),
        ),
        // Error widget
        ErrorUnderWidget(errorText: errorMsg),
      ],
    );
  }

  Color get _fillColor => readOnly ? AppColor.gray : fillColor ?? AppColor.gray.withValues(alpha: 0.3);
  Color get _borderColor => borderColor ?? AppColor.gray.withValues(alpha: 0.60);

  TextStyle get hintStyle => dateStyle ?? AppStyle.pickerStyle;

  String get dateString =>
      initialDate != null ? "${initialDate!.year}/${initialDate!.month}/${initialDate!.day}" : "yyyy-mm-dd";

  DateTime? get validateDate => initialDate?.weekday == 5
      ? initialDate!.add(const Duration(days: 2))
      : initialDate?.weekday == 6
      ? initialDate!.add(const Duration(days: 1))
      : initialDate;

  DateTime get firstDate => startDate ?? DateTime(1996, 1, 1);
  DateTime get lastDate => endDate ?? DateTime(DateTime.now().year + 4, DateTime.now().month + 1, 0);

  Future<void> onSelectedDate(BuildContext context, {required DateTime selectedDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
      selectableDayPredicate: (date) => ignoreHolidays ? date.weekday != 5 && date.weekday != 6 : true,
    );

    if (picked != null && picked != selectedDate) {
      onSelected(picked);
    }
  }
}
