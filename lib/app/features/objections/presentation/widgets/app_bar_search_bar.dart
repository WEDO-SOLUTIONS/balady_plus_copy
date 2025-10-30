import 'package:balady_plus/app/core/utils/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, IconPath;
import '../../../_shared_feature_/shared_feature_exports.dart';

class AppBarSeachBar extends StatelessWidget implements PreferredSizeWidget {
  final Debouncer _debouncer = Debouncer(milliseconds: 1000);
  final String? hintText;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  AppBarSeachBar({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomTextFieldWidget(
        hintText: hintText ?? 'search'.tr(),
        prefixIcon: const DrawIconBasedTypeWidget(
          icon: IconPath.search,
          iconColor: AppColor.primary700Light,
        ),
        borderRadius: 16,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        borderColor: AppColor.primary900Light16,
        onChanged: (value) {
          _debouncer.run(() {
            onChanged?.call(value);
          });
        },
        onSubmitted: onSubmitted,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(76);
}
