import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../core/utils/utils_exports.dart' show AppColor;
import '../../shared_feature_exports.dart' show CustomTextFieldWidget;

class SearchField extends StatelessWidget {
  final void Function(String)? onChanged;
  const SearchField({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CustomTextFieldWidget(
      hintText: "searchFor".tr(),
      // allowedInputPattern: Regex.search,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      fillColor: AppColor.white,
      borderColor: AppColor.orange,
      cursorColor: AppColor.orange,
      prefixIcon: const Icon(Icons.search_rounded, color: AppColor.orange),
      onChanged: onChanged,
    );
  }
}
