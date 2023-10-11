import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/model/building_compliance_certificate.dart';
import '../../../data/model/excavations.dart';
import '../../mvvm/map_view_model.dart';

class ComplianceLegendsMapCard extends StatelessWidget {
  const ComplianceLegendsMapCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MapViewModel mapViewModel =
            Provider.of<MapViewModel>(context, listen: false);
        mapViewModel.showComplianceLegend.value = false;
        mapViewModel.showComplianceLegend.notifyListeners();
      },
      child: Container(
        height: 140,
        width: 200,
        margin: EdgeInsets.only(bottom: 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextWidget(
              "نطاق الإمتثال",
              fontColor: AppColor.blackModern800Light,
              fontSize: 16,
              fontWeight: AppFontWeight.bold,
              maxLines: 1,
            ),
            CustomVerticalSpace(height: 16),
            Row(
              children: [
                Container(
                  width: 23,
                  height: 23,
                  decoration: ShapeDecoration(
                    color: Color(0x33DBE6E8),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.50, color: Color(0xFF4F9291)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                CustomHorizontalSpace(width: 8),
                Flexible(
                  child: CustomTextWidget(
                    'المباني المستهدفة بالامتثال',
                    fontColor: Color(0xFF292929),
                    fontSize: 10,
                    fontWeight: AppFontWeight.medium,
                    maxLines: 2,
                    height: 1.3,
                  ),
                ),
              ],
            ),

            /*   CustomVerticalSpace(height: 12),
            Row(
              children: [
                Container(
                  width: 23,
                  height: 23,
                  decoration: ShapeDecoration(
                    color: Color(0xA5ECEDEE),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.50),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                CustomHorizontalSpace(width: 8),
                Flexible(
                  child: CustomTextWidget(
                    'ارض مستهدف تسويرها في المرحله الحاليه ',
                    fontColor: Color(0xFF292929),
                    fontSize: 10,
                    fontWeight: AppFontWeight.medium,
                    maxLines: 2,
                    height: 1.3,
                  ),
                ),
              ],
            ),
        */
            CustomVerticalSpace(height: 8),
          ],
        ),
      ),
    );
  }
}
