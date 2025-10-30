import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../../core/utils/enums/health_certificate.dart';
import '../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../home_page/presentation/widgets/home_tag.dart';
import '../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../../license_management_exports.dart'
    show DeleteOrderConfirmationDialog, HealthRequestDetailsViewModel;
import '../widgets/order_body_section_widget.dart';

class HealthRequestDetailsScreen extends StatefulWidget {
  const HealthRequestDetailsScreen({Key? key}) : super(key: key);

  @override
  _HealthRequestDetailsScreenState createState() =>
      _HealthRequestDetailsScreenState();
}

class _HealthRequestDetailsScreenState
    extends State<HealthRequestDetailsScreen> {
  late HealthRequestDetailsViewModel provider;

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;

    return ChangeNotifierProvider(
      create: (context) {
        provider = HealthRequestDetailsViewModel(
          requestNumber: data['requestNumber'],
        );

        return provider;
      },
      child: Selector<HealthRequestDetailsViewModel, bool>(
        selector: (context, provider) {
          return provider.isLoading;
        },
        builder: (_, isLoading, __) {
          return Scaffold(
            backgroundColor: AppColor.white2,
            appBar: DetailsHeader(
              title: ("details").tr(),
              onPrint:
                  (provider.requestDetails?.data?.result?.printable ?? false)
                      ? () {
                          provider.checkHealthCertificatePhoto();
                        }
                      : null,
              procedures: (provider.requestDetails?.getRequestStatus() ==
                      LICENSE_MANAGEMENT_STATUS.DRAFT)
                  ? () async {
                      await BottomSheetDialog.showDraggableSheet(
                        context,
                        isFullHeight: false,
                        height: 250,
                        dialogKeyName:
                            DialogName.healthCertificateRequestActionsDialog,
                        currentRouteName: RouteName.healthRequestDetailsScreen,
                        child: BottomSheetWithActions(
                          title: "actions".tr(),
                          body: Column(
                            children: [
                              if (provider.requestDetails?.getRequestStatus() ==
                                  LICENSE_MANAGEMENT_STATUS.DRAFT)
                                GestureDetector(
                                  onTap: () async {
                                    await CustomPopUpsWidgets.showBottomSheet(
                                      context,
                                      child: DeleteOrderConfirmationDialog(
                                        onDelete: () {
                                          provider.deleteHealthRequest();
                                        },
                                      ),
                                      isFullHeight: false,
                                    );
                                  },
                                  child: FieldData(
                                    title:
                                        Helpers.translatingWord('deleteOrder'),
                                  ),
                                ),
                              const CustomVerticalSpace(height: 16),
                              if (provider.isValidToSubmit())
                                GestureDetector(
                                  onTap: () async {
                                    provider.submitRequest();
                                  },
                                  child: FieldData(
                                    title:
                                        Helpers.translatingWord('send_request'),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }
                  : null,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    IconPath.calendarIcon,
                                    width: 24,
                                    height: 24,
                                  ),
                                  const CustomHorizontalSpace(width: 8),
                                  CustomTextWidget(
                                    CommonFunctions.getFormattedDate(
                                      provider.requestDetails?.data?.result
                                          ?.requestSubmitDate,
                                    ),
                                    fontColor: AppColor.blackModern500Light,
                                    fontSize: 12,
                                    fontWeight: AppFontWeight.bold,
                                  )
                                ],
                              ),
                              HomeTag(
                                title: provider.requestDetails
                                        ?.getRequestStatusName() ??
                                    "",
                                backgroundColor: AppColor.secondary100Light,
                              ),
                            ],
                          ),
                          const CustomVerticalSpace(height: 16),
                          const OrderBodySectionWidget(isLicense: true),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
