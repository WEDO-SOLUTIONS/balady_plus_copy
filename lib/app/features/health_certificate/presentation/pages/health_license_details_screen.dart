import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../home_page/presentation/widgets/home_tag.dart';
import '../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../../license_management_exports.dart'
    show ConfirmCancelLicenseDialog, HealthRequestDetailsViewModel;
import '../widgets/order_body_section_widget.dart';

class HealthLicenseDetailsScreen extends StatefulWidget {
  const HealthLicenseDetailsScreen({Key? key}) : super(key: key);

  @override
  _HealthLicenseDetailsScreenState createState() =>
      _HealthLicenseDetailsScreenState();
}

class _HealthLicenseDetailsScreenState
    extends State<HealthLicenseDetailsScreen> {
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
      }, builder: (_, isLoading, __) {
        return Scaffold(
          backgroundColor: AppColor.white2,
          appBar: DetailsHeader(
            title: (""),
            onPrint: (provider.requestDetails?.data?.result?.printable ?? false)
                ? () {
                    provider.checkHealthCertificatePhoto();
                  }
                : null,
            procedures: () async {
              await BottomSheetDialog.showDraggableSheet(context,
                  isFullHeight: false,
                  height: 250,
                  dialogKeyName: DialogName.healthCertificateActionsDialog,
                  currentRouteName: RouteName.healthLicenseDetailsScreen,
                  child: BottomSheetWithActions(
                    title: "actions".tr(),
                    body: Column(children: [
                      if (provider.requestDetails?.data?.result
                              ?.healthCertificateInfo?.statusId !=
                          3)
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                RouteName.newHealthCertificatePage,
                                arguments: true);
                          },
                          child: FieldData(
                            title: Helpers.translatingWord('renewLicenseWord'),
                          ),
                        ),
                      const CustomVerticalSpace(height: 16),
                      GestureDetector(
                        onTap: () async {
                          await BottomSheetDialog.showDraggableSheet(context,
                              dialogKeyName: DialogName
                                  .healthCertificateCancelActionsDialog,
                              currentRouteName:
                                  RouteName.healthLicenseDetailsScreen,
                              child: ConfirmCancelLicenseDialog(
                            onCancel: () {
                              int? certicateId = provider
                                  .requestDetails
                                  ?.data
                                  ?.result
                                  ?.healthCertificateInfo
                                  ?.certificateId;
                              if (certicateId != null) {
                                provider.cancelHealthCertificate(certicateId);
                              }
                            },
                          ));
                        },
                        child: FieldData(
                          title: Helpers.translatingWord('cancelLicenseWord'),
                        ),
                      ),

                      /* GestureDetector(
                                onTap: () async {
                                  await BottomSheetDialog.showDraggableSheet(
                                    context,
                                    child:
                                        const ConfirmCancelAppointmentDialog(),
                                    isFullHeight: false,
                                  );
                                },
                                child: FieldData(title: Helpers.translatingWord"cancelLicenseWord")),
*/
                    ]),
                  ));
            },
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
                                  CommonFunctions.getFormattedDate(""),
                                  fontColor: AppColor.blackModern500Light,
                                  fontSize: 12,
                                  fontWeight: AppFontWeight.bold,
                                )
                              ],
                            ),
                            HomeTag(
                              title: provider.requestDetails
                                      ?.getLicenseStatusName() ??
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
      }),
    );
  }
}
