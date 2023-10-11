import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show BorderType;
import '../../../shared_feature_exports.dart'
    show
        CustomEnhancedCupertinoDropDownWidget,
        CustomEnhancedMaterialDropDownWidget,
        DropDownItem;

class CustomEnhancedPlatformDropDownWidget extends StatelessWidget {
  final bool isRequired;
  final bool readOnly;
  final DropDownItem? initialValue;
  final List<DropDownItem> items;

  final String? label;
  final TextStyle? labelStyle;
  final String? hintText;
  final TextStyle? hintStyle;

  final Color? fillColor;
  final double borderRadius;
  final Color? borderColor;
  final BorderType? borderType;
  final EdgeInsetsGeometry? padding;

  final String? errorMsg;

  final void Function(DropDownItem?) onSelected;
  final VoidCallback? onDisabledTapped;
  final VoidCallback? onTap;
  const CustomEnhancedPlatformDropDownWidget({
    super.key,
    this.isRequired = true,
    this.readOnly = false,
    this.initialValue,
    required this.items,
    //
    this.label,
    this.labelStyle,
    this.hintText,
    this.hintStyle,
    //
    this.fillColor,
    this.borderRadius = 8.0,
    this.borderColor,
    this.borderType,
    this.padding,
    this.errorMsg,
    required this.onSelected,
    this.onTap,
    this.onDisabledTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? CustomEnhancedMaterialDropDownWidget(
            isRequired: isRequired,
            readOnly: readOnly,
            initialValue: initialValue,
            items: items,
            label: label,
            labelStyle: labelStyle,
            hintText: hintText,
            hintStyle: hintStyle,
            fillColor: fillColor,
            borderRadius: borderRadius,
            borderColor: borderColor,
            borderType: borderType,
            padding: padding,
            errorMsg: errorMsg,
            onSelected: onSelected,
            onTap: onTap,
            onDisabledTapped: onDisabledTapped,
          )
        : Platform.isIOS
            ? CustomEnhancedCupertinoDropDownWidget(
                isRequired: isRequired,
                readOnly: readOnly,
                initialValue: initialValue,
                items: items,
                label: label,
                labelStyle: labelStyle,
                hintText: hintText,
                hintStyle: hintStyle,
                fillColor: fillColor,
                borderRadius: borderRadius,
                borderColor: borderColor,
                borderType: borderType,
                padding: padding,
                errorMsg: errorMsg,
                onSelected: onSelected,
                onTap: onTap,
                onDisabledTapped: onDisabledTapped,
              )
            : const SizedBox();
  }
}
