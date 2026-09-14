import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocConsumer, BlocProvider, ReadContext;

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../../shared_feature_exports.dart'
    show CustomElevatedIconButtonWidget, DatePickerCubit, DatePickerState, ErrorUnderWidget, WidgetLabel;

class CustomEnhancedMaterialDatePickerWidget extends StatelessWidget {
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
  const CustomEnhancedMaterialDatePickerWidget({
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
    return BlocProvider<DatePickerCubit>(
      create: (_) => DatePickerCubit(initialDate: initialDate),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label widget
          WidgetLabel(isRequired: isRequired, label: label, labelStyle: labelStyle),
          // Date Picker
          Builder(
            builder: (context) {
              return BlocConsumer<DatePickerCubit, DatePickerState>(
                listener: (_, state) => onSelected(state.selectedDate),
                builder: (_, state) {
                  return CustomElevatedIconButtonWidget(
                    btnHeight: 55.0,
                    btnAlignment: MainAxisAlignment.spaceBetween,
                    btnPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    btnColor: _fillColor,
                    btnBorderColor: _borderColor,
                    btnElevation: 0.0,
                    text: state.selectedDateString,
                    textStyle: hintStyle,
                    icon: const Icon(Icons.calendar_today_outlined, size: 20.0),
                    iconAlignment: AlignmentDirectional.centerEnd,
                    onPressed: readOnly
                        ? onDisabledTapped
                        : () async => await onSelectedDate(context, selectedDate: state.selectedDate),
                  );
                },
              );
            },
          ),
          // Error widget
          ErrorUnderWidget(errorText: errorMsg),
        ],
      ),
    );
  }

  Color get _fillColor => readOnly ? AppColor.gray : fillColor ?? AppColor.gray.withValues(alpha: 0.3);
  Color get _borderColor => borderColor ?? AppColor.gray.withValues(alpha: 0.60);

  TextStyle get hintStyle => dateStyle ?? AppStyle.pickerStyle;

  DateTime get firstDate => startDate ?? DateTime(1996, 1, 1);
  DateTime get lastDate => endDate ?? DateTime(DateTime.now().year + 4, DateTime.now().month + 1, 0);

  Future<void> onSelectedDate(BuildContext context, {required DateTime selectedDate, bool mounted = true}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
      selectableDayPredicate: (date) => ignoreHolidays ? date.weekday != 5 && date.weekday != 6 : true,
    );

    if (picked != null && picked != selectedDate) {
      if (!mounted) return;
      context.read<DatePickerCubit>().onUpdatedDate(picked);
    }
  }
}
