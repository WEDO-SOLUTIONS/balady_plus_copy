import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
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
    show
        ConfirmCancelLicenseDialog,
        DeleteOrderConfirmationDialog,
        HealthRequestDetailsScreenArgs,
        HealthRequestDetailsViewModel;
import '../widgets/order_body_section_widget.dart';

class HealthRequestDetailsScreen extends StatefulWidget {
  const HealthRequestDetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HealthRequestDetailsScreenState createState() =>
      _HealthRequestDetailsScreenState();
}

class _HealthRequestDetailsScreenState
    extends State<HealthRequestDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    HealthRequestDetailsScreenArgs args = ModalRoute.of(context)!
        .settings
        .arguments as HealthRequestDetailsScreenArgs;

    return ChangeNotifierProvider(
        create: (context) => HealthRequestDetailsViewModel(
            requestDetails: args.healthRequestDetails,
            isPrintable: args.healthRequestDetails?.data?.result?.printable),
        builder: (context, child) {
          HealthRequestDetailsViewModel model =
              Provider.of<HealthRequestDetailsViewModel>(context);

          return Scaffold(
              backgroundColor: AppColor.white2,
              appBar: DetailsHeader(
                title: ("details").tr(),
                onPrint: (args.healthRequestDetails?.data?.result?.printable ??
                        false)
                    ? () {
                        model.printLicense();
                      }
                    : null,
                procedures: (model.requestDetails?.getRequestStatus() ==
                        LICENSE_MANAGEMENT_STATUS.DRAFT)
                    ? () async {
                        await BottomSheetDialog.showDraggableSheet(context,
                            isFullHeight: false,
                            height: 250,
                            child: BottomSheetWithActions(
                              title: "actions".tr(),
                              body: Column(children: [
                                if (model.requestDetails?.getRequestStatus() ==
                                    LICENSE_MANAGEMENT_STATUS.DRAFT)
                                  GestureDetector(
                                    onTap: () async {
                                      await CustomPopUpsWidgets.showBottomSheet(
                                        context,
                                        child: DeleteOrderConfirmationDialog(
                                          onDelete: () {
                                            model.deleteHealthRequest();
                                          },
                                        ),
                                        isFullHeight: false,
                                      );
                                    },
                                    child: FieldData(
                                      title: Helpers.translatingWord(
                                          'deleteOrder'),
                                    ),
                                  ),
                                CustomVerticalSpace(height: 16),
                                if (model.isValidToSubmit() ?? false)
                                  GestureDetector(
                                    onTap: () async {
                                      model.submitRequest();
                                    },
                                    child: FieldData(
                                      title: Helpers.translatingWord(
                                          'send_request'),
                                    ),
                                  ),
                              ]),
                            ));
                      }
                    : null,
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
                                CommonFunctions.getFormattedDate(model
                                    .requestDetails
                                    ?.data
                                    ?.result
                                    ?.requestSubmitDate),
                                fontColor: AppColor.blackModern500Light,
                                fontSize: 12,
                                fontWeight: AppFontWeight.bold,
                              )
                            ],
                          ),
                          HomeTag(
                            title:
                                model.requestDetails?.getRequestStatusName() ??
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

    /*  return ChangeNotifierProvider(
        create: (context) => HealthRequestDetailsViewModel(
            requestDetails: widget.args.healthRequestDetails,
            isDeletable: widget.args.isDeletable),
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
                    LicenseSilverAppBar(
                      title: model.requestDetails?.getrequestTypeName() ?? "",
                      licenseId: model.requestDetails?.getRequestId() ?? "",
                      licenseManagementStatus:
                          model.requestDetails?.getRequestStatus() ??
                              LICENSE_MANAGEMENT_STATUS.DRAFT,
                      licenseStatusName:
                          model.requestDetails?.getRequestStatusName() ?? "",
                      hideShare: true,
                      onShareClicked: () {},
                    ),
                    // body
                    SliverToBoxAdapter(
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Constants.verticalSpaceMedium,
                            OrderBodySectionWidget(
                              isLicense: false,
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
                          // order page
                          if (model.isDeletable == true)
                            OrderFooterSectionWidget(
                              licenseManagementStatus: model.isOrderDeletable(),
                              isValidToSubmit: model.isValidToSubmit(),
                            ),

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
        });*/
  }

  /*LICENSE_MANAGEMENT_STATUS _getLicenseBasedType() {
    return LICENSE_MANAGEMENT_STATUS.awaitPayment;
  }*/
}
