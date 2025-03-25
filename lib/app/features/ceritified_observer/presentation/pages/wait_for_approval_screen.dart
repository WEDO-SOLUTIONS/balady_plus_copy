import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class WaitForApprovalScreen extends StatelessWidget {
  const WaitForApprovalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InAppWebViewController? _controller;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SvgPicture.asset("assets/icons/svg/sucess.svg"),
                    const CustomVerticalSpace(height: 12),
                    CustomTextWidget(
                      "waitingForApprovalMessage".tr(),
                      fontSize: 16,
                      fontWeight: AppFontWeight.medium,
                      fontColor: AppColor.black500,
                      height: 1.4,
                      maxLines: 4,
                      textAlign: TextAlign.center,
                    ),
                    const CustomVerticalSpace(height: 32),
                  ],
                ),
              ),
            ),
            CustomElevatedButtonWidget(
              btnColor: AppColor.primary800Light,
              textStyle: AppStyle.elevatedButtonStyle.copyWith(
                color: AppColor.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              btnHeight: 56,
              text: "start_training".tr(),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  RouteName.trainingScreen,
                );
              },
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
