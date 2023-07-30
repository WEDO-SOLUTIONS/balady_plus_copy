import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_spaces_widgets.dart';
import 'package:flutter/material.dart';

import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomTextWidget, EtmamProviderLogoIcon, ProviderLogoIcon;

class ProviderNameAndLogoWidget extends StatelessWidget {
  final String name;
  final String logo;

  const ProviderNameAndLogoWidget(
      {Key? key, required this.name, this.logo = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: Color(0x14d1d5db),
                offset: Offset(-2, 4),
                blurRadius: 8,
                spreadRadius: 0)
          ],
          color: AppColor.white),
      child: Row(
        children: [
          EtmamProviderLogoIcon(
            imageUrl: logo,
          ),
          CustomHorizontalSpace(width: 16),
          Expanded(
              child: CustomTextWidget(
            name,
            fontSize: 17,
            fontWeight: AppFontWeight.bold,
            fontColor: AppColor.black,
            textAlign: TextAlign.start,
          ))
        ],
      ),
    );
  }
}
