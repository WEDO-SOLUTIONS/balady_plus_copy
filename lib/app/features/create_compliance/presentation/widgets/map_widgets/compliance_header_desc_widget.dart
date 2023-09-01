import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class VdHeaderDesc extends StatelessWidget {
  final String header;
  final String? desc;
  final double verticalSpace;

  const VdHeaderDesc(
      {Key? key, required this.header, this.desc, this.verticalSpace = 24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          header,
          fontColor: AppColor.black,
          fontSize: 20.0,
          fontWeight: AppFontWeight.bold,
          textAlign: TextAlign.start,
          maxLines: 2,
          textOverflow: TextOverflow.ellipsis,
        ),
        if (desc != null) ...[
          CustomVerticalSpace(height: 8),
          CustomTextWidget(
            desc ?? "",
            fontColor: AppColor.blackModern500Light,
            fontSize: 14.0,
            fontWeight: AppFontWeight.medium,
            textAlign: TextAlign.start,
          ),
        ],
        CustomVerticalSpace(height: verticalSpace),
      ],
    );
  }
}
