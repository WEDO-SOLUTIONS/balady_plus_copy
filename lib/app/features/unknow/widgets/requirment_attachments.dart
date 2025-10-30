import 'package:flutter/material.dart';

import '../../../core/utils/utils_exports.dart';
import '../../_shared_feature_/shared_feature_exports.dart';

class RequirementAttachments extends StatelessWidget {
  const RequirementAttachments({
    super.key,
    required this.attachments,
    required this.title,
  });

  final List<String> attachments;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.only(bottom: 16),
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
            maxLines: 4,
            fontWeight: AppFontWeight.bold,
            fontColor: AppColor.blackModern600Light,
          ),
          const SizedBox(height: 16),
          Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: AppColor.primary50Light50,
            ),
            child: ListView.separated(
              itemCount: attachments.length,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, index) => Row(
                children: [
                  const CustomSvgIconWidget(IconPath.stopCircle),
                  const SizedBox(width: 8),
                  Flexible(
                    child: CustomTextWidget(
                      attachments[index],
                      fontSize: 14,
                      maxLines: 10,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern500Light,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
