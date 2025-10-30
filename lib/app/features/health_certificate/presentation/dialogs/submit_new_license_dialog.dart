/*import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../core/utils/enums/health_certificate.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class SubmitNewLicenseDialog extends StatelessWidget {
  final Function? onCancel;
  final Function? onPrint;

  const SubmitNewLicenseDialog({Key? key, this.onCancel, this.onPrint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.semiMediumPadding,
        vertical: Constants.smallPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header
          const _SubmitNewLicenseHeaderDialog(),
          Constants.verticalSpaceSmall,
          const DrawLineWidget(),
          Constants.verticalSpaceMedium,
          // body
          // const DrawLineWidget(),
          _SubmitNewLicenseBodyDialog(
            onCancel: onCancel,
            onPrint: onPrint,
          ),
        ],
      ),
    );
  }
}

class _SubmitNewLicenseHeaderDialog extends StatelessWidget {
  const _SubmitNewLicenseHeaderDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      final width = constraints.maxWidth;
      return Row(
        children: [
          SizedBox(
            width: 50.0,
            child: CustomTextButtonWidget(
              onPressed: () => Navigator.of(context).pop(),
              text: Helpers.translatingWord("popUpCloseBottomSheetButtonWord"),
              btnTextColor: AppColor.grey1000,
            ),
          ), 
          SizedBox(
            width: width - 100.0,
            child: CustomTextWidget(
              Helpers.translatingWord('submitNewLicenseHeaderWord'),
              fontColor: AppColor.black,
              fontSize: 17.0,
            ),
          ),
          const SizedBox(width: 50.0),
        ],
      );
    });
  }
}

class _SubmitNewLicenseBodyDialog extends StatelessWidget {
  final Function? onCancel;
  final Function? onPrint;
  const _SubmitNewLicenseBodyDialog({Key? key, this.onPrint, this.onCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Constants.verticalSpaceMedium,
        const _SubmitNewLicenseBodyButtonDialog(
          submitLicenseTypes: SUBMIT_LICENSE_TYPES.renewLicense,
        ),
        Constants.verticalSpaceMedium,
        _SubmitNewLicenseBodyButtonDialog(
          submitLicenseTypes: SUBMIT_LICENSE_TYPES.cancelLicense,
          onPress: onCancel,
        ),
        Constants.verticalSpaceMedium,
        _SubmitNewLicenseBodyButtonDialog(
          submitLicenseTypes: SUBMIT_LICENSE_TYPES.printLicense,
          onPress: onPrint,
        ),
      ],
    );
  }
}

class _SubmitNewLicenseBodyButtonDialog extends StatelessWidget {
  final SUBMIT_LICENSE_TYPES submitLicenseTypes;
  final Function? onPress;
  const _SubmitNewLicenseBodyButtonDialog(
      {Key? key, required this.submitLicenseTypes, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextButtonWithIconWidget(
          btnEffectColor: AppColor.white,
          btnPressed: _onPressBasedStatus,
          btnText: _getLabelBasedStatus(),
          btnTextColor: AppColor.black,
          btnTextWeight: AppFontWeight.medium,
          icon: CustomSvgIconWidget(
            _getIconBasedStatus(),
            iconHeight: 24.0,
            iconWidth: 24.0,
          ),
          buttonIconPosition: BUTTON_ICON_POSITION.right,
          spaceBetweenTextAndIcon: 20.0,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        Constants.verticalSpaceMedium,
        const DrawLineWidget(),
      ],
    );
  }

  void _onPressBasedStatus() {
    final context = NavigationService.navigatorKey.currentContext!;
    switch (submitLicenseTypes) {
      case SUBMIT_LICENSE_TYPES.newLicense:
        "Click New License".log();
        break;
      case SUBMIT_LICENSE_TYPES.renewLicense:
        Navigator.of(context)
            .pushNamed(RouteName.renewLicenseRoute, arguments: onPress);
        break;
      case SUBMIT_LICENSE_TYPES.cancelLicense:
        Navigator.of(context)
            .pushNamed(RouteName.cancelLicenseRoute, arguments: onPress);
        break;
      case SUBMIT_LICENSE_TYPES.editLicense:
        "Click Edit License".log();
        break;
      case SUBMIT_LICENSE_TYPES.transferLicense:
        "Click Transfer License".log();
        break;
      case SUBMIT_LICENSE_TYPES.printLicense:
        onPress!();
        break;
    }
  }

  String _getIconBasedStatus() {
    switch (submitLicenseTypes) {
      case SUBMIT_LICENSE_TYPES.newLicense:
        return Constants.licenseServicesNewLicenseIcon;
      case SUBMIT_LICENSE_TYPES.renewLicense:
        return Constants.licenseServicesRenewLicenseIcon;
      case SUBMIT_LICENSE_TYPES.cancelLicense:
        return Constants.licenseServicesCancelLicenseIcon;
      case SUBMIT_LICENSE_TYPES.editLicense:
        return Constants.licenseServicesEditLicenseIcon;
      case SUBMIT_LICENSE_TYPES.transferLicense:
        return Constants.licenseServicesTransferOwnershipLicenseIcon;
      case SUBMIT_LICENSE_TYPES.printLicense:
        return Constants.licenseServicesPtintLicenseIcon;

        break;
    }
  }

  String _getLabelBasedStatus() {
    switch (submitLicenseTypes) {
      case SUBMIT_LICENSE_TYPES.newLicense:
        return Helpers.translatingWord('newLicenseWord');
      case SUBMIT_LICENSE_TYPES.renewLicense:
        return Helpers.translatingWord('renewLicenseWord');
      case SUBMIT_LICENSE_TYPES.cancelLicense:
        return Helpers.translatingWord('cancelLicenseWord');
      case SUBMIT_LICENSE_TYPES.editLicense:
        return Helpers.translatingWord('editLicenseWord');
      case SUBMIT_LICENSE_TYPES.transferLicense:
        return Helpers.translatingWord('transferLicenseWord');
      case SUBMIT_LICENSE_TYPES.printLicense:
        return Helpers.translatingWord('printLicenseWord');
    }
  }
}
*/
