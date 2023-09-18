import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/widgets/request_details/reply_badge_widget.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../app/core/utils/constants/app_colors.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class ReplyItemWidget extends StatelessWidget {
  final String name;
  final int number;
  final bool accepted;
  const ReplyItemWidget(
      {super.key,
      required this.name,
      required this.number,
      this.accepted = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomVerticalSpace(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextWidget(
              name,
              fontColor: AppColor.kGray115,
            ),
            ReplyBadgeWidget(
                text: accepted == true
                    ? trans("offer_aceepted")
                    : trans("reply").replaceAll("{}", number.toString()))
          ],
        ),
        CustomVerticalSpace(height: 16),
        DrawLineWidget(lineColor: AppColor.black.withOpacity(0.1)),
      ],
    );
  }
}
