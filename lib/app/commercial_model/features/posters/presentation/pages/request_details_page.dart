import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/commercial_model/features/posters/presentation/blocs/posters_license_bloc.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:collection/collection.dart';

import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import '../../../../../features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../../features/_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../../../features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../../../features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/details_header.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/notes_widget.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/home_page/presentation/widgets/home_tag.dart';
import '../../data/models/allowed_actions_response.dart';
import '../../data/models/poster_request_details_model.dart';
import '../widgets/edit_posters_dialog.dart';
import '../widgets/individual_request_widget.dart';
import '../widgets/steps/step2/poster_view_item_widget.dart';

class PostersReqeuestDetailsPage extends StatelessWidget {
  const PostersReqeuestDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    return BlocProvider(
      create: (context) =>
          PostersLicenseBloc(requestId: int.tryParse(data['requestNumber']))
            ..add(GetPosterRequestDetailsEvent()),
      child: BlocListener<PostersLicenseBloc, PostersLicenseState>(
        listener: (context, state) {},
        child: BlocConsumer<PostersLicenseBloc, PostersLicenseState>(
          listener: (context, state) {
            if (state.detailsStatus == BlocStatus.failure ||
                state.status == BlocStatus.failure) {
              CommonFunctions.showError(state.error ?? "");
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColor.white2,
              appBar: DetailsHeader(
                titleWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      "request".tr(),
                      fontSize: 20,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern700Light,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    CustomTextWidget(
                      "#${state.requestId}",
                      fontSize: 14,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                      fontWeight: AppFontWeight.medium,
                      fontColor: AppColor.blackModern700Light,
                    ),
                  ],
                ),
                procedures: () async {
                  List<AllowedActionItem> act = await context
                          .read<PostersLicenseBloc>()
                          .getAllowedActions() ??
                      [];
                  await BottomSheetDialog.showDraggableSheet(context,
                      isFullHeight: false,
                      height: 250, //MM
                      //   dialogKeyName: DialogName.complianceRequestActionsDialog,
                      //  currentRouteName: CommercialRouteName.complianceDetailsPage,
                      child: BottomSheetWithActions(
                        title: "actions".tr(),
                        body: Column(
                            children: act.isNotEmpty
                                ? act.map((e) {
                                    return GestureDetector(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        print(state.requestDetails?.alerts);
                                        if (e.id == "edit") {
                                          await BottomSheetDialog
                                              .showDraggableSheet(context,
                                                  isFullHeight: true,
                                                  child: BlocProvider.value(
                                                      value: context.read<
                                                          PostersLicenseBloc>(),
                                                      child:
                                                          EditPostersDialog()));
                                        }

                                        if (e.id == "cancel") {
                                          showCancelConfirmDialog(() {
                                            context
                                                .read<PostersLicenseBloc>()
                                                .add(
                                                    DeletePosterRequestEvent());
                                            Navigator.of(context).pop();
                                          }, state.requestId!);
                                        }
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: FieldData(
                                          title: e.actionName ?? "",
                                        ),
                                      ),
                                    );
                                  }).toList()
                                : [
                                    Center(
                                      child: CustomTextWidget(
                                        ('data_not_have_actions').tr(),
                                        fontSize: 14,
                                        fontColor: AppColor.primary900Light,
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ]),
                      ));
                },
              ),
              body: Stack(
                children: [
                  if (state.detailsStatus == BlocStatus.success)
                    Padding(
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
                                      state.requestDetails?.creationDate ?? "",
                                      fontColor: AppColor.blackModern500Light,
                                      fontSize: 12,
                                      fontWeight: AppFontWeight.bold,
                                    )
                                  ],
                                ),
                                HomeTag(
                                  title: state.requestDetails?.requestStatus
                                          ?.name ??
                                      "",
                                  backgroundColor: AppColor.secondary100Light,
                                )
                              ],
                            ),
                            const CustomVerticalSpace(height: 16),
                            IndivisualRequestsData(),
                            const CustomVerticalSpace(height: 16),
                            Step2SummeryWidget(),
                            CustomVerticalSpace(height: 16),
                            if (state.requestDetails?.requestNotes != null &&
                                state.requestDetails!.requestNotes!.isNotEmpty)
                              ExpandableCard(
                                title: 'responses_request'.tr(),
                                icon: IconPath.vdSummurySPL,
                                children: [
                                  state.requestDetails?.requestNotes != null
                                      ? ListView.builder(
                                          itemCount: state.requestDetails
                                              ?.requestNotes!.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (ctx, index) {
                                            RequestNote? requestNotesInfo =
                                                state.requestDetails
                                                    ?.requestNotes![index];
                                            return Card(
                                              color: AppColor.primary100Light,
                                              margin: const EdgeInsets.only(
                                                  top: 16),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        CustomTextWidget(
                                                          ('notes_').tr(),
                                                          fontSize: 12,
                                                          fontColor: AppColor
                                                              .primary900Light,
                                                          fontWeight:
                                                              AppFontWeight
                                                                  .bold,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        const Spacer(),
                                                        CustomTextWidget(
                                                          requestNotesInfo
                                                                  ?.date ??
                                                              "",
                                                          fontSize: 12,
                                                          fontColor: AppColor
                                                              .blackModern500Light,
                                                          fontWeight:
                                                              AppFontWeight
                                                                  .bold,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 16),
                                                    CustomTextWidget(
                                                      requestNotesInfo?.note ??
                                                          "",
                                                      fontSize: 12,
                                                      maxLines: 100,
                                                      fontColor: AppColor
                                                          .blackModern600Light,
                                                      fontWeight:
                                                          AppFontWeight.regular,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : const SizedBox()
                                ],
                              ),
                          ],
                        ))),
                  if (state.detailsStatus == BlocStatus.loading ||
                      state.status == BlocStatus.loading)
                    CustomCircularLoadingWidget(),
                  if (state.detailsStatus == BlocStatus.failure)
                    ReloadWidget(
                      onTab: () {
                        context
                            .read<PostersLicenseBloc>()
                            .add(const GetPosterRequestDetailsEvent());
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void showCancelConfirmDialog(Function onConfirm, int requestId) {
    BottomSheetDialog.showDraggableSheet(
      NavigationService.navigatorKey.currentContext!,
      child: BottomSheetWithActions(
          title: "",
          action: Row(
            children: [
              Expanded(
                child: ElevatedButtonWidget.primaryCustom(
                    text: "poster_cancel_confirm_yes".tr(),
                    onPressed: () {
                      onConfirm();
                    }),
              ),
              const CustomHorizontalSpace(width: 32),
              Expanded(
                child: ElevatedButtonWidget.primaryCustomBorder(
                    text: "poster_cancel_confirm_no".tr(),
                    onPressed: () {
                      NavigationService.goBack();
                    }),
              ),
            ],
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomVerticalSpace(height: 32),
              NotesWidget(notes: [
                "poster_cancel_confirm_msg"
                    .tr()
                    .replaceAll("{}", requestId.toString())
              ])
            ],
          )),
    );
  }
}

class Step2SummeryWidget extends StatelessWidget {
  const Step2SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostersLicenseBloc, PostersLicenseState>(
      builder: (context, state) {
        List<Widget> posters = [
          const CustomVerticalSpace(
            height: 16,
          ),
          if (state.requestDetails?.licenseId != null) ...[
            FieldData(
              title: "posters_permit_licesnse_id".tr(),
              subTitle: state.requestDetails?.licenseId.toString(),
            ),
            const CustomVerticalSpace(
              height: 16,
            ),
            if (state.requestDetails?.licenseStatus != null)
              FieldData(
                title: "posters_permit_licesnse_status".tr(),
                subTitle: state.requestDetails?.licenseStatus?.name,
              ),
            const CustomVerticalSpace(
              height: 16,
            ),
            FieldData(
              title: "posters_permit_licesnse_expiry".tr(),
              subTitle: state.requestDetails?.licenseExpirationDate?.toString(),
            ),
            const CustomVerticalSpace(
              height: 16,
            ),
          ],
          if (state.requestDetails?.municipality != null &&
              state.requestDetails?.subMunicipality != null)
            FieldData(
              title: "posters_permit_mun_sub".tr(),
              subTitle:
                  "${state.requestDetails?.municipality?.name.toString()}, ${state.requestDetails?.subMunicipality?.name.toString()}",
            ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: "posters_permit_start_date".tr(),
            subTitle: state.requestDetails?.permitIssuingDate?.toString(),
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: "posters_permit_end_date".tr(),
            subTitle: state.requestDetails?.permitEndDate?.toString(),
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: "posters_permit_duration".tr(),
            subTitle: state.requestDetails?.permitDuration?.toString(),
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          if (state.requestDetails?.billNumber?.isNotEmpty ?? false)
            FieldData(
              title: "posters_bill_number".tr(),
              subTitle: state.requestDetails?.billNumber,
            ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: state
                .requestDetails?.costCalculationInfo?.postersCountDescription,
            subTitle: state.requestDetails?.costCalculationInfo?.postersCount
                    .toString() ??
                "",
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: state
                .requestDetails?.costCalculationInfo?.postersAreaSumDescription,
            subTitle:
                "${state.requestDetails?.costCalculationInfo?.postersAreaSum}  ${'poster_cm2'.tr()}",
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title:
                state.requestDetails?.costCalculationInfo?.totalCostDescription,
            subTitle:
                "${state.requestDetails?.costCalculationInfo?.totalCost}  ${'sar'.tr()}",
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
        ];
        posters.addAll((state.requestDetails?.posters ?? []).mapIndexed((i, e) {
          return PosterViewItemWidget(
            index: i + 1,
            item: e,
            showTitle: true,
            showChangeImage: false,
          );
        }).toList());

        return ExpandableCard(
          title: ("posters_data").tr(),
          icon: IconPath.vdSummurySPL,
          children: posters,
        );
      },
    );
  }
}

class IndivisualRequestsData extends StatelessWidget {
  const IndivisualRequestsData({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostersLicenseBloc, PostersLicenseState>(
      builder: (context, state) {
        return state.requestDetails?.individualRequests != null &&
                state.requestDetails!.individualRequests!.isNotEmpty
            ? ExpandableCard(
                title: ("posters_indivisual_requests").tr(),
                icon: IconPath.vdSummurySPL,
                children: (state.requestDetails?.individualRequests ?? [])
                    .mapIndexed((i, e) {
                  return IndividualRequestWidget(item: e);
                }).toList(),
              )
            : const SizedBox();
      },
    );
  }
}
