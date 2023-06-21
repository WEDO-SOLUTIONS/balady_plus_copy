import 'package:balady_plus/app/core/utils/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextFieldWidget, DrawIconBasedTypeWidget;

class FilterTextField extends StatelessWidget {
  final Debouncer _debouncer = Debouncer(milliseconds: 1000);
  final String? initialValue;
  final String? hintText;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  FilterTextField({
    super.key,
    this.initialValue,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CustomTextFieldWidget(
        hintText: hintText ?? 'search'.tr(),
        suffixIcon: const DrawIconBasedTypeWidget(
          icon: IconPath.search,
          iconColor: AppColor.blackModern600Light,
        ),
        initialValue: initialValue,
        borderRadius: 8,
        borderColor: AppColor.blackModern300Light,
        fillColor: AppColor.scaffoldBackground,
        textFieldStyle: AppStyle.dropDownValueTextStle,
        onChanged: (value) {
          _debouncer.run(() {
            onChanged?.call(value);
          });
        },
        onSubmitted: onSubmitted,
      ),
    );
  }
}
