import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/constants/dialog_names.dart';
import '../../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../_shared_feature_/presentation/dialogs/building_requirements_dialog.dart';
import '../../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../../../data/model/building_compliance_certificate.dart';
import '../../../data/model/excavations.dart';
import '../../mvvm/map_view_model.dart';

class ImtethalMapCard extends StatelessWidget {
  final BuildingComplianceCertificate data;
  final Function onClose;

  const ImtethalMapCard({super.key, required this.data, required this.onClose});

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel = context.watch<MapViewModel?>()!;

    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width - 30,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x1C77758D),
            blurRadius: 22,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextWidget(
                "العنوان",
                fontColor: AppColor.blackModern800Light,
                fontSize: 16,
                fontWeight: AppFontWeight.bold,
                maxLines: 1,
              ),
              CustomVerticalSpace(height: 8),
              CustomTextWidget(
                data.getStreetName(),
                fontColor: AppColor.blackModern500Light,
                fontSize: 12,
                fontWeight: AppFontWeight.bold,
                height: 1.3,
                maxLines: 2,
              ),
              CustomVerticalSpace(height: 8),
              CustomTextWidget(
                data.AMANANAME ?? "",
                fontColor: AppColor.blackModern500Light,
                fontSize: 12,
                fontWeight: AppFontWeight.medium,
                height: 1.3,
                maxLines: 3,
              ),
              CustomVerticalSpace(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextWidget(
                    "المرحلة: ${data.STAGENO ?? ""}",
                    fontColor: AppColor.blackModern600Light,
                    fontSize: 12,
                    fontWeight: AppFontWeight.bold,
                    height: 1.3,
                    maxLines: 3,
                  ),
                  CustomTextWidget(
                    "المستهدف: ${data.TARGETBUILDINGTYPE ?? ""}",
                    fontColor: AppColor.blackModern600Light,
                    fontSize: 12,
                    fontWeight: AppFontWeight.bold,
                    height: 1.3,
                    maxLines: 3,
                  ),
                ],
              ),
              CustomVerticalSpace(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButtonWidget.primaryCustom(
                        text: "إصدار شهادة الامتثال",
                        fontSize: 13,
                        height: 40,
                        onPressed: () {
                          NavigationService.navigatorKey.currentState!
                              .pushNamed(RouteName.createCompliancePage);
                        }),
                  ),
                  CustomHorizontalSpace(width: 4),
                  Expanded(
                    child: ElevatedButtonWidget.primaryCustomBorder(
                      height: 40,
                      fontSize: 13,
                      onPressed: () async {
                        await BottomSheetDialog.showDraggableSheet(
                          context,
                          dialogKeyName: DialogName.buildingComplianceDialog,
                          currentRouteName: "HomePage",
                          child: BuildingRequirementsDialog(),
                        );
                      },
                      text: "المتطلبات والإشتراطات".tr(),
                    ),
                  ),
                ],
              ),
              /* GestureDetector(
                onTap: () async {
                  await BottomSheetDialog.showDraggableSheet(
                    context,
                    dialogKeyName: DialogName.buildingComplianceDialog,
                    currentRouteName: "HomePage",
                    child: BuildingRequirementsDialog(),
                  );
                },
                child: Container(
                    height: 40,
                    padding: const EdgeInsets.only(left: 7.50, right: 16),
                    decoration: ShapeDecoration(
                      color: Color(0xFFE6EFEF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextWidget(
                          "downloadImtethalDocumwnt".tr(),
                          fontColor: AppColor.primary700Light,
                          fontSize: 12,
                          fontWeight: AppFontWeight.bold,
                          height: 1.3,
                          maxLines: 3,
                        ),
                        RotatedBox(
                            quarterTurns: 1,
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: AppColor.primary700Light,
                            ))
                      ],
                    )),
              )*/
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () {
                onClose();
              },
              child: CircleIcon(
                icon: Icons.close,
                circleSize: 24,
                iconColor: AppColor.primary600Light,
                backgroundColor: AppColor.geyser.withOpacity(0.4),
                iconSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
