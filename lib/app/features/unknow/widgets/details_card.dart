import 'package:flutter/material.dart';

import '../../../core/utils/utils_exports.dart';
import '../../_shared_feature_/shared_feature_exports.dart';

class DetailsCard extends StatelessWidget {
  const DetailsCard({
    super.key,
    required this.title,
    required this.value,
    this.note,
  });

  final String title;
  final String value;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColor.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            title,
            fontSize: 15,
            fontWeight: AppFontWeight.bold,
            fontColor: AppColor.blackModern600Light,
          ),
          const SizedBox(height: 8),
          CustomTextWidget(
            value,
            fontSize: 14,
            maxLines: null,
            height: 1.5,
            fontWeight: AppFontWeight.bold,
            fontColor: AppColor.blackModern500Light,
          ),
          if (note != null) const SizedBox(height: 8),
          if (note != null)
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: AppColor.primary50Light50,
              ),
              child: Row(
                children: [
                  const CustomSvgIconWidget(IconPath.infoCircle, iconSize: 20),
                  const SizedBox(width: 8),
                  CustomTextWidget(
                    note!,
                    fontSize: 12,
                    fontWeight: AppFontWeight.bold,
                    fontColor: AppColor.blackModern600Light,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
