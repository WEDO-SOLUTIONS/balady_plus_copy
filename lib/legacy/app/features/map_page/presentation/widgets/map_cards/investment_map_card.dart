import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../../../data/model/investment_sites.dart';
import '../../mvvm/map_view_model.dart';

class InvestmentMapCard extends StatelessWidget {
  final InvestmentSites data;
  final Function onClose;

  const InvestmentMapCard(
      {super.key, required this.data, required this.onClose});

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel = context.watch<MapViewModel?>()!;

    return GestureDetector(
      onTap: () {
        //  mapViewModel.getInvestmentDetails(
        //      data.opportunityId ?? "", "Investment");
      },
      child: Container(
        height: 125,
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
            Row(mainAxisSize: MainAxisSize.min, children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    ImagePath.diggingMapCard,
                    width: 60,
                    height: 60,
                  )),
              CustomHorizontalSpace(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextWidget(
                      data.description ?? "",
                      fontColor: AppColor.blackModern800Light,
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                      height: 1.3,
                    ),
                    CustomVerticalSpace(height: 8),
                    CustomTextWidget(
                      data.MUNICIPALITY_ID ?? "",
                      fontColor: AppColor.blackModern500Light,
                      fontSize: 12,
                      fontWeight: AppFontWeight.semiBold,
                      height: 1.3,
                      maxLines: 2,
                    ),
                    CustomVerticalSpace(height: 8),
                    CustomTextWidget(
                      "فرصة استثمارية",
                      fontColor: Color(0xFFF51C1C),
                      fontSize: 12,
                      fontWeight: AppFontWeight.semiBold,
                      height: 1.3,
                      maxLines: 3,
                    ),
                  ],
                ),
              )
            ]),
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
      ),
    );
  }
}
