import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
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
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          children: [
            CustomTextWidget(
              "entity_type".tr(),
              fontColor: AppColor.blackModern600Light,
              fontWeight: AppFontWeight.bold,
              fontSize: 13,
            ),
            Row(
              children: [
                CustomNetworkImageWidget(
                  entityIcon ?? IconPath.buildingIcon,
                  imageWidth: 16,
                  imageHeight: 16,
                ),
                CustomTextWidget(
                  "entity_type",
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
