/*import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show AppColors, Constants, CustomElevatedButtonWidget, CustomPopUpsWidgets,FONT_WEIGHT, Helpers;
import 'package:flutter/material.dart';

import '../../dialogs/confirm_cancel_license_dialog.dart';

class CancelCertificateFooterWidget extends StatelessWidget {
  final Function? onCancel;
  const CancelCertificateFooterWidget({Key? key, this.onCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(
          horizontal: Constants.semiMediumPadding,
          vertical: MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomElevatedButtonWidget(
              btnPressed: () async => await CustomPopUpsWidgets.showBottomSheet(
                context,
                child: ConfirmCancelLicenseDialog(
                  onCancel: onCancel,
                ),
                isFullHeight: false,
              ),
              btnColor: AppColor.darkTurquoise,
              // as Scaffold background
              btnBorderWidth: 2.0,
              btnText: Helpers.translatingWord(
                'issueCertificateStartServiceButtonWord',
              ),
              btnTextColor: AppColor.white,
              btnTextWeight: FONT_WEIGHT.medium,
            ),
            // CustomVerticalSpace(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
*/
