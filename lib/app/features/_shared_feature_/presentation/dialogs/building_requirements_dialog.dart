import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart';
import '../../shared_feature_exports.dart';
import 'dialog_header.dart';

class BuildingRequirementsDialog extends StatelessWidget {
  const BuildingRequirementsDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: UIHelper.mediumPadding,
        left: UIHelper.mediumPadding,
        top: UIHelper.smallPadding,
        bottom: context.bottomPadding,
      ),
      child:  SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DrawLineWidget(
              lineWidth: 53,
              lineHeight: 5,
              lineColor: AppColor.white5,
              radius: 46.0,
            ),
            const SizedBox(height: 32),
            DialogHeader(
              title: "buildingRequirements".tr(),
            ),
            const SizedBox(height: 12),
            BuildingRequirementsCard(
              title: "buildingDesignElements".tr(),
              iconPath: IconPath.taskSquare1,
              requirements: [
                "buildingDesignElements1".tr(),
                "buildingDesignElements2".tr(),
                "buildingDesignElements3".tr(),
                "buildingDesignElements4".tr(),
                "buildingDesignElements5".tr(),
                "buildingDesignElements6".tr(),
                "buildingDesignElements7".tr(),
                "buildingDesignElements8".tr(),
              ],
            ),
            const SizedBox(height: 16),
            BuildingRequirementsCard(
              title: "generalSiteElements".tr(),
              iconPath: IconPath.taskSquare2,
              requirements: [
                "generalSiteElements1".tr(),
                "generalSiteElements2".tr(),
                "generalSiteElements3".tr(),
                "generalSiteElements4".tr(),
                "generalSiteElements5".tr(),
                "generalSiteElements6".tr(),
              ],
            ),
            const SizedBox(height: 16),
            BuildingRequirementsCard(
              title: "visualDistortionElements".tr(),
              iconPath: IconPath.taskSquare3,
              requirements: [
                "visualDistortionElements1".tr(),
                "visualDistortionElements2".tr(),
                "visualDistortionElements3".tr(),
                "visualDistortionElements4".tr(),
                "visualDistortionElements5".tr(),
                "visualDistortionElements6".tr(),
                "visualDistortionElements7".tr(),
                "visualDistortionElements8".tr(),
                "visualDistortionElements9".tr(),
                "visualDistortionElements10".tr(),
                "visualDistortionElements11".tr(),
                "visualDistortionElements12".tr(),
                "visualDistortionElements13".tr(),
                "visualDistortionElements14".tr(),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class BuildingRequirementsCard extends StatelessWidget {
  const BuildingRequirementsCard({
    super.key,
    required this.requirements,
    required this.title,
    required this.iconPath,
  });

  final List<String> requirements;
  final String title;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: AppColor.primary50Light.withOpacity(0.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomSvgIconWidget(
                iconPath,
                iconSize: 24,
                iconColor: AppColor.primary700Light,
              ),
              const SizedBox(width: 6),
              CustomTextWidget(
                title,
                fontSize: 15,
                fontWeight: AppFontWeight.bold,
                fontColor: AppColor.blackModern600Light,
              ),
            ],
          ),
          const SizedBox(height: 14),
          ListView.separated(
            itemCount: requirements.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Divider(
                color: AppColor.white5,
              ),
            ),
            itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CustomSvgIconWidget(
                    IconPath.checked,
                    iconSize: 10,
                    iconColor: AppColor.primary700Light,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: CustomTextWidget(
                      requirements[index],
                      fontSize: 12,
                      maxLines: null,
                      height: 1.5,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern600Light,
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