import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';

import '../../../../../app/core/utils/constants/app_colors.dart';
import '../../../../../app/features/_shared_feature_/presentation/dialogs/dialog_header.dart';
import '../../../../../app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../core/utils/constants/app_config.dart';

class OfferCostNotesDialog extends StatelessWidget {
  final String notes;
  const OfferCostNotesDialog({super.key, required this.notes});

  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 30),
        padding:
            const EdgeInsets.only(right: 20, left: 20, top: 26, bottom: 10),
        child: Column(children: [
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
