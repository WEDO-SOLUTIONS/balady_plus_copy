import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/presentation/widgets/reject_request_transfer_popup.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/widgets/shared/circle_icon.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/mvvm/commercial_license_attachments_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/additional%D9%80activities_info_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/attachment_show_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/boards_info_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/clean_contract_info_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/conclusion_activity_info_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/license_owner_info_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/location_info_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/salama_details_info_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/shop_info_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/submitter_info_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/presentation/bloc/request_ownership_transfer_details_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/presentation/mvvm/selected_permits_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/presentation/widgets/ownership_transfer_license_info.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/presentation/widgets/selected_commercial_license_permits_widget.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/comliance_request_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class RequestOwnershipTransferDetailsBody extends StatelessWidget {
  final bool isReadonly;
  final CommercialLicenceDetails commercialRequestDetails;

  const RequestOwnershipTransferDetailsBody({
    super.key,
    required this.isReadonly,
    required this.commercialRequestDetails,
  });

  @override
  Widget build(BuildContext context) {
    RequestOwnershipTransferDetailsCubit bloc =
        context.watch<RequestOwnershipTransferDetailsCubit>();
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: MultiProvider(
            providers: [
              // This For Get Attachments of License by licenseId
              ChangeNotifierProvider(
                create: (BuildContext context) {
                  return CommercialLicenseAttachmentsViewModel(
                    webService: sl(),
                    licenseId: commercialRequestDetails.licenseInfo!.licenseId!,
                    accessedRequestId: commercialRequestDetails.requestId,
                  );
                },
              ),
              // This For Get Selected Permits send from sender٫
              ChangeNotifierProvider(
                create: (BuildContext context) {
                  return SelectedPermitsViewModel(
                    webService: sl(),
                    requestId: commercialRequestDetails.requestId!,
                  );
                },
              ),
            ],
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      const DrawIconBasedTypeWidget(
                        icon: IconPath.calendar,
                        iconSize: 24,
                      ),
                      const SizedBox(width: 4),
                      CustomTextWidget(
                        commercialRequestDetails.creationDate
                                ?.toWrittenDate() ??
                            '',
                        textStyle: AppStyle.dateTextStyle,
                      ),
                      const Spacer(),
                      Container(
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColor.primary50Light,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              CustomTextWidget(
                                commercialRequestDetails.statusName,
                                textStyle: AppStyle.tagTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  OwnershipTransferLicenseInfo(
                    licenseInfo: commercialRequestDetails.licenseInfo,
                    crNumber: commercialRequestDetails.currentCrNumber,
                  ),
                  ///////////////  Owner Info
                  LicenseOwnerInfoWidget(
                    currentCrName: commercialRequestDetails.currentCrName,
                    currentCrNumber: commercialRequestDetails.currentCrNumber,
                  ),
                  ///////////////  Submitter Info
                  SubmitterInfoWidget(
                    submitterInfo: commercialRequestDetails.submitterInfo,
                  ),
                  ////////////////    Activity Info
                  ConclusionActivityInfoWidget(
                    activityInfo: commercialRequestDetails.activityInfo,
                    mainActivityArea:
                        commercialRequestDetails.mainActivityArea ?? 0.0,
                  ),
                  /////////////// Boards Info
                  BoardsInfoWidget(
                    boardsInfo: commercialRequestDetails.shopInfo?.boardsInfo,
                  ),
                  //////////////// //////////////// //////////////// ////////////////
                  AdditionalActivitiesInfoWidget(
                    additionalActivities: commercialRequestDetails
                        .activityInfo?.additionalActivities,
                  ),
                  LocationInfoWidget(
                    locationInfo: commercialRequestDetails.locationInfo,
                  ),
                  ShopInfoWidget(
                    shopInfo: commercialRequestDetails.shopInfo,
                  ),

                  CleanContractInfoWidget(
                    cleanContractInfo:
                        commercialRequestDetails.cleanContractInfo,
                  ),

                  const SelectedCommercialLicensePermitsWidget(),
                  SalamaDetailsInfoWidget(
                    salamaDetailsInfo:
                        commercialRequestDetails.salamaDetailsInfo,
                  ),

                  /////////////////////////////////////////////////
                  Selector<CommercialLicenseAttachmentsViewModel,
                      List<AttachmentModel>>(
                    builder: (context, attachments, child) {
                      return ExpandableCard(
                        title: 'data_attachments'.tr(),
                        icon: IconPath.editIcon,
                        children: [
                          attachments.isNotEmpty
                              ? ListView.builder(
                                  itemCount: attachments.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (ctx, index) {
                                    return attachments[index].attachUrl != null
                                        ? AttachmentShowWidget(
                                            fileName:
                                                attachments[index].fileName ??
                                                    '',
                                            name: attachments[index].name ?? '',
                                            filePath:
                                                attachments[index].attachUrl!,
                                          )
                                        : const SizedBox();
                                  },
                                )
                              : Text("no_attachments".tr()),
                        ],
                      );
                    },
                    selector: (_, provider) => provider.attachments,
                  ),
                  /////////////////////////////////////////////////
                  /////////////////////////////////////////////////
                  // commercialRequestDetails.licenseInfo != null &&
                  //         (commercialRequestDetails!.licenseInfo!
                  //                     .qrCodeUrl ??
                  //                 "") !=
                  //             ""
                  //     ? ExpandableCard(
                  //         title: 'quick_code'.tr(),
                  //         icon: IconPath.scannerIcon,
                  //         children: [
                  //           Image.network(
                  //             commercialRequestDetails!.licenseInfo!
                  //                     .qrCodeUrl ??
                  //                 "",
                  //             fit: BoxFit.fill,
                  //             headers: {
                  //               "Authorization":
                  //                   "Bearer ${CommonProperties.token}"
                  //             },
                  //           ),

                  //           const SizedBox(height: 16),
                  //           Row(
                  //             children: [
                  //               const Icon(Icons.info),
                  //               const SizedBox(width: 4),
                  //               Flexible(
                  //                 fit: FlexFit.tight,
                  //                 child: CustomAutoSizeTextWidget(
                  //                   'scan_qr_code_message'.tr(),
                  //                   textStyle:
                  //                       AppStyle.profileSectionTitleTextStyle,
                  //                   maxLines: 3,
                  //                 ),
                  //               ),
                  //             ],
                  //           )
                  //           //
                  //         ],
                  //       )
                  //     : const SizedBox(),
                  /////////////////////////////////////////////////
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ),
        if (isReadonly)
          Container()
        else
          commercialRequestDetails.statusId == 10 ||
                  commercialRequestDetails.statusId == 37
              ? SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.horizontal(
                        start: Radius.circular(15.0),
                        end: Radius.circular(15.0),
                      ),
                    ),
                    margin: EdgeInsets.zero,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        commercialRequestDetails.warnings.partialHeldWarnings ==
                                null
                            ? const SizedBox.shrink()
                            : Row(
                                children: [
                                  SvgPicture.asset(
                                    IconPath.infoCircle,
                                    width: 100,
                                    height: 100,
                                    colorFilter: const ColorFilter.mode(
                                      AppColor.darkRed,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(commercialRequestDetails.warnings.partialHeldWarnings ??
                                      '')
                                ],
                              ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 60,
                          width: double.infinity,
                          child: CustomElevatedButtonWidget(
                            btnColor: AppColor.blueSkyLight800,
                            textStyle: AppStyle.elevatedButtonStyle.copyWith(
                              color: AppColor.blackModern50Light,
                              fontSize: 20,
                            ),
                            text: "respond_to_ownership_transfer".tr(),
                            onPressed: () {
                              CustomPopUpsWidgets.showBottomSheet(
                                context,
                                child: BlocProvider.value(
                                  value: bloc,
                                  child: BlocBuilder<
                                      RequestOwnershipTransferDetailsCubit,
                                      RequestOwnershipTransferDetailsState>(
                                    builder: (blocContext, state) {
                                      if (bloc.state ==
                                          BlocRequestStatus
                                              .submissionUpdateLoading) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }

                                      return Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: CircleIcon(
                                                  icon: Icons.close,
                                                  circleSize: 50,
                                                  iconColor:
                                                      AppColor.primary600Light,
                                                  backgroundColor: AppColor
                                                      .geyser
                                                      .withOpacity(0.4),
                                                  iconSize: 25,
                                                ),
                                              ),
                                            ),
                                            SvgPicture.asset(
                                              IconPath.switchProfileIcon,
                                              width: 100,
                                              height: 100,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                AppColor.blueSkyLight800,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            Text(
                                              'respond_to_ownership_transfer'
                                                  .tr(),
                                              style: const TextStyle(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'respond_to_ownership_transfer_warning'
                                                  .tr(),
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                            Container(
                                              height: 55,
                                              width: double.infinity,
                                              child: CustomElevatedButtonWidget(
                                                btnRadius: 5.0,
                                                btnColor:
                                                    AppColor.blueSkyLight800,
                                                textStyle: AppStyle
                                                    .elevatedButtonStyle
                                                    .copyWith(
                                                  color: AppColor
                                                      .blackModern50Light,
                                                  fontSize: 20,
                                                ),
                                                btnHeight: 40,
                                                text:
                                                    "accept_ownership_transfer"
                                                        .tr(),
                                                onPressed: () {
                                                  /////  Cull the check her
                                                  bloc
                                                      .acceptCommercialRequestTransfer(
                                                          bloc.requestID!)
                                                      .then((value) => {
                                                            if (value ==
                                                                "sucessfull")
                                                              {
                                                                Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                  RouteName
                                                                      .approvalSequenceMainScreen,
                                                                  arguments:
                                                                      bloc,
                                                                )
                                                              }
                                                            else
                                                              {
                                                                // status =  BlocRequestStatus.submissionUpdateFailure
                                                              }
                                                          });
                                                },
                                              ),
                                            ),
                                            Container(
                                              height: 55,
                                              width: double.infinity,
                                              child: CustomElevatedButtonWidget(
                                                btnRadius: 5.0,
                                                btnBorderColor: Colors.red[900],
                                                btnColor: Colors.white,
                                                textStyle: AppStyle
                                                    .elevatedButtonStyle
                                                    .copyWith(
                                                  color: Colors.red[900],
                                                  fontSize: 20,
                                                ),
                                                btnHeight: 40,
                                                text:
                                                    "reject_ownership_transfer"
                                                        .tr(),
                                                onPressed: () {
                                                  /////  Cull the check her
                                                  bloc
                                                      .rejectCommercialRequestTransfer(
                                                          bloc.requestID!)
                                                      .then((value) => {
                                                            if (value == true)
                                                              {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (_) =>
                                                                      const RejectionPopup(),
                                                                )
                                                              }
                                                          });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                height: 600,
                                radius: 30,
                              );
                              // Navigator.of(context).pushNamed(
                              //   CommercialRouteName.approvalSequenceMainScreen,
                              //   arguments: {},
                              // );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink()
      ],
    );
  }
}
