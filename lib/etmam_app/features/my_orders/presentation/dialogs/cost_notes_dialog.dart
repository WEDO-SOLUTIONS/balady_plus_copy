import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';

import '../../../../../app/core/utils/constants/app_colors.dart';
import '../../../../../app/features/_shared_feature_/presentation/dialogs/dialog_header.dart';
import '../../../../../app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../app/features/_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../../../app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../core/utils/constants/app_config.dart';

class OfferCostNotesDialog extends StatelessWidget {
  final String notes;
  const OfferCostNotesDialog({super.key, required this.notes});

  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(children: [
          const DrawLineWidget(
            lineWidth: 70.0,
            lineHeight: 6.0,
            lineColor: Color(0xFFE5E5E5),
            radius: 46.0,
          ),
          // header
          DialogHeader(
            title: trans('cost_details'),
          ),
          const CustomVerticalSpace(height: 20),

          Flexible(
            child: CustomTextWidget(
              notes,
              fontColor: AppColor.kGray153,
              fontWeight: AppFontWeight.medium,
              fontSize: 16,
            ),
          )
        ]));
  }
}
