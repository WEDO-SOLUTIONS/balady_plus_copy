import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class MapDetailsSubHeader extends StatelessWidget {
  final String entityType;
  final String? entityIcon;
  const MapDetailsSubHeader(
      {super.key, this.entityIcon, required this.entityType});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              "entity_type".tr(),
              fontColor: AppColor.blackModern600Light,
              fontWeight: AppFontWeight.bold,
              fontSize: 13,
            ),
            const CustomVerticalSpace(height: 8),
            Row(
              children: [
                CustomNetworkImageWidget(
                  entityIcon ?? IconPath.buildingIcon,
                  imageWidth: 16,
                  imageHeight: 16,
                  placeHolderWidget: SvgPicture.asset(IconPath.buildingIcon),
                ),
                const CustomHorizontalSpace(width: 8),
                CustomTextWidget(
                  entityType,
                  fontColor: AppColor.blackModern600Light,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 13,
                ),
              ],
            ),
          ],
        ));
  }
}
