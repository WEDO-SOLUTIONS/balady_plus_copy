/*import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../license_management_exports.dart'
    show HealthRequestDetailsViewModel, SubmitNewLicenseDialog;

class LicenseFooterSectionWidget extends StatelessWidget {
  final LICENSE_MANAGEMENT_STATUS licenseManagementStatus;
  const LicenseFooterSectionWidget({
    Key? key,
    required this.licenseManagementStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _checkStatus()
        ? Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Constants.semiMediumPadding,
            ),
            child: EnhancedCustomElevatedButtonWidget(
              btnPressed: () async => await CustomPopUpsWidgets.showBottomSheet(
                context,
                child: SubmitNewLicenseDialog( 
                  onCancel: () {
                    HealthRequestDetailsViewModel model =
                        Provider.of<HealthRequestDetailsViewModel>(context,
                            listen: false);
                    int? certicateId = model.requestDetails?.data?.result
                        ?.healthCertificateInfo?.certificateId;
                    if (certicateId != null) {
                      model.cancelHealthCertificate(certicateId);
                    }
                  },
                  onPrint: () {
                    HealthRequestDetailsViewModel model =
                        Provider.of<HealthRequestDetailsViewModel>(context,
                            listen: false);
                    model.printLicense();
                  },
                ),
              ),
              btnColor: AppColor.primary900Light, // as Scaffold background
              btnBorderWidth: 2.0,
              btnText: Helpers.translatingWord('submitNewLicenseButtonWord'),
              btnTextColor: AppColor.white,
              btnTextWeight: AppFontWeight.medium,
            ),
          )
        : const SizedBox();
  }

  bool _checkStatus() => true;
  //licenseManagementStatus == LICENSE_MANAGEMENT_STATUS.valid;
}
*/
