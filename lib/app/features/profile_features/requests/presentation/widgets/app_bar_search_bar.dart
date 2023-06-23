import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart';

class AppBarSeachBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBarSeachBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomTextFieldWidget(
        hintText: 'search'.tr(),
        prefixIcon: const DrawIconBasedTypeWidget(
          icon: IconPath.search,
          iconColor: AppColor.primary700Light,
        ),
        borderRadius: 16,
        borderColor: AppColor.primary900Light16,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(76);
}
