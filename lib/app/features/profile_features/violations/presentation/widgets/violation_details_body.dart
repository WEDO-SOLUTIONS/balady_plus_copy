import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, AppStyle, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CardParameter, CustomHorizontalSpace, CustomSvgIconWidget, CustomTextWidget, CustomVerticalSpace, DrawIconBasedTypeWidget, ExpandableCard, MessageDialog, ShimmerEffectWidget;
import '../../../../objectable_transactions/presentation/widgets/create_objection_page/objection_attachment_item.dart';
import '../../../../objections/domain/entities/objection_details.dart';
import '../../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../../violations_exports.dart';

class ViolationDetailBody extends StatefulWidget {
  final ViolationsEntity violationsEntity;

  const ViolationDetailBody({
    super.key,
    required this.violationsEntity,
  });

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
              child: Column(
                children: [
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
                        child:  Row(
                          children: [
                            const CustomSvgIconWidget(
                                IconPath.informationCircleIcon),
                            const CustomHorizontalSpace(width: 12),
                            CustomTextWidget(
                              "objectionPeriodExpired".tr(),
                              fontColor: AppColor.orange800,
                              fontWeight: AppFontWeight.medium,
                              fontSize: 13,
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )),
                  Row(
                    children: [
                      const DrawIconBasedTypeWidget(
                        icon: IconPath.calender,
                        iconSize: 24,
                      ),
                      const SizedBox(width: 4),
                      CustomTextWidget(
                        widget.violationsEntity.objectionLastApplyDateStr,
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
                                widget.violationsEntity.billStatusName ?? "",
                                textStyle: AppStyle.tagTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ExpandableCard(
                    title: 'transaction_details_data'.tr(),
                    icon: IconPath.vdSummuryDesc,
                    isExpandedByDefault: true,
                    children: [
                      CardParameter(
                        title: 'transaction_details_id'.tr(),
                        value: widget.violationsEntity.violationNumber ?? "",
                      ),
                      CardParameter(
                        title: 'transaction_details_desc'.tr(),
                        value:
                            widget.violationsEntity.violationDescription ?? "",
                      ),
                      CardParameter(
                        title: 'transaction_details_date'.tr(),
                        value: widget.violationsEntity.violationIssueDateStr,
                      ),
                      CardParameter(
                        title: "transaction_details_license".tr(),
                        value: widget.violationsEntity.licenseNumber ?? "",
                      ),
                      CardParameter(
                        title: "transaction_details_license_type".tr(),
                        value: widget.violationsEntity.licenseTypeName ?? "",
                      ),
                      CardParameter(
                        title: "transaction_details_municiplaity".tr(),
                        value: widget.violationsEntity.municipalityName ?? "",
                      ),
                      CardParameter(
                        title: "transaction_details_caluse".tr(),
                        value: widget.violationsEntity.regulationClause ?? "",
                      ),
                      CardParameter(
                        title: "transaction_details_noOfRepetition".tr(),
                        value: state.details?.noOfRepetition?.toString() ?? "",
                      ),
                      CardParameter(
                        title: "transaction_details_noOfUnits".tr(),
                        value: state.details?.noOfUnits?.toString() ?? "",
                      ),
                      CardParameter(
                        title: "transaction_details_last_date".tr(),
                        value:
                            widget.violationsEntity.objectionLastApplyDateStr,
                      ),
                      CardParameter(
                        title: "transaction_details_violation_status".tr(),
                        value:
                            widget.violationsEntity.violationStatusName ?? "",
                      ),
                      CardParameter(
                        title: "transaction_details_violation_amount".tr(),
                        value:
                            widget.violationsEntity.violationAmount.toString(),
                      ),
                    ],
                  ),
                  ExpandableCard(
                    title: 'transaction_details_bill_data'.tr(),
                    icon: IconPath.vdSummuryDesc,
                    children: [
                      CardParameter(
                        title: 'transaction_details_bill_number'.tr(),
                        value: widget.violationsEntity.billNumber ?? "",
                      ),
                      CardParameter(
                        title: 'transaction_details_bill_total'.tr(),
                        value: state.details?.getViolationPenaltyAmount ?? "",
                      ),
                      CardParameter(
                        title: 'transaction_details_bill_status'.tr(),
                        value: widget.violationsEntity.billStatusName ?? '',
                      ),
                    ],
                  ),
                  ExpandableCard(
                    title: ("transaction_details_clause_data").tr(),
                    icon: IconPath.vdSummuryDesc,
                    children: [
                      const SizedBox(height: 16),
                      MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                state.details?.nonComplianceClauses?.length ??
                                    0,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FieldData(
                                    title: " ${"reason".tr()} ${index + 1}",
                                    subTitle: state
                                            .details
                                            ?.nonComplianceClauses?[index]
                                            .clauseName ??
                                        "",
                                    radius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8)),
                                  ),
                                  FieldData(
                                    title: "lbl_attachments".tr(),
                                    radius: BorderRadius.zero,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: state
                                            .details
                                            ?.nonComplianceClauses![index]
                                            .nonComplianceSubClauses
                                            ?.length ??
                                        0,
                                    itemBuilder: (ctx, i) {
                                      if (state
                                              .details
                                              ?.nonComplianceClauses?[index]
                                              .nonComplianceSubClauses?[i]
                                              .attachments
                                              ?.isNotEmpty ??
                                          false) {
                                        return MediaQuery.removePadding(
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
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                  const CustomVerticalSpace(height: 8)
                                ],
                              );
                            }),
                      )
                    ],
                  ),
                  ExpandableCard(
                    title: 'objectionDetails'.tr(),
                    icon: IconPath.vdSummuryDesc,
                    children: [
                      CardParameter(
                        title: 'applicableObjection'.tr(),
                        value: state.details?.objectionApplicableName ?? "",
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
