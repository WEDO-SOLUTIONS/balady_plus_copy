import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class DeleteOrderConfirmationDialog extends StatelessWidget {
  Function onDelete;

  DeleteOrderConfirmationDialog({Key? key, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Constants.verticalSpaceMedium,
                CustomTextWidget(
                  Helpers.translatingWord("deleteOrder"),
                  fontColor: AppColor.black,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 22,
                ),
                Constants.verticalSpaceMedium,
                CustomTextWidget(
                  Helpers.translatingWord("delete_order_desc"),
                  fontColor: AppColor.black500,
                  fontWeight: AppFontWeight.medium,
                  fontSize: 16,
                  height: 1.3,
                ),
                Constants.verticalSpaceMedium,
                EnhancedCustomElevatedButtonWidget(
                  btnPressed: () => onDelete(),
                  btnText: Helpers.translatingWord("yes_delete"),
                  btnTextSize: 16,
                  btnHeight: 56,
                  btnWidth: 240,
                  btnBorderColor: AppColor.redBrown,
                  btnColor: AppColor.white2,
                  btnTextColor: AppColor.redBrown,
                  btnTextWeight: AppFontWeight.medium,
                ),
                Constants.verticalSpaceSmall,
                CustomTextButtonWidget(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  text: Helpers.translatingWord("no_delete"),
                  btnTextSize: 16,
                  btnTextWeight: AppFontWeight.medium,
                ),
              ],
            )),
      ],
    );
  }
}
