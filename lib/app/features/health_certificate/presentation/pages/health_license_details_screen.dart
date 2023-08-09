import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../appointments/presentation/dialogs/confirm_cancel_appointment_dialog.dart';
import '../../../home_page/presentation/widgets/home_tag.dart';
import '../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../../license_management_exports.dart'
    show
        ConfirmCancelLicenseDialog,
        HealthRequestDetailsScreenArgs,
        HealthRequestDetailsViewModel;
import '../widgets/order_body_section_widget.dart';

class HealthLicenseDetailsScreen extends StatefulWidget {
  final HealthRequestDetailsScreenArgs args;

  const HealthLicenseDetailsScreen({Key? key, required this.args})
      : super(key: key);

  @override
  _HealthLicenseDetailsScreenState createState() =>
      _HealthLicenseDetailsScreenState();
}

class _HealthLicenseDetailsScreenState
    extends State<HealthLicenseDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HealthRequestDetailsViewModel(
            requestDetails: widget.args.healthRequestDetails,
            isPrintable:
                widget.args.healthRequestDetails?.data?.result?.printable),
        builder: (context, child) {
          HealthRequestDetailsViewModel model =
              Provider.of<HealthRequestDetailsViewModel>(context);

          return Scaffold(
              backgroundColor: AppColor.white2,
              appBar: DetailsHeader(
                title: ("").tr(),
                onPrint: (widget.args.healthRequestDetails?.data?.result
                            ?.printable ??
                        false)
                    ? () {
                        model.printLicense();
                      }
                    : null,
                procedures: () async {
                  await BottomSheetDialog.showDraggableSheet(context,
                      isFullHeight: false,
                      height: 250,
                      child: BottomSheetWithActions(
                        title: "actions".tr(),
                        body: Column(children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  RouteName.newHealthCertificatePage,
                                  arguments: true);
                            },
                            child: FieldData(
                              title:
                                  Helpers.translatingWord('renewLicenseWord'),
                            ),
                          ),
                          CustomVerticalSpace(height: 16),
                          GestureDetector(
                            onTap: () async {
                              await BottomSheetDialog.showDraggableSheet(
                                  context, child: ConfirmCancelLicenseDialog(
                                onCancel: () {
                                  HealthRequestDetailsViewModel model = Provider
                                      .of<HealthRequestDetailsViewModel>(
                                          context,
                                          listen: false);
                                  int? certicateId = model
                                      .requestDetails
                                      ?.data
                                      ?.result
                                      ?.healthCertificateInfo
                                      ?.certificateId;
                                  if (certicateId != null) {
                                    model.cancelHealthCertificate(certicateId);
                                  }
                                },
                              ));
                            },
                            child: FieldData(
                              title:
                                  Helpers.translatingWord('cancelLicenseWord'),
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
                  child: SingleChildScrollView(
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
                              CustomHorizontalSpace(width: 8),
                              CustomTextWidget(
                                CommonFunctions.getFormattedDate(""),
                                fontColor: AppColor.blackModern500Light,
                                fontSize: 12,
                                fontWeight: AppFontWeight.bold,
                              )
                            ],
                          ),
                          HomeTag(
                            title:
                                model.requestDetails?.getLicenseStatusName() ??
                                    "",
                            backgroundColor: AppColor.secondary100Light,
                          ),
                        ],
                      ),
                      CustomVerticalSpace(height: 16),
                      OrderBodySectionWidget(
                        isLicense: true,
                      ),
                    ],
                  ))));
        });
  }
}


  /*@override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HealthRequestDetailsViewModel(
            requestDetails: widget.args.healthRequestDetails,
            isPrintable: widget.args.isPrintable),
        builder: (context, child) {
          HealthRequestDetailsViewModel model =
              Provider.of<HealthRequestDetailsViewModel>(context);
          return Scaffold( 
            backgroundColor: AppColor.white,
            appBar: null,
            body: Stack(
              children: <Widget>[
                CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: <Widget>[
                    // app bar
                    //MM
                    /* LicenseSilverAppBar(
                      title: model.requestDetails?.getrequestTypeName() ?? "",
                      licenseId: model.requestDetails?.getLicenseId() ?? "",
                      licenseManagementStatus:
                          model.requestDetails?.getLicenseStatus() ??
                              LICENSE_MANAGEMENT_STATUS.DRAFT,
                      licenseStatusName:
                          model.requestDetails?.getLicenseStatusName() ?? "",
                      onShareClicked: () {},
                    ),*/
                    // body
                    SliverToBoxAdapter(
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Constants.verticalSpaceMedium,
                            OrderBodySectionWidget( 
                              isLicense: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          /* LicenseFooterSectionWidget(
                            licenseManagementStatus:
                                model.requestDetails?.getLicenseStatus() ??
                                    LICENSE_MANAGEMENT_STATUS.DRAFT,
                          ),*/ //MM
                          const CustomVerticalSpace(height: 35.0),
                        ],
                      ),
                    ),
                  ],
                ),
                /*    if (model.isLoading) CustomCircularLoadingWidget()*/
              ],
            ),
          );
        });
  }*/

  /* LICENSE_MANAGEMENT_STATUS _getLicenseBasedType() {
    return LICENSE_MANAGEMENT_STATUS.awaitPayment;
  }*/
//}


