import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/extensions/number_text_input_formatter.dart';
import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart' show CustomTextFieldWidget, DrawIconBasedTypeWidget;

class FilterTextField extends StatelessWidget {
  final String? initialValue;
  final String? hintText;
  final TextInputType? textInputType;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextEditingController? textEditingController;

  const FilterTextField({
    super.key,
    this.initialValue,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.textInputType,
    this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CustomTextFieldWidget(
        hintText: hintText ?? 'search'.tr(),
        controller: textEditingController,
        suffixIcon: const DrawIconBasedTypeWidget(icon: IconPath.search, iconColor: AppColor.blackModern600Light),
        initialValue: initialValue,
        borderRadius: 8,
        keyboardType: textInputType ?? TextInputType.number,
        inputFormatters: [
          NumberTextInputFormatter(
            onError: (bool isValid) {
              //  if (!isValid)
              //    CommonFunctions.showError("only_english_numbers".tr());
            },
          ),
        ],
        borderColor: AppColor.blackModern300Light,
        fillColor: AppColor.scaffoldBackground,
        textFieldStyle: AppStyle.dropDownValueTextStyle,
        onChanged: (value) {
          onChanged?.call(value);
        },
        onSubmitted: onSubmitted,
      ),
    );
  }
}
