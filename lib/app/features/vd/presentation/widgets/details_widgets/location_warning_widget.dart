import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class LocationWarningWidget extends StatelessWidget {
  const LocationWarningWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 16, top: 16, bottom: 16),
      alignment: AlignmentDirectional.centerStart,
      decoration: BoxDecoration(
          color: Color(0xFFFFF2EB),
          // borderRadius: BorderRadius.circular(radius),
          border: Border.all(
              color: Color(
                0xFFC74B00,
              ),
              width: 1)),
      child: CustomTextWidget(
        ("vd_check_location_warning").tr(),
        fontColor: Color(
          0xFFC74B00,
        ),
        fontSize: 13,
        maxLines: 3,
        fontWeight: AppFontWeight.bold,
      ),
    );
  }
}
