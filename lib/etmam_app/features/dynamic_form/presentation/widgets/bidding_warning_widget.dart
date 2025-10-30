import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:flutter/material.dart';

import '../../../../../app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class BidddingWarningWidget extends StatelessWidget {
  const BidddingWarningWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsetsDirectional.only(start: 16, top: 8, bottom: 8, end: 16),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          color: Color(0xFFFFF2EB),
          // borderRadius: BorderRadius.circular(radius),
          border: Border.all(
              color: Color(
                0xFFC74B00,
              ),
              width: 1)),
      child: CustomTextWidget(
        trans("bidding_warning_msg"),
        fontColor: Color(
          0xFFC74B00,
        ),
        fontSize: 13,
        textAlign: TextAlign.start,
        height: 1.6,
        maxLines: 10,
        fontWeight: AppFontWeight.bold,
      ),
    );
  }
}
