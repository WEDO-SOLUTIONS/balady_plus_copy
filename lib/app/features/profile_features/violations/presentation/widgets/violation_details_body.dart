import 'package:balady_plus/app/core/utils/map_utils.dart';
import 'package:balady_plus/app/features/profile_features/dashboard/dashboard_exports.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, BlocStatus, CommonFunctions, IconPath;
import '../../../../_shared_feature_/balady_features/widgets/UrbiMap/UrbiMapSection.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show
        CustomExpansionPanelWidget,
        CustomHorizontalSpace,
        CustomSvgIconWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        ElevatedButtonWidget,
        MessageDialog,
        ShimmerEffectWidget;
import '../../../../objectable_transactions/presentation/widgets/create_objection_page/objection_attachment_item.dart';
import '../../../../objections/domain/entities/objection_details.dart';
import '../../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../../violations_exports.dart';

class ViolationDetailBody extends StatefulWidget {
  const ViolationDetailBody({super.key});

  @override
  State<ViolationDetailBody> createState() => _ViolationDetailBodyState();
}

class _ViolationDetailBodyState extends State<ViolationDetailBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocConsumer<ViolationDetailsBloc, ViolationDetailsState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (_, state) async {
          if (state.status.isSubmissionFailure) {
            MessageDialog.showErrorNotification(msg: state.errorMessage ?? '');
          }
        },
        builder: (context, state) {
          if (state.status.isSubmissionLoading ||
              state.status.isSubmissionInitial) {
            return ListView.builder(
              itemCount: 3,
              itemBuilder: (_, __) => Container(
                height: 200,
                margin: const EdgeInsets.only(top: 16),
                child: const ShimmerEffectWidget(),
              ),
            );
          } else if (state.details != null) {
            return SingleChildScrollView(
              child: Column(children: [
                // header

                Constants.verticalSpaceSmall,
                if (state.details?.isObjectionAllowed == false)
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: AppColor.orange150,
                          border: Border.all(
                              color: const Color(0xffc74b00), width: 1),
                          borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          const CustomSvgIconWidget(
                              IconPath.informationCircleIcon),
                          const CustomHorizontalSpace(width: 12),
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
                  isExpanded: true,
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
                      subTitle: state.details?.violationStatusName.toString(),
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
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                if (state.details?.lat != null && state.details?.lon != null)
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
                              .read<ViolationDetailsBloc>()
                              .add(const GetGisLocationInfoEvent());
                        }),
                      if (state.gisStatus == BlocStatus.loading)
                        const CustomShimmerWidget(),
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
                          marker:[ Marker(
                            id: "storeLocation",
                            onTap: (){
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
                          currentUserLocation: LatLng(latitude: state.details!.lat!, longitude: state.details!.lon!),
                          incidentLocation: LatLng(latitude: state.details!.lat!, longitude: state.details!.lon!),
                          onCameraIdle: (bool isIdle) {

                          },
                          updateMovedPosition: (LatLng p) {

                          },
                          onMapController: (DgisMapController controller) {

                          },
                          showRadius: true,
                        ),



                        // GoogleMap(
                        //     markers: {Marker(
                        //           visible: MapUtils.locationMarker != null,
                        //           markerId: const MarkerId("storeLocation"),
                        //           icon: MapUtils.locationMarker!,
                        //           onTap: () {
                        //             CommonFunctions.launchMap(LatLng(
                        //                 state.details!.lat!,
                        //                 state.details!.lon!));
                        //           },
                        //           position: LatLng(
                        //               state.details!.lat!, state.details!.lon!))
                        //     },
                        //     onMapCreated:
                        //         (GoogleMapController controller) {
                        //       controller.setMapStyle(
                        //         """[{ "featureType": "water","elementType": "labels.text",  "stylers": [{  "visibility": "off" }                                ]                            }                           ]""",
                        //       );
                        //     },
                        //     myLocationEnabled: false,
                        //     myLocationButtonEnabled: false,
                        //     zoomControlsEnabled: false,
                        //     initialCameraPosition: CameraPosition(
                        //         target: LatLng(
                        //             state.details!.lat!, state.details!.lon!),
                        //         zoom: 13)),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),

                const ViolationClauses(),
                const SizedBox(height: 16),

                (state.details?.objectionRequestNumber != null &&
                        state.details!.objectionRequestNumber!.isNotEmpty)
                    ? const ObjectionsData()
                    : const NoObjectionsData(),
                Constants.verticalSpaceSmall,

                BlocBuilder<ViolationDetailsBloc, ViolationDetailsState>(
                  builder: (context, state) {
                    return state.status == BlocStatus.loading
                        ? const CustomCircularLoadingWidget()
                        : Container();
                  },
                ),
              ]),
            );
          } else if (state.status.isSubmissionFailure) {
            return const Center(child: NoDataWidget());
          }
          return Container();
        },
      ),
    );
  }
}

class ViolationClauses extends StatelessWidget {
  const ViolationClauses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationDetailsBloc, ViolationDetailsState>(
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
                  physics: const NeverScrollableScrollPhysics(),
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
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (ctx, i) {
                                  return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FieldData(
                                          title: "transactionNotice".tr(),
                                          subTitle: state
                                                  .details
                                                  ?.nonComplianceClauses?[index]
                                                  .nonComplianceSubClauses?[i]
                                                  .notes ??
                                              "",
                                        ),
                                        if (state
                                                .details
                                                ?.nonComplianceClauses?[index]
                                                .nonComplianceSubClauses?[i]
                                                .attachments
                                                ?.isNotEmpty ??
                                            false)
                                          MediaQuery.removePadding(
                                            removeTop: true,
                                            removeBottom: true,
                                            context: context,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              itemCount: state
                                                  .details
                                                  ?.nonComplianceClauses![index]
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
                                                                .attachments![j]
                                                                .contentLocation ??
                                                            "",
                                                        fileName: state
                                                                .details
                                                                ?.nonComplianceClauses![
                                                                    index]
                                                                .nonComplianceSubClauses![
                                                                    i]
                                                                .attachments![j]
                                                                .fileName ??
                                                            ""));
                                              },
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
    return BlocBuilder<ViolationDetailsBloc, ViolationDetailsState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
            title: ("objection_title_details").tr(),
            leading: SvgPicture.asset(IconPath.vdSummuryDesc),
            children: [
              GestureDetector(
                onTap: () {
                  /* context.read<ViolationDetailsBloc>().add(
                      GetViolationDetailsEvent(
                          id: state.details?.objectionRequestNumber ?? "",
                          applicationId: state.details.,

                          ));*/
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
  const NoObjectionsData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationDetailsBloc, ViolationDetailsState>(
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
              const CustomVerticalSpace(height: 16),
              if (state.details?.isObjectionAllowed == true)
                ElevatedButtonWidget.applyObjection(onPressed: () {
                  context
                      .read<ViolationDetailsBloc>()
                      .add(const ValidateObjectionDetailsTransactions());
                })
            ]);
      },
    );
  }
}
