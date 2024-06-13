import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart' show NearByTypes;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show DrawIconBasedTypeWidget;

class NearbyItem extends StatelessWidget {
  // final NearByTypes type;
  final String title;
  final String subtitle;
  final String icon;

  const NearbyItem({
    super.key,
    // required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColor.primary50Light,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              height: constraints.maxHeight * 0.55,
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: 25,
                  height: 25,
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      title,
                      textStyle: AppStyle.nearbyItemTitleTextStyle,
                    ),
                    const SizedBox(height: 4),
                    CustomTextWidget(
                      '$subtitle  ${'متر'.tr()}',
                      textStyle: AppStyle.nearbyItemSubTitleTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
