import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import '../../../../../features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../../features/_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../../../features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../../../features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/details_header.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/notes_widget.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/payment_widget.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/summery_widgets/field_data.dart';
import 'package:balady_plus/app/features/home_page/presentation/widgets/home_tag.dart';
import '../../data/models/allowed_actions_response.dart';
import '../../data/models/permit_request_details_model.dart';
import '../blocs/permit_tobacco_bloc.dart';

class PermitsTobaccoReqeuestDetailsPage extends StatefulWidget {
  const PermitsTobaccoReqeuestDetailsPage({super.key});

  @override
  State<PermitsTobaccoReqeuestDetailsPage> createState() =>
      _PermitsTobaccoReqeuestDetailsPageState();
}

class _PermitsTobaccoReqeuestDetailsPageState
    extends State<PermitsTobaccoReqeuestDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendUXCamEvent(UXCamEvents.detailsServiceTobaccoPermit);
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    return BlocProvider(
      create: (context) => PermitTobaccoLicenseBloc(
          requestId: int.tryParse(data['requestNumber']))
        ..add(const GetPermitRequestDetailsEvent()),
      child: BlocListener<PermitTobaccoLicenseBloc, PermitTobaccoLicenseState>(
        listener: (context, state) {},
        child:
            BlocConsumer<PermitTobaccoLicenseBloc, PermitTobaccoLicenseState>(
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
                    if (state.requestDetails?.requestInfo?.requestId != null)
                      CustomTextWidget(
                        "#${state.requestDetails?.requestInfo?.requestId}",
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
                          .read<PermitTobaccoLicenseBloc>()
                          .getAllowedActions() ??
                      [];
                  await BottomSheetDialog.showDraggableSheet(context,
                      isFullHeight: false,
                      height: 250,
                      //MM
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
                                        if (e.id == "cancel") {
                                          showCancelConfirmDialog(() {
                                            context
                                                .read<
                                                    PermitTobaccoLicenseBloc>()
                                                .add(
                                                    DeletePermitRequestEvent());
                                            Navigator.of(context).pop();
                                          }, state.requestId!);
                                        }

                                        if (e.id == "edit") {
                                          NavigationService
                                              .navigatorKey.currentState!
                                              .pushNamed(
                                                  RouteName
                                                      .permitsTobaccoDetailsPage,
                                                  arguments: context.read<
                                                      PermitTobaccoLicenseBloc>());
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
                                      state.requestDetails?.requestInfo
                                              ?.requestCreationDate ??
                                          "",
                                      fontColor: AppColor.blackModern500Light,
                                      fontSize: 12,
                                      fontWeight: AppFontWeight.bold,
                                    )
                                  ],
                                ),
                                HomeTag(
                                  title: state.requestDetails?.requestInfo
                                          ?.requestStatusDesc ??
                                      "",
                                  backgroundColor: AppColor.secondary100Light,
                                )
                              ],
                            ),
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
                            const CustomVerticalSpace(height: 32),
                            if (state.requestDetails?.requestInfo
                                        ?.requestStatusCode ==
                                    15 &&
                                state.requestDetails?.requestInfo?.billInfo !=
                                    null)
                              PaymentWidget(
                                requestKey: state.requestDetails?.requestInfo
                                        ?.billInfo?.billKey ??
                                    "",
                                billNumber: state.requestDetails?.requestInfo
                                        ?.billInfo?.billNumber ??
                                    "",
                              )
                          ],
                        ))),
                  if (state.detailsStatus == BlocStatus.loading ||
                      state.status == BlocStatus.loading)
                    CustomCircularLoadingWidget(),
                  if (state.detailsStatus == BlocStatus.failure)
                    ReloadWidget(
                      onTab: () {
                        context
                            .read<PermitTobaccoLicenseBloc>()
                            .add(const GetPermitRequestDetailsEvent());
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
                "permit_tobacco_cancel_confirm_msg"
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
    return BlocBuilder<PermitTobaccoLicenseBloc, PermitTobaccoLicenseState>(
      builder: (context, state) {
        return ExpandableCard(
            title: "permit_24_data".tr(),
            icon: IconPath.vdSummurySPL,
            children: [
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: "license_no".tr(),
                subTitle: state.requestDetails?.licenseInfo?.licenseNumber
                        .toString() ??
                    "",
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: "invoice_no".tr(),
                subTitle: state.requestDetails?.requestInfo?.billNumber,
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: "municipality".tr(),
                subTitle: state.requestDetails?.locationInfo?.municipalityName,
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: "sub_municipality".tr(),
                subTitle:
                    state.requestDetails?.locationInfo?.subMunicipalityName,
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              if (state.requestDetails?.licenseInfo?.permitNumber != null) ...[
                FieldData(
                  title: "permit_24_permit_no".tr(),
                  subTitle: state.requestDetails?.licenseInfo?.permitNumber
                          .toString() ??
                      "",
                ),
                const CustomVerticalSpace(
                  height: 16,
                ),
              ],
              /* if (state.requestDetails?.licenseInfo?.permitIssueDate != null) ...[
              FieldData(
                title: "posters_permit_start_date".tr(),
                subTitle: state.requestDetails?.licenseInfo?.permitIssueDate,
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
            ],*/
              if (state.requestDetails?.licenseInfo?.permitEndDate != null) ...[
                FieldData(
                  title: "posters_permit_end_date".tr(),
                  subTitle: state.requestDetails?.licenseInfo?.permitEndDate,
                ),
                const CustomVerticalSpace(
                  height: 16,
                ),
              ],
              FieldData(
                  title: "licence_inside_hotel".tr(),
                  subTitle: state.requestDetails?.requestInfo?.hotelInfo != null
                      ? "yes".tr()
                      : "no".tr()),
              const CustomVerticalSpace(
                height: 16,
              ),
              if (state.requestDetails?.requestInfo?.hotelInfo != null) ...[
                FieldData(
                    title: "hotel_license_number".tr(),
                    subTitle: state.requestDetails?.requestInfo?.hotelInfo
                            ?.licenseNumber
                            .toString() ??
                        ""),
                const CustomVerticalSpace(
                  height: 16,
                ),
                FieldData(
                    title: "hotel_name".tr(),
                    subTitle: state
                            .requestDetails?.requestInfo?.hotelInfo?.hotelName
                            .toString() ??
                        ""),
                const CustomVerticalSpace(
                  height: 16,
                ),
                FieldData(
                    title: "hotel_class".tr(),
                    subTitle: state.requestDetails?.requestInfo?.hotelInfo
                            ?.hotelClassDesc ??
                        ""),
              ]
            ]);
      },
    );
  }
}
