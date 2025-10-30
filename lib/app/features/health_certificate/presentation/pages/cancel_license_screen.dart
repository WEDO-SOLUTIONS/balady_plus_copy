import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../dialogs/confirm_cancel_license_dialog.dart';

class CancelLicenseScreen extends StatelessWidget {
  final Function? onCancel;
  const CancelLicenseScreen({Key? key, this.onCancel}) : super(key: key);

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
          const _CancelicenseBodyWidget(),
          // buttons
          _CancelicenseButtonsWidget(
            onCancel: onCancel,
          ),
        ],
      ),
    );
  }
}

class _CancelicenseBodyWidget extends StatelessWidget {
  const _CancelicenseBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const CustomSvgIconWidget(
            Constants.licenseServicesCancelLicenseIcon,
            iconHeight: 60.0,
            iconWidth: 60.0,
          ),
          Constants.verticalSpaceMedium,
          CustomTextWidget(
            Helpers.translatingWord("cancelLicenseWord"),
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
          const _CancelLicenseBodyUpdateInfo(),
        ],
      ),
    );
  }
}

class _CancelLicenseBodyUpdateInfo extends StatelessWidget {
  const _CancelLicenseBodyUpdateInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextButtonWithIconWidget(
            btnEffectColor: AppColor.white,
            btnPressed: null,
            btnText: Helpers.translatingWord("cancelLicenseWarningTitleWord"),
            btnTextColor: AppColor.black,
            btnTextWeight: AppFontWeight.medium,
            icon: const CustomSvgIconWidget(
              Constants.notesPrecautionIcon,
              iconHeight: 24.0,
              iconWidth: 24.0,
            ),
            buttonIconPosition: BUTTON_ICON_POSITION.right,
            spaceBetweenTextAndIcon: 15.0,
            mainAxisAlignment: MainAxisAlignment.start,
          ),
          Constants.verticalSpaceMedium,
          CustomTextWidget(
            Helpers.translatingWord("cancelLicenseWarningValueWord"),
            textAlign: TextAlign.start,
            fontColor: AppColor.warmGrey2,
            fontWeight: AppFontWeight.medium,
          )
        ],
      ),
    );
  }
}

class _CancelicenseButtonsWidget extends StatelessWidget {
  final Function? onCancel;
  const _CancelicenseButtonsWidget({Key? key, this.onCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EnhancedCustomElevatedButtonWidget(
          btnPressed: () async => await CustomPopUpsWidgets.showBottomSheet(
            context,
            child: ConfirmCancelLicenseDialog(
              onCancel: onCancel,
            ),
            isFullHeight: false,
          ),
          btnColor: AppColor.primary900Light, // as Scaffold background
          btnBorderWidth: 2.0,
          btnText: Helpers.translatingWord('cancelLicenseButtonWord'),
          btnTextColor: AppColor.white,
          btnTextWeight: AppFontWeight.medium,
        ),
        Constants.verticalSpaceSmall,
        CustomTextButtonWidget(
          onPressed: () => Navigator.of(context).pop(),
          text: Helpers.translatingWord("notNowLicenseButtonWord"),
          btnTextColor: AppColor.primary900Light,
          btnTextSize: 16.0,
          btnTextWeight: AppFontWeight.medium,
        ),
      ],
    );
  }
}
