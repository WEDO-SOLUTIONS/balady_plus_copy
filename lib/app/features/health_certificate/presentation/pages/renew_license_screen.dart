/*import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class RenewLicenseScreen extends StatelessWidget {
  const RenewLicenseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      color: AppColor.white,
      padding: EdgeInsets.symmetric(
        vertical: topPadding,
        horizontal: Constants.mediumPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // icon
          CustomIconButtonWidget(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icons.close,
            // materialIconColor: AppColor.white,
            iconSize: 30.0,
          ),
          // body
          const _RenewLicenseBodyWidget(),
          // buttons
          const _RenewLicenseButtonsWidget(),
        ],
      ),
    );
  }
}

class _RenewLicenseBodyWidget extends StatelessWidget {
  const _RenewLicenseBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const CustomSvgIconWidget(
            Constants.licenseServicesRenewLicenseIcon,
            iconHeight: 60.0,
            iconWidth: 60.0,
          ),
          Constants.verticalSpaceMedium,
          CustomTextWidget(
            Helpers.translatingWord("renewLicenseWord"),
            fontColor: AppColor.black,
            fontSize: 22.0,
          ),
          Constants.verticalSpaceMedium,
          CustomTextWidget(
            Helpers.translatingWord("dummyTextWord"),
            fontColor: AppColor.warmGrey2,
            fontWeight: AppFontWeight.medium,
            height: 1.3,
          ),
          Constants.verticalSpaceMedium,
          const DrawLineWidget(),
          Constants.verticalSpaceMedium,
          const _RenewLicenseBodyUpdateInfo(),
        ],
      ),
    );
  }
}

class _RenewLicenseBodyUpdateInfo extends StatelessWidget {
  const _RenewLicenseBodyUpdateInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            Helpers.translatingWord("renewLicenseUpdateInfoTitleWord"),
            fontColor: AppColor.black,
            fontWeight: AppFontWeight.medium,
            textAlign: TextAlign.start,
          ),
          Constants.verticalSpaceSmall,
          // CustomLabelLineCardWidget(
          //   label: Helpers.translatingWord("renewLicenseInfo1Word"),
          // )
        ],
      ),
    );
  }
}

class _RenewLicenseButtonsWidget extends StatelessWidget {
  const _RenewLicenseButtonsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EnhancedCustomElevatedButtonWidget(
          btnPressed: () => Navigator.of(context)
              .pushNamed(RoutesNames.certificateInfoStepRoute, arguments: true),
          btnColor: AppColor.darkTurquoise, // as Scaffold background
          btnBorderWidth: 2.0,
          btnText: Helpers.translatingWord('startRenewLicenseStepsButtonWord'),
          btnTextColor: AppColor.white,
          btnTextWeight: FONT_WEIGHT.medium,
        ),
        Constants.verticalSpaceSmall,
        CustomTextButtonWidget(
          btnPressed: () => Navigator.of(context).pop(),
          btnText: Helpers.translatingWord("notNowLicenseButtonWord"),
          btnTextColor: AppColor.darkTurquoise,
          btnTextSize: 16.0,
          btnTextWeight: AppFontWeight.medium,
        ),
      ],
    );
  }
}
*/
