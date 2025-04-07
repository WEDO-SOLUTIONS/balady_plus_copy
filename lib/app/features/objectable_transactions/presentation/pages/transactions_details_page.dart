import 'package:balady_plus/app/core/utils/routes_type.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../../core/utils/map_utils.dart';
import '../../../_shared_feature_/balady_features/widgets/UrbiMap/UrbiMapSection.dart';
import '../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../objections/domain/entities/objection_details.dart';
import '../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../../domain/entities/create_objection_page_params.dart';

import '../transaction_details_bloc/transaction_details_bloc.dart';
import '../widgets/create_objection_page/objection_attachment_item.dart';

class TransactionsDetailsPage extends StatefulWidget {
  const TransactionsDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TransactionsDetailsPage> createState() =>
      _TransactionsDetailsPageState();
}

class _TransactionsDetailsPageState extends State<TransactionsDetailsPage> {
  @override
  Widget build(BuildContext context) {
    CreateObjectionPageParams params =
        ModalRoute.of(context)!.settings.arguments as CreateObjectionPageParams;

    return BlocProvider(
      create: (context) => TransactionDetailsBloc(
          transactionDetails: params.details, item: params.item),
      child: BlocConsumer<TransactionDetailsBloc, TransactionDetailsState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: AppColor.white2,
                appBar: DetailsHeader(
                  title: ("transaction_details_page").tr(),
                ),
                body: SingleChildScrollView(
                  child: Column(children: [
                    // header

                    Constants.verticalSpaceSmall,
                    if (state.details?.notAllowedToObject == true)
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          margin: EdgeInsets.all(16),
                          decoration: new BoxDecoration(
                              color: AppColor.orange150,
                              border: Border.all(
                                  color: Color(0xffc74b00), width: 1),
                              borderRadius: BorderRadius.circular(4)),
                          child: Row(
                            children: [
                              CustomSvgIconWidget(
                                  IconPath.informationCircleIcon),
                              CustomHorizontalSpace(width: 12),
                              Flexible(
                                child: CustomTextWidget(
                                  "objectionPeriodExpired".tr(),
                                  fontColor: AppColor.orange800,
                                  fontWeight: AppFontWeight.medium,
                                  fontSize: 13,
                                  maxLines: 3,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )),
                    CustomExpansionPanelWidget(
                      title: ("transaction_details_data").tr(),
                      leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                      children: [
                        FieldData(
                          title: ("transaction_details_id").tr(),
                          subTitle: state.details?.violationId,
                        ),
                        const CustomVerticalSpace(height: 8),

                        FieldData(
                          title: ("transaction_details_desc").tr(),
                          subTitle: state.details?.regulationClauseDescription,
                        ),

                        const CustomVerticalSpace(height: 8),
                        FieldData(
                          title: ("transaction_details_date").tr(),
                          subTitle: state.details?.getViolationRegistrationDate,
                        ),

                        const CustomVerticalSpace(height: 8),
                        FieldData(
                          title: ("transaction_details_last_date").tr(),
                          subTitle: state.details?.getLastDateOfObjection,
                        ),

                        const CustomVerticalSpace(height: 8),
                        FieldData(
                          title: ("transaction_details_violation_amount").tr(),
                          subTitle: state.details?.getViolationPenaltyAmount,
                        ),

                        const CustomVerticalSpace(height: 8),
                        FieldData(
                          title: ("transaction_details_violation_status").tr(),
                          subTitle:
                              state.details?.violationStatusName.toString(),
                        ),

                        //
                        const CustomVerticalSpace(height: 8),
                        FieldData(
                          title: ("transaction_details_license").tr(),
                          subTitle: state.details?.licenseNumberOrID,
                        ),

                        if (state.details?.licenseTypeName != null &&
                            state.details!.licenseTypeName!.isNotEmpty) ...[
                          const CustomVerticalSpace(height: 8),
                          FieldData(
                              title: ("transaction_details_license_type").tr(),
                              subTitle: state.details?.licenseTypeName)
                        ],

                        const CustomVerticalSpace(height: 8),
                        FieldData(
                          title: ("transaction_details_municiplaity").tr(),
                          subTitle: state.details?.municipalityName,
                        ),

                        const CustomVerticalSpace(height: 8),
                        FieldData(
                          title: ("transaction_details_submunicipality").tr(),
                          subTitle: state.details?.subMunicipalityName,
                        ),

                        if (state.details?.facilityName != null &&
                            state.details!.facilityName!.isNotEmpty) ...[
                          const CustomVerticalSpace(height: 8),
                          FieldData(
                            title: ("transaction_details_facility").tr(),
                            subTitle: state.details?.facilityName,
                          )
                        ],

                        const CustomVerticalSpace(height: 8),
                        FieldData(
                          title: ("transaction_details_caluse").tr(),
                          subTitle: state.details?.regulationClauseId,
                        ),

                        const CustomVerticalSpace(height: 8),
                        FieldData(
                          title: ("transaction_details_noOfRepetition").tr(),
                          subTitle: state.details?.noOfRepetition.toString(),
                        ),

                        const CustomVerticalSpace(height: 8),
                        FieldData(
                          title: ("transaction_details_noOfUnits").tr(),
                          subTitle: state.details?.noOfUnits.toString(),
                        ),
                      ],
                    ),
                    CustomExpansionPanelWidget(
                      title: ("transaction_details_bill_data").tr(),
                      leading: SvgPicture.asset(IconPath.vdSummuryDesc),
                      children: [
                        FieldData(
                          title: ("transaction_details_bill_number").tr(),
                          subTitle: state.details?.sadadNumber,
                        ),
                        const CustomVerticalSpace(height: 8),
                        FieldData(
                          title: ("transaction_details_bill_total").tr(),
                          subTitle: state.details?.getSadadAmount,
                        ),
                        const CustomVerticalSpace(height: 8),
                        FieldData(
                          title: ("transaction_details_bill_status").tr(),
                          subTitle: state.details?.invoiceStatusName,
                        ),
                      ],
                    ),
                    if (state.details?.lat != null &&
                        state.details?.lon != null)
                      CustomExpansionPanelWidget(
                        title: ("license_location").tr(),
                        leading: SvgPicture.asset(IconPath.vdSummuryPhoto),
                        children: [
                          if (state.gisStatus == BlocStatus.success) ...[
                            if (state.gisLocation?.streetName != null &&
                                state.gisLocation!.streetName!.isNotEmpty)
                              FieldData(
                                title: "street_name".tr(),
                                subTitle: state.gisLocation?.streetName ?? "",
                              ),
                            const CustomVerticalSpace(height: 8),
                            if (state.gisLocation?.districtName != null &&
                                state.gisLocation!.districtName!.isNotEmpty)
                              FieldData(
                                title: "subStreet_name".tr(),
                                subTitle: state.gisLocation?.districtName ?? "",
                              ),
                            const CustomVerticalSpace(height: 8),
                          ],
                          if (state.gisStatus == BlocStatus.retry)
                            ReloadWidget(onTab: () {
                              context
                                  .read<TransactionDetailsBloc>()
                                  .add(GetGisLocationInfoEvent());
                            }),
                          if (state.gisStatus == BlocStatus.loading)
                            CustomShimmerWidget(),
                          Container(
                            width: double.infinity,
                            height: 160,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child:
                            UrbiMapSection(
                              readOnly: true,
                              currentUserLocation: LatLng(latitude: state.details!.lat!, longitude: state.details!.lon!),
                              incidentLocation: LatLng(latitude: state.details!.lat!, longitude: state.details!.lon!),
                              marker: [Marker(
                                id: "storeLocation"
                                ,  onTap: (){
                                CommonFunctions.launchMap(LatLng(latitude:state.details!.lat!, longitude:state.details!.lon!));

                              },
                                options: MarkerOptionsMessage(
                                  position: GeoPointWithElevationMessage(
                                    latitude: state.details!.lat!,
                                    longitude: state.details!.lon!,
                                    elevation: 0,
                                  ),
                                  icon: MarkerIconMessage(
                                    width: 28,
                                    pngPath:  Constants.mapMarkerLocation,
                                  ),
                                ),
                              )],
                              onCameraIdle: (bool isIdle) {

                              },
                              updateMovedPosition: (LatLng p) {

                              },
                              onMapController: (DgisMapController controller) {

                              },
                              showRadius: true,
                            ),



                            // GoogleMap(
                            //     markers: {
                            //       Marker(
                            //           visible: MapUtils.locationMarker != null,
                            //           markerId: const MarkerId("storeLocation"),
                            //           icon: MapUtils.locationMarker!,
                            //           onTap: () {
                            //             CommonFunctions.launchMap(LatLng(
                            //                 state.details!.lat!,
                            //                 state.details!.lon!));
                            //           },
                            //           position: LatLng(state.details!.lat!,
                            //               state.details!.lon!))
                            //     },
                            //     onMapCreated: (GoogleMapController controller) {
                            //       controller.setMapStyle(
                            //         """[{ "featureType": "water","elementType": "labels.text",  "stylers": [{  "visibility": "off" }                                ]                            }                           ]""",
                            //       );
                            //     },
                            //     myLocationEnabled: false,
                            //     myLocationButtonEnabled: false,
                            //     zoomControlsEnabled: false,
                            //     initialCameraPosition: CameraPosition(
                            //         target: LatLng(state.details!.lat!,
                            //             state.details!.lon!),
                            //         zoom: 13)),




                          ),
                        ],
                      ),
                    const ViolationClauses(),
                    (state.details?.objectionRequestNumber != null &&
                            state.details!.objectionRequestNumber!.isNotEmpty)
                        ? const ObjectionsData()
                        : const NoObjectionsData(),
                    Constants.verticalSpaceSmall,

                    BlocBuilder<TransactionDetailsBloc,
                        TransactionDetailsState>(
                      builder: (context, state) {
                        return state.status == BlocStatus.loading
                            ? CustomCircularLoadingWidget()
                            : Container();
                      },
                    ),
                  ]),
                ),
              ),
              if (state.status == BlocStatus.loading)
                CustomCircularLoadingWidget(),
            ],
          );
        },
      ),
    );
  }
}

class ViolationClauses extends StatelessWidget {
  const ViolationClauses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionDetailsBloc, TransactionDetailsState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("transaction_details_clause_data").tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryPledge),
          children: [
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              removeBottom: true,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.details?.nonComplianceClauses?.length ?? 0,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FieldData(
                          title: ("cluase_main_title").tr(),
                          subTitle: state.details?.nonComplianceClauses?[index]
                                  .clauseName ??
                              "",
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 0.0, top: 0),
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            removeBottom: true,
                            child: ListView.builder(
                                itemCount: state
                                        .details
                                        ?.nonComplianceClauses?[index]
                                        .nonComplianceSubClauses
                                        ?.length ??
                                    0,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (ctx, i) {
                                  return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FieldData(
                                          title: "transactionNotice",
                                          subTitle: state
                                                  .details
                                                  ?.nonComplianceClauses?[index]
                                                  .nonComplianceSubClauses?[i]
                                                  .notes ??
                                              "",
                                          /*    subTitleColor:
                                              AppColor.baladyDarkGreen2,
                                          leadingColor: AppColor.black,
                                          textColor: AppColor.black,
                                          titleSubtitleLeadingType:
                                              TITLE_SUBTITLE_LEADING_TYPE.box,*/
                                        ),
                                        if (state
                                                .details
                                                ?.nonComplianceClauses?[index]
                                                .nonComplianceSubClauses?[i]
                                                .attachments
                                                ?.isNotEmpty ??
                                            false)
                                          Container(
                                            child: MediaQuery.removePadding(
                                              removeTop: true,
                                              removeBottom: true,
                                              context: context,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                scrollDirection: Axis.vertical,
                                                itemCount: state
                                                    .details
                                                    ?.nonComplianceClauses![
                                                        index]
                                                    .nonComplianceSubClauses![i]
                                                    .attachments!
                                                    .length,
                                                itemBuilder: (ctx, j) {
                                                  return ObjectionAttachmentItem(
                                                      file: ReasonAttachment(
                                                          contentLocation: state
                                                                  .details
                                                                  ?.nonComplianceClauses![
                                                                      index]
                                                                  .nonComplianceSubClauses![
                                                                      i]
                                                                  .attachments![
                                                                      j]
                                                                  .contentLocation ??
                                                              "",
                                                          fileName: state
                                                                  .details
                                                                  ?.nonComplianceClauses![
                                                                      index]
                                                                  .nonComplianceSubClauses![
                                                                      i]
                                                                  .attachments![
                                                                      j]
                                                                  .fileName ??
                                                              ""));
                                                },
                                              ),
                                            ),
                                          ),

                                        /// images
                                      ]);
                                }),
                          ),
                        ),
                      ],
                    );
                  }),
            )
          ],
        );
      },
    );
  }
}

class ObjectionsData extends StatelessWidget {
  const ObjectionsData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionDetailsBloc, TransactionDetailsState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
            title: ("objection_title_details").tr(),
            leading: SvgPicture.asset(IconPath.vdSummuryDesc),
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    RouteName.objectionsDetailsPage,
                    arguments: {
                      "objectionRequestNumber":
                          state.details?.objectionRequestNumber ?? "",
                    },
                  );
                },
                child: FieldData(
                  title: ("transaction_details_objection_number").tr(),
                  subTitle: state.details?.objectionRequestNumber,
                ),
              ),
              const CustomVerticalSpace(height: 8),
              FieldData(
                title: ("transaction_details_objection_status").tr(),
                subTitle: state.details?.objectionRequestStatusName,
              ),
              const CustomVerticalSpace(height: 8),
              FieldData(
                  title: ("transaction_details_objection_descision").tr(),
                  subTitle: state.details?.objectionCommitteeDecision),
              const CustomVerticalSpace(height: 8),
              FieldData(
                  title: ("transaction_details_objection_date").tr(),
                  subTitle: state.details?.objectionRequestDate)
            ]);
      },
    );
  }
}

//MM
class NoObjectionsData extends StatelessWidget {
  const NoObjectionsData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionDetailsBloc, TransactionDetailsState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
            underline: false,
            title: ("objection_title_details").tr(),
            leading: SvgPicture.asset(IconPath.vdSummuryDesc),
            children: [
              CustomTextWidget(
                ("no_objections").tr(),
                fontColor: AppColor.orange800,
                fontWeight: AppFontWeight.medium,
                fontSize: 13,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
              CustomVerticalSpace(height: 16),
              if (state.details?.isObjectionAllowed == true)
                ElevatedButtonWidget.applyObjection(onPressed: () {
                  context
                      .read<TransactionDetailsBloc>()
                      .add(ValidateObjectionDetailsTransactions());

//Objection Before Validation
                  /*
                  NavigationService.navigatorKey.currentState!.pushNamed(
                      RouteName.createObjectionDetails,
                      arguments: CreateObjectionPageParams(
                          details: state.details, item: state.item));*/
                })
            ]);
      },
    );
  }
}
