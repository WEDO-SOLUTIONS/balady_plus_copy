/*import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';

class RenewCertificateFooterWidget extends StatelessWidget {
  const RenewCertificateFooterWidget({Key? key}) : super(key: key);

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
            EnhancedCustomElevatedButtonWidget(
              btnPressed: () async {
                bool isLocationAllowed =
                    await CommonFunctions.checkLocationSettings(context);
                if (isLocationAllowed) {
                  Navigator.of(context).pushNamed(
                      RoutesNames.certificateInfoStepRoute,
                      arguments: true);
                }
              },
              btnColor: AppColor.primary900Light, // as Scaffold background
              btnBorderWidth: 2.0,
              btnText: Helpers.translatingWord(
                'issueCertificateStartServiceButtonWord',
              ),
              btnTextColor: AppColor.white,
              btnTextWeight: AppFontWeight.medium,
            ),
            // CustomVerticalSpace(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
*/
