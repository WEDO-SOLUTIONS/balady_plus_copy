/*import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        AppColors,
        Constants,
        CustomElevatedButtonWidget,
        FONT_WEIGHT,
        Helpers,
        LICENSE_MANAGEMENT_STATUS,
        Log;
import 'package:balady_new_app/app/features/license_management/license_management_exports.dart'
    show DeleteOrderConfirmationDialog, HealthRequestDetailsViewModel;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderFooterSectionWidget extends StatefulWidget {
  final LICENSE_MANAGEMENT_STATUS licenseManagementStatus;
  final bool? isValidToSubmit;
  const OrderFooterSectionWidget(
      {Key? key, required this.licenseManagementStatus, this.isValidToSubmit})
      : super(key: key);

  @override
  State<OrderFooterSectionWidget> createState() =>
      _OrderFooterSectionWidgetState();
}

class _OrderFooterSectionWidgetState extends State<OrderFooterSectionWidget> {
  @override
  Widget build(BuildContext context) {
    HealthRequestDetailsViewModel model =
        Provider.of<HealthRequestDetailsViewModel>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.semiMediumPadding,
      ),
      child: Column(
        children: [
          if (widget.isValidToSubmit == true)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: CustomElevatedButtonWidget(
                btnPressed: () {
                  model.submitRequest();
                },
                // as Scaffold background
                btnBorderWidth: 2.0,
                btnText: Helpers.translatingWord("send_request"),
                btnTextWeight: FONT_WEIGHT.medium,
                btnTextColor: AppColor.darkTurquoise,
                btnBorderColor: AppColor.darkTurquoise,
                btnColor: AppColor.white2,
              ),
            ),
          if (widget.licenseManagementStatus == LICENSE_MANAGEMENT_STATUS.DRAFT)
            CustomElevatedButtonWidget(
              btnPressed: () {
                if (widget.licenseManagementStatus ==
                    LICENSE_MANAGEMENT_STATUS.DRAFT) {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) => DeleteOrderConfirmationDialog(
                            onDelete: () {
                              'Delete order'.log();
                              model.deleteHealthRequest();
                            },
                          ));
                } else if (widget.licenseManagementStatus ==
                    LICENSE_MANAGEMENT_STATUS.underProcedure) {
                  'Cancel order'.log();
                }
              },
              btnBorderColor: AppColor.redBrown,
              btnColor: AppColor.white2,
              // as Scaffold background 
              btnBorderWidth: 2.0,
              btnText: _getButtonTextBasedStatus(),
              btnTextColor: AppColor.redBrown,
              btnTextWeight: FONT_WEIGHT.medium,
            ),
        ],
      ),
    );
  }

  String _getButtonTextBasedStatus() {
    if (widget.licenseManagementStatus == LICENSE_MANAGEMENT_STATUS.DRAFT) {
      return Helpers.translatingWord('deleteOrder');
    } else if (widget.licenseManagementStatus ==
        LICENSE_MANAGEMENT_STATUS.underProcedure) {
      return Helpers.translatingWord('cancelOrder');
    }
    return 'Undefined';
  }
}
*/
