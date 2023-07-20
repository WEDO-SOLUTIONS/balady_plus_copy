import 'dart:io' show Platform;
import 'package:flutter/material.dart';

import '../../../shared_feature_exports.dart'
    show CustomCupertinoDatePickerWidget, CustomMaterialDatePickerWidget;

class CustomPlatformDatePickerWidget extends StatelessWidget {
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
  const CustomPlatformDatePickerWidget({
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
    return Platform.isAndroid
        ? CustomMaterialDatePickerWidget(
            ignoreHolidays: ignoreHolidays,
            isRequired: isRequired,
            readOnly: readOnly,
            startDate: startDate,
            endDate: endDate,
            dateStyle: dateStyle,
            label: label,
            labelStyle: labelStyle,
            initialDate: initialDate,
            fillColor: fillColor,
            borderRadius: borderRadius,
            borderColor: borderColor,
            errorMsg: errorMsg,
            onSelected: onSelected,
            onDisabledTapped: onDisabledTapped,
          )
        : Platform.isIOS
            ? CustomCupertinoDatePickerWidget(
                ignoreHolidays: ignoreHolidays,
                isRequired: isRequired,
                readOnly: readOnly,
                startDate: startDate,
                endDate: endDate,
                dateStyle: dateStyle,
                label: label,
                labelStyle: labelStyle,
                initialDate: initialDate,
                fillColor: fillColor,
                borderRadius: borderRadius,
                borderColor: borderColor,
                errorMsg: errorMsg,
                onSelected: onSelected,
                onDisabledTapped: onDisabledTapped,
              )
            : const SizedBox();
  }
}
