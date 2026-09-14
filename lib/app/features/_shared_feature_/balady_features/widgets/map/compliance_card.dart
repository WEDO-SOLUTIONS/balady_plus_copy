import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/dialog_names.dart';
import '../shared/circle_icon.dart';

class ComplainceMapCard extends StatelessWidget {
  final String? amana;
  final String? stageNo;
  final String? targetBuildingType;
  final String? streetName;

  final Function onClose;

  const ComplainceMapCard({
    super.key,
    this.amana,
    this.stageNo,
    this.targetBuildingType,
    this.streetName,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width - 30,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadows: const [BoxShadow(color: Color(0x1C77758D), blurRadius: 22, offset: Offset(0, 4), spreadRadius: 0)],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextWidget(
                "address".tr(),
                fontColor: AppColor.blackModern800Light,
                fontSize: 16,
                fontWeight: AppFontWeight.bold,
                maxLines: 1,
              ),
              const CustomVerticalSpace(height: 8),
              CustomTextWidget(
                streetName ?? "",
                fontColor: AppColor.blackModern500Light,
                fontSize: 12,
                fontWeight: AppFontWeight.bold,
                height: 1.3,
                maxLines: 2,
              ),
              const CustomVerticalSpace(height: 8),
              CustomTextWidget(
                amana ?? "",
                fontColor: AppColor.blackModern500Light,
                fontSize: 12,
                fontWeight: AppFontWeight.medium,
                height: 1.3,
                maxLines: 3,
              ),
              const CustomVerticalSpace(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextWidget(
                    "stage_no".tr().replaceAll("{}", stageNo ?? ""),
                    fontColor: AppColor.blackModern600Light,
                    fontSize: 12,
                    fontWeight: AppFontWeight.bold,
                    height: 1.3,
                    maxLines: 3,
                  ),
                  CustomTextWidget(
                    "target_no".tr().replaceAll("{}", targetBuildingType ?? ""),
                    fontColor: AppColor.blackModern600Light,
                    fontSize: 12,
                    fontWeight: AppFontWeight.bold,
                    height: 1.3,
                    maxLines: 3,
                  ),
                ],
              ),
              const CustomVerticalSpace(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButtonWidget.primaryCustom(
                      text: "issue_complaince_certificate".tr(),
                      fontSize: 13,
                      maxLines: 2,
                      height: 40,
                      onPressed: () {
                        CommonFunctions.openCreateCompliance();
                        // Navigator.pushNamed(
                        //     context, RouteName.createCompliancePage);
                      },
                    ),
                  ),
                  const CustomHorizontalSpace(width: 4),
                  Expanded(
                    child: ElevatedButtonWidget.primaryCustomBorder(
                      height: 40,
                      fontSize: 13,
                      maxLines: 2,
                      onPressed: () async {
                        await BottomSheetDialog.showDraggableSheet(
                          context,
                          dialogKeyName: DialogName.buildingComplianceDialog,
                          currentRouteName: "HomePage",
                          child: const BuildingRequirementsDialog(),
                        );
                      },
                      text: "requirements_conditions".tr(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: GestureDetector(
              onTap: () {
                onClose();
              },
              child: CircleIcon(
                icon: Icons.close,
                circleSize: 24,
                iconColor: AppColor.primary600Light,
                backgroundColor: AppColor.geyser.withValues(alpha: 0.4),
                iconSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
