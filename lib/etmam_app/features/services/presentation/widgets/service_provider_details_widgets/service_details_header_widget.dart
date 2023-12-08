import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/enums/app_font_weight.dart';
import '../../../../_shared_feature_/shared/shared_feature_exports.dart';

class ProviderDetailsHeader extends StatelessWidget {
  final String? providerName;
  final String? providerAdress;

  const ProviderDetailsHeader(
      {Key? key, required this.providerAdress, required this.providerName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      contentPadding: EdgeInsets.zero,
      title: CustomTextWidget(
        providerName ?? "",
        fontSize: 16,
        fontWeight: AppFontWeight.bold,
        fontColor: AppColor.blackModern800Light,
      ),
      subtitle: CustomTextWidget(
        providerAdress ?? "",
        height: 2,
        fontWeight: AppFontWeight.bold,
        fontColor: AppColor.blackModern500Light,
        fontSize: 14,
      ),
    );
  }
}
