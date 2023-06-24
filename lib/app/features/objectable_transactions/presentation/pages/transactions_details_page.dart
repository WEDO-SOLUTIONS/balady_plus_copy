import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../../core/utils/map_utils.dart';
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
  final CreateObjectionPageParams params;
  const TransactionsDetailsPage({Key? key, required this.params})
      : super(key: key);

  @override
  State<TransactionsDetailsPage> createState() =>
      _TransactionsDetailsPageState();
}

class _TransactionsDetailsPageState extends State<TransactionsDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionDetailsBloc(
          getObjectionDetails: sl(),
          getTransactionDetails: sl(),
          transactionDetails: widget.params.details),
      child: BlocBuilder<TransactionDetailsBloc, TransactionDetailsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColor.white2,
            body: Stack(
              children: [
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // header
                    DetailsHeader(
                      title: ("transaction_details_page").tr(),
                    ),
                    // body
                    SliverList(
                      delegate: SliverChildListDelegate.fixed(
                        [
                          Constants.verticalSpaceSmall,
                          if (widget.params.details?.notAllowedToObject == true)
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
                                    CustomTextWidget(
                                      "لا يمكن الاعتراض بسبب انتهاء مدة الاعتراض",
                                      fontColor: AppColor.orange800,
                                      fontWeight: AppFontWeight.medium,
                                      fontSize: 13,
                                      maxLines: 1,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )),
                          CustomExpansionPanelWidget(
                            title: ("transaction_details_data").tr(),
                            leading:
                                SvgPicture.asset(IconPath.vdSummuryUserInfo),
                            children: [
                              FieldData(
                                title: ("transaction_details_id").tr(),
                                subTitle: state.details?.violationId,
                              ),
                              const CustomVerticalSpace(height: 8),

                              FieldData(
                                title: ("transaction_details_desc").tr(),
                                subTitle:
                                    state.details?.regulationClauseDescription,
                              ),

                              const CustomVerticalSpace(height: 8),
                              FieldData(
                                title: ("transaction_details_date").tr(),
                                subTitle:
                                    state.details?.getViolationRegistrationDate,
                              ),

                              const CustomVerticalSpace(height: 8),
                              FieldData(
                                title: ("transaction_details_last_date").tr(),
                                subTitle: state.details?.getLastDateOfObjection,
                              ),

                              const CustomVerticalSpace(height: 8),
                              FieldData(
                                title: ("transaction_details_violation_amount")
                                    .tr(),
                                subTitle:
                                    state.details?.getViolationPenaltyAmount,
                              ),

                              const CustomVerticalSpace(height: 8),
                              FieldData(
                                title: ("transaction_details_violation_status")
                                    .tr(),
                                subTitle: state.details?.violationStatusName
                                    .toString(),
                              ),

                              //
                              const CustomVerticalSpace(height: 8),
                              FieldData(
                                title: ("transaction_details_license").tr(),
                                subTitle: state.details?.licenseNumberOrID,
                              ),

                              if (state.details?.licenseTypeName != null &&
                                  state.details!.licenseTypeName!
                                      .isNotEmpty) ...[
                                const CustomVerticalSpace(height: 8),
                                FieldData(
                                    title: ("transaction_details_license_type")
                                        .tr(),
                                    subTitle: state.details?.licenseTypeName)
                              ],

                              const CustomVerticalSpace(height: 8),
                              FieldData(
                                title:
                                    ("transaction_details_municiplaity").tr(),
                                subTitle: state.details?.municipalityName,
                              ),

                              const CustomVerticalSpace(height: 8),
                              FieldData(
                                title: ("transaction_details_submunicipality")
                                    .tr(),
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
                                title:
                                    ("transaction_details_noOfRepetition").tr(),
                                subTitle:
                                    state.details?.noOfRepetition.toString(),
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
                            leading:
                                SvgPicture.asset(IconPath.vdSummuryUserInfo),
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
                              title: ("موقع المخالفة").tr(),
                              leading:
                                  SvgPicture.asset(IconPath.vdSummuryUserInfo),
                              children: [
                                if (state.gisStatus == BlocStatus.success) ...[
                                  if (state.gisLocation?.streetName != null &&
                                      state.gisLocation!.streetName!.isNotEmpty)
                                    FieldData(
                                      title: "اسم الشارع",
                                      subTitle:
                                          state.gisLocation?.streetName ?? "",
                                    ),
                                  if (state.gisLocation?.districtName != null &&
                                      state.gisLocation!.districtName!
                                          .isNotEmpty)
                                    FieldData(
                                      title: "اسم الحي",
                                      subTitle:
                                          state.gisLocation?.districtName ?? "",
                                    )
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
                                  child: GoogleMap(
                                      markers: {
                                        Marker(
                                            visible:
                                                MapUtils.locationMarker != null,
                                            markerId:
                                                const MarkerId("storeLocation"),
                                            icon: MapUtils.locationMarker!,
                                            onTap: () {
                                              CommonFunctions.launchMap(LatLng(
                                                  state.details!.lat!,
                                                  state.details!.lon!));
                                            },
                                            position: LatLng(
                                                state.details!.lat!,
                                                state.details!.lon!))
                                      },
                                      myLocationEnabled: false,
                                      myLocationButtonEnabled: false,
                                      zoomControlsEnabled: false,
                                      initialCameraPosition: CameraPosition(
                                          target: LatLng(state.details!.lat!,
                                              state.details!.lon!),
                                          zoom: 13)),
                                ),
                              ],
                            ),
                          const ViolationClauses(),
                          (widget.params.details?.objectionRequestNumber !=
                                      null &&
                                  widget.params.details!.objectionRequestNumber!
                                      .isNotEmpty)
                              ? const ObjectionsData()
                              : const NoObjectionsData(),
                          Constants.verticalSpaceSmall,
                        ],
                      ),
                    )
                  ],
                ),
                BlocBuilder<TransactionDetailsBloc, TransactionDetailsState>(
                  builder: (context, state) {
                    return state.status == BlocStatus.loading
                        ? CustomCircularLoadingWidget()
                        : Container();
                  },
                ),
              ],
            ),
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
          leading: SvgPicture.asset(IconPath.vdSummuryUserInfo),
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
                        CustomTextWidget(
                          ("cluase_main_title").tr(),
                          fontColor: AppColor.black700,
                          fontSize: 13.0,
                          textAlign: TextAlign.start,
                          height: 1.3,
                        ),
                        CustomVerticalSpace(height: 8),
                        FieldData(
                          title: state.details?.nonComplianceClauses?[index]
                                  .clauseName ??
                              "",
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 32.0, top: 0),
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
                                          title: "ملاحظات المراقب",
                                          subTitle: state
                                                  .details
                                                  ?.nonComplianceClauses?[index]
                                                  .nonComplianceSubClauses?[i]
                                                  .notes ??
                                              "",
                                          /*    subTitleColor:
                                              AppColors.baladyDarkGreen2,
                                          leadingColor: AppColors.black,
                                          textColor: AppColors.black,
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
                                                itemBuilder: (ctx, i) {
                                                  return ObjectionAttachmentItem(
                                                      file: ReasonAttachment(
                                                          contentLocation: state
                                                                  .details
                                                                  ?.nonComplianceClauses![
                                                                      index]
                                                                  .nonComplianceSubClauses![
                                                                      i]
                                                                  .attachments![
                                                                      index]
                                                                  .contentLocation ??
                                                              "",
                                                          fileName: state
                                                                  .details
                                                                  ?.nonComplianceClauses![
                                                                      index]
                                                                  .nonComplianceSubClauses![
                                                                      i]
                                                                  .attachments![
                                                                      index]
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
            leading: SvgPicture.asset(IconPath.vdSummuryUserInfo),
            children: [
              GestureDetector(
                onTap: () {
                  context.read<TransactionDetailsBloc>().add(
                      GetTransactionDetailsEvent(
                          params: state.details?.objectionRequestNumber ?? ""));
                },
                child: FieldData(
                  title: ("transaction_details_objection_number").tr(),
                  subTitle: state.details?.objectionRequestNumber,
                ),
              ),
              FieldData(
                title: ("transaction_details_objection_status").tr(),
                subTitle: state.details?.objectionRequestStatusName,
              ),
              FieldData(
                  title: ("transaction_details_objection_descision").tr(),
                  subTitle: state.details?.objectionCommitteeDecision),
              FieldData(
                  title: ("transaction_details_objection_date").tr(),
                  subTitle: state.details?.objectionRequestDate)
            ]);
      },
    );
  }
}

class NoObjectionsData extends StatelessWidget {
  const NoObjectionsData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
    /* return BlocBuilder<TransactionDetailsBloc, TransactionDetailsState>(
      builder: (context, state) {
        return CustomEnhancedExpansionPanelWidget(
          expanded: true,
          underline: false,
          title: Helpers.translatingWord("objection_title_details"),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                Helpers.translatingWord("no_objections"),
                fontColor: AppColors.orange800,
                fontWeight: FONT_WEIGHT.medium,
                fontSize: 13,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
              CustomVerticalSpace(height: 16),
              if (data.isObjectionAllowed == true)
                IncidentSubmitButton(
                    btnText: Helpers.translatingWord("objection_apply"),
                    isButtonDisabled: false,
                    onPress: () {
                      NavigationService.navigatorKey.currentState!.pushNamed(
                          RoutesNames.CreateObjectionDetails,
                          arguments: CreateObjectionPageParams(
                              details: data, delegator: delegator));
                    }),
            ],
          ),
        );
      },
    );*/
  }
}
